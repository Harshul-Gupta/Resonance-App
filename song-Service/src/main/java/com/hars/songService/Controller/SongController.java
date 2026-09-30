package com.hars.songService.Controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;

import com.hars.songService.Event.ArtistEvent;
import com.hars.songService.Repository.ArtistLookup;
import com.hars.songService.Repository.ArtistLookupRepository;
import com.hars.songService.Repository.PresignedUploadRequest;
import com.hars.songService.Repository.PresignedUploadResponse;
import com.hars.songService.Repository.Song;
import com.hars.songService.Repository.SongCreationDTO;
import com.hars.songService.Service.S3SongService;
import com.hars.songService.Service.SongService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/songs")
public class SongController {
	
	private final SongService songService;
	private final S3SongService s3SongService;
	
	@Autowired
	ArtistLookupRepository artistLookupRepository;
	
	@Autowired
	private WebClient webClient;

	SongController(SongService songService, S3SongService s3SongService) {
		this.songService = songService;
		this.s3SongService = s3SongService;
	}

	@GetMapping("/{id}")
	public ResponseEntity<Song> getSongById(@PathVariable(required = true) Long id) throws RuntimeException{
		
		Song song = songService.findByIdSong(id);
		return new ResponseEntity<>(song, HttpStatus.OK);
	}
	
	@GetMapping("artist/{mongoId}")
	public ResponseEntity<List<Song>> getAllSongsByArtistId(@PathVariable(required = true) String mongoId) throws RuntimeException{
		List<Song> songsList = songService.findByArtistId(mongoId);
		
		return new ResponseEntity<>(songsList, HttpStatus.OK);
	}
	
	@PostMapping("/presigned-url")
	public ResponseEntity<PresignedUploadResponse> getPreSignedUrl(@RequestBody PresignedUploadRequest request){
		PresignedUploadResponse response = s3SongService.generatePresignedUploadUrl(request.fileName(), request.contentType());
		return new ResponseEntity<>(response, HttpStatus.OK);	
	}
	
	@PostMapping
	public ResponseEntity<Song> addSong(@Valid @RequestBody SongCreationDTO song){
		Song uploadedSong = songService.addSong(song);
		return new ResponseEntity<>(uploadedSong, HttpStatus.CREATED);	
	}
	
	@PatchMapping("/{id}")
	public ResponseEntity<String> updateSong(@PathVariable(required = true) Long id, @RequestBody Map<String, Object> updates){ 
		songService.updateSong(id, updates);
		return ResponseEntity.ok("Song Updated successfully");
	}
	
	@DeleteMapping("/{id}")
	public ResponseEntity<String> deleteSongById(@PathVariable(required = true) Long id) throws RuntimeException
	{
		songService.removeSong(id);
		return ResponseEntity.ok("Song removed successfully");
	}
	
	//Only used for initial sync of artists when artists are populated in back-end directly 
	@PostMapping("/sync/artists")
	public ResponseEntity<String> syncExistingArtists() {
		String artistServiceUrl = "http://ArtistRegistry/api/artists/artistEvents";
	
		List<ArtistEvent> existingArtists = webClient.get()
												.uri(artistServiceUrl)
												.retrieve()
												.bodyToFlux(ArtistEvent.class)
												.collectList()
												.block();
												
		for(ArtistEvent artist : existingArtists)
		{
			if(!artistLookupRepository.existsById(artist.getMongoId()))
			{
				ArtistLookup lookup = ArtistLookup.builder()
										.artistMongoId(artist.getMongoId())
										.artistName(artist.getArtistName())
										.build();
				artistLookupRepository.save(lookup);
			}
		}
		return new ResponseEntity<String>("Synced existing artists successfully", HttpStatus.CREATED);
	}

}
