package com.hars.ArtistRegistry.Service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.hars.ArtistRegistry.Event.ArtistEvent;
import com.hars.ArtistRegistry.Repository.Artist;
import com.hars.ArtistRegistry.Repository.ArtistRepo;

import tools.jackson.databind.ObjectMapper;

@Service
public class ArtistService {
	
	private final ArtistRepo artistRepo;
	private final ObjectMapper objectMapper;
	private final S3ImageService s3ImageService;
	private final MongoTemplate mongoTemplate;
	private final ArtistEventProducer artistEventProducer;
	
	public ArtistService(ArtistRepo artistRepo, ObjectMapper objectMapper, S3ImageService s3ImageService, MongoTemplate mongoTemplate, ArtistEventProducer artistEventProducer) {
		
		this.artistRepo = artistRepo;
		this.objectMapper = objectMapper;
		this.s3ImageService = s3ImageService;
		this.mongoTemplate = mongoTemplate;
		this.artistEventProducer = artistEventProducer;
	}
	
	public Artist createArtist(Artist artist, MultipartFile file) throws IOException{
		
		String publicS3Url = s3ImageService.uploadArtistImage(file);
		artist.setImageURL(publicS3Url);
		Artist newArtist = artistRepo.save(artist);
		
		artistEventProducer.sendArtistEvent("ARTIST_CREATED", newArtist.getMongoId(), newArtist.getName());
		return newArtist;
	}
	
	public Artist updateArtist(String mongoId, Map<String, Object> updates, MultipartFile file)
	{
		Artist existingArtist= artistRepo.findById(mongoId).orElseThrow(() -> new RuntimeException("Artist not found"));
		
		Artist updatedArtist= objectMapper.convertValue(updates, Artist.class);
		
		boolean deleteImage= false;
		String oldImageURL= existingArtist.getImageURL();
		
		if(file!=null && !file.isEmpty())
		{
			try {
			String newImageURL= s3ImageService.uploadArtistImage(file);
			existingArtist.setImageURL(newImageURL);
			deleteImage= true;
			}catch (Exception e) {
				throw new RuntimeException("Failure to upload image");
			}
		}
		
		updates.forEach((K, V) -> {
			switch (K) {
			case "name" -> { 
				if(V == null || V.toString().isBlank())
					throw new IllegalArgumentException("Name can't be blank");
				existingArtist.setName(updatedArtist.getName());
			}
			case "bio" -> existingArtist.setBio(updatedArtist.getBio());
			case "country" -> existingArtist.setCountry(updatedArtist.getCountry());
			case "genre" -> existingArtist.setGenre(updatedArtist.getGenre());
			case "type" -> existingArtist.setType(updatedArtist.getType());
			}	
		});
		
		Artist newArtist = artistRepo.save(existingArtist);
		
		if(deleteImage && oldImageURL!=null && !oldImageURL.isBlank() && oldImageURL.contains("image/")) 
		{
			String key= oldImageURL.substring(oldImageURL.lastIndexOf("image/"));
			s3ImageService.deleteArtistImage(key);
		}
		return newArtist;
	}
	
	public void deleteArtist(String mongoId)
	{
		Artist artist= artistRepo.findById(mongoId).orElseThrow(() -> new IllegalArgumentException("Artist not found"));
		String imageURL= artist.getImageURL();
		if(imageURL != null && !imageURL.isBlank() && imageURL.contains("image/"))
		{
			String key= imageURL.substring(imageURL.lastIndexOf("image/"));
			s3ImageService.deleteArtistImage(key);
		}
		artistRepo.delete(artist);
		
		artistEventProducer.sendArtistEvent("ARTIST_DELETED", mongoId, artist.getName());
	}
	
	public void incrementViewCount(String artistId) {
		
		Query query = new Query(Criteria.where("mongoId").is(artistId));
		Update update = new Update().inc("viewCount", 1);
		mongoTemplate.updateFirst(query, update, Artist.class);
	}

	public List<ArtistEvent> getArtistEvents() {
		
		return artistRepo.findAll().stream().map(a -> ArtistEvent.builder()
															.artistName(a.getName())
															.mongoId(a.getMongoId())
															.build()).toList();
	}
}
