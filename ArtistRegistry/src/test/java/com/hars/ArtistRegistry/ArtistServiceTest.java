package com.hars.ArtistRegistry;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.mongodb.test.autoconfigure.DataMongoTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.context.annotation.Import;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.web.multipart.MultipartFile;
import org.testcontainers.containers.MongoDBContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import com.hars.ArtistRegistry.Repository.Artist;
import com.hars.ArtistRegistry.Repository.ArtistRepo;
import com.hars.ArtistRegistry.Repository.ArtistType;
import com.hars.ArtistRegistry.Service.ArtistService;
import com.hars.ArtistRegistry.Service.S3ImageService;

import tools.jackson.databind.ObjectMapper;

@DataMongoTest
@Testcontainers
@Import({ArtistService.class, ObjectMapper.class})
public class ArtistServiceTest {
	
	@Container
	@ServiceConnection
	static MongoDBContainer mongoDBContainer = new MongoDBContainer(DockerImageName.parse("mongo:7.0"));
	
	@Autowired
	private ArtistRepo artistRepo;
	
	@Autowired
	private ArtistService artistService;
	
	@Autowired
	private MongoTemplate mongoTemplate;
	
	@BeforeEach
	void setUp() {
		mongoTemplate.dropCollection(Artist.class);
	}

	@MockitoBean
	private S3ImageService s3ImageService;
	
	@Test
	void incrementViewCountTest(){
		
		Artist artist= Artist.builder().mongoId("artist-xyz").id("1").name("Martin Garrix").viewCount(0L).build();
		mongoTemplate.save(artist);
		
		artistService.incrementViewCount("artist-xyz");
		
		Artist artistRecord = mongoTemplate.findById("artist-xyz", Artist.class);
		
		assertNotNull(artistRecord);
		assertEquals(artistRecord.getViewCount(), 1L);
		
		artistService.incrementViewCount("artist-xyz");
		
		Artist secondRecord = mongoTemplate.findById("artist-xyz", Artist.class);
		
		assertEquals(secondRecord.getViewCount(), 2L);
	}
	
	@Test
	void updateArtist_whenNoArtistFound() {
		
		RuntimeException exception=  assertThrows(RuntimeException.class, () -> artistService.updateArtist("xyz", null, null));
		assertEquals(exception.getMessage(), "Artist not found");
	}
	
	@Test
	void updateArtist_withNoImageFile() {
		
		Artist existingArtist= Artist.builder()
				.name("Fred Again")
				.bio("Random bio")
				.country("UK")
				.genre(new HashSet<>(Set.of("EDM", "House", "Electronic")))
				.mongoId("TestID")
				.build();
		artistRepo.save(existingArtist);
		Map<String, Object> mp= new HashMap<>();
		mp.put("name", "Sam");
		mp.put("bio", "Test bio");
		mp.put("country", "Canada");
		mp.put("genre", new HashSet<>(Set.of("Classical", "Indie")));
		mp.put("type", ArtistType.solo);
		
		Artist newArtist= artistService.updateArtist("TestID", mp, null);
		assertNotNull(newArtist);
		assertEquals("Sam", newArtist.getName());
		assertEquals("Test bio", newArtist.getBio());
		assertEquals("Canada", newArtist.getCountry());
		assertEquals(Set.of("Classical", "Indie"), newArtist.getGenre());
		assertEquals(ArtistType.solo, newArtist.getType());
		
	}
	
	@Test
	void updateArtist_withImageFile() throws IOException{
		
		Artist existingArtist= Artist.builder()
				.name("Fred Again")
				.bio("Random bio")
				.country("UK")
				.genre(new HashSet<>(Set.of("EDM", "House", "Electronic")))
				.mongoId("TestID")
				.imageURL("https://s3.amazonaws.com/bucket/image/old-image.jpg")
				.build();
		artistRepo.save(existingArtist);
		Map<String, Object> mp= new HashMap<>();
		mp.put("name", "Sam");
		MultipartFile file = new MockMultipartFile("file", "new-image.jpg", "image/jpeg", "image".getBytes());
		when(s3ImageService.uploadArtistImage(file)).thenReturn("https://s3.amazonaws.com/bucket/image/new-image.jpg");
		
		Artist newArtist= artistService.updateArtist("TestID", mp, file);
		assertNotNull(newArtist);
		assertEquals("Sam", newArtist.getName());
		assertEquals("https://s3.amazonaws.com/bucket/image/new-image.jpg", newArtist.getImageURL());
	}
	
	@Test
	void deleteArtistTest_InvalidArtistID() {
		
		Exception exception= assertThrows(IllegalArgumentException.class, () -> artistService.deleteArtist("xyz"));
		assertEquals("Artist not found", exception.getMessage());
	}
	
	@Test
	void deleteArtistTest_ValidArtistID() {
		
		Artist artist=  Artist.builder()
				.name("Calvin")
				.mongoId("xyz")
				.imageURL("https://s3.amazonaws.com/bucket/image/new-image.jpg")
				.build();
		artistRepo.save(artist);
		 
		artistService.deleteArtist("xyz");
		Optional<Artist> deletedArtist = artistRepo.findById("xyz");
		assertTrue(deletedArtist.isEmpty());
		verify(s3ImageService).deleteArtistImage("image/new-image.jpg");
	}
}
