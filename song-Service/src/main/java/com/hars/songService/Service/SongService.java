package com.hars.songService.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.kafka.common.errors.ResourceNotFoundException;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;

import com.fasterxml.jackson.core.type.TypeReference;
import com.hars.songService.Repository.ArtistLookup;
import com.hars.songService.Repository.ArtistLookupRepository;
import com.hars.songService.Repository.Song;
import com.hars.songService.Repository.SongCreationDTO;
import com.hars.songService.Repository.SongRepository;

import jakarta.ws.rs.BadRequestException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SongService {
	
	private final SongRepository songRepository;
	private final ArtistLookupRepository artistLookupRepo;
	private final S3SongService s3SongService;
	private final ObjectMapper objectMapper;

	SongService(SongRepository songRepository, ArtistLookupRepository artistLookupRepo, S3SongService s3SongService, ObjectMapper objectMapper) {
		this.songRepository = songRepository;
		this.artistLookupRepo = artistLookupRepo;
		this.s3SongService = s3SongService;
		this.objectMapper = objectMapper;
	}

	public Song findByIdSong(Long id) throws RuntimeException{
		
		return songRepository.findById(id).orElseThrow(() -> new RuntimeException("Song"));
	}
	
	public List<Song> findByArtistId(String mongoId){
		
		List<Song> songs = songRepository.getSongsByArtistId(mongoId);
		return songs;
	}
	
	@Transactional
	public Song addSong(SongCreationDTO song) {
		Set<String> artistIds = song.getArtistIds();

		if(artistIds==null || artistIds.isEmpty())
			throw new BadRequestException("A song must be associated with atleast one artist");
		
		List<ArtistLookup> ArtistsFound = new ArrayList<>();
		ArtistsFound = artistLookupRepo.findAllById(artistIds);
		if(ArtistsFound.size()!=artistIds.size())
			throw new ResourceNotFoundException("One or more artists not found");
		Set<ArtistLookup> sArtistLookups = new HashSet<>(ArtistsFound); 
		Song createdSong = Song.builder()
							.songName(song.getSongName())
							.albumName(song.getAlbumName())
							.artists(sArtistLookups)
							.duration(song.getDuration())
							.s3URL(song.getS3URL())
							.build();
		
		return songRepository.save(createdSong);
	}
	
	@Transactional
	public void removeSong(Long id) {
		
		Song song = songRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Song not found"));
		songRepository.delete(song);
		if(song.getS3URL()!=null) {
			try {
			s3SongService.deleteSong(song.getS3URL());
			log.info("Deleted " + song.getSongName() + " from S3");
			}
			catch (Exception e) {
				log.error("Failed to delete underlying file: " + song.getS3URL()+ " from cloud "+ e.getMessage());	
			}
		}
	}
	
	@Transactional
	public void removeSongByArtistId(String artistMongoId) {
		List<Song> songs = songRepository.getSongsByArtistId(artistMongoId);
		List<Song> deleteSongs = new ArrayList<>();
		List<Song> saveSongs = new ArrayList<>();
		for(Song song : songs)
		{
			song.getArtists().removeIf(artist -> artist.getArtistMongoId().equals(artistMongoId));
			
			if(song.getArtists().isEmpty())
				deleteSongs.add(song);
			else 
				saveSongs.add(song);
		}
		
		songRepository.deleteAll(deleteSongs);
		log.info("Deleted {} orphaned songs from the database.", deleteSongs.size());
		songRepository.saveAll(saveSongs);
		log.info("Updated {} songs that still have other active artists.", saveSongs.size());
		
		for(Song song : deleteSongs)
		{
			if(song.getS3URL()!=null) {
				try {
					s3SongService.deleteSong(song.getS3URL());
				}catch (Exception e) {
					log.error("Failed to delete underlying file: " + song.getS3URL()+ " from cloud "+ e.getMessage());
				}
			}
		}
	}

	@Transactional
	public void updateSong(Long id, Map<String, Object> updates) {
		Song existingSong = songRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Song not found"));

		updates.forEach((K, V)-> {
			switch (K) {
			case "songName" -> existingSong.setSongName(V.toString());
			case "duration" -> existingSong.setDuration(objectMapper.convertValue(V, Integer.class));
			case "albumName" -> existingSong.setAlbumName(V.toString());
			case "artists" -> {
				Set<String> artistIds = objectMapper.convertValue(V, new TypeReference<Set<String>>(){});
				List<ArtistLookup> ArtistsFound = artistLookupRepo.findAllById(artistIds);
				if(ArtistsFound.size()!=artistIds.size())
					throw new ResourceNotFoundException("One or more artists not found");
				existingSong.setArtists(new HashSet<>(ArtistsFound));
			}
			case "s3Url" -> {
				String s3Url = existingSong.getS3URL();
				if(s3Url!=null) {
					try {
					s3SongService.deleteSong(s3Url);
					log.info("Deleted " + existingSong.getSongName() + " from S3");
					}
					catch (Exception e) {
						log.error("Failed to delete underlying file: " + s3Url+ " from cloud "+ e.getMessage());	
					}
				}
				existingSong.setS3URL(V.toString());
			}
			}
		});
		
		songRepository.save(existingSong);
	}
}
