package com.hars.ArtistRegistry;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

import java.security.AuthProvider;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.mongodb.test.autoconfigure.DataMongoTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.context.annotation.Import;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.testcontainers.containers.MongoDBContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import com.hars.ArtistRegistry.Repository.User;
import com.hars.ArtistRegistry.Repository.UserRepo;
import com.hars.ArtistRegistry.Repository.UserResponseDTO;
import com.hars.ArtistRegistry.Service.RegisterService;

@DataMongoTest
@Import(RegisterService.class)
@Testcontainers
public class RegisterServiceTest {
	
	@Container
	@ServiceConnection
	static MongoDBContainer mongoDBContainer = new MongoDBContainer(DockerImageName.parse("mongo:7.0"));
	
	@Autowired
	RegisterService registerService;
	
	@Autowired
	UserRepo userRepo;
	
	@MockitoBean
	PasswordEncoder encoder;
	
	@MockitoBean
	AuthenticationProvider provider;
	
	@Autowired
	MongoTemplate mongoTemplate;
	
	@BeforeEach
	void setUp() {
		mongoTemplate.dropCollection(User.class);
	}
	
	@Test
	void registerArtistTest_ExistingUser() {
		
		User user = User.builder()
				.name("John")
				.username("JohnSummit")
				.password("pass")
				.build();
		userRepo.save(user);
		UserResponseDTO userResponseDTO = new UserResponseDTO("John", "JohnSummit", "pass");
		Exception exception = assertThrows(RuntimeException.class, () -> registerService.registerArtist(userResponseDTO));
		assertEquals("Username already present", exception.getMessage());
	}
	
	@Test
	void registerArtistTest_NewUser() {
		
		when(encoder.encode(anyString())).thenReturn("pass");
		UserResponseDTO userResponseDTO = new UserResponseDTO("John", "JohnSummit", "pass");
		registerService.registerArtist(userResponseDTO);
		User user = userRepo.findByUsername("JohnSummit").orElse(null);
		assertEquals("John", user.getName());
		assertEquals("pass", user.getPassword());
		assertEquals("JohnSummit", user.getUsername());
	}
}
