package com.hars.ArtistRegistry;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.invocation.Invocation;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.oauth2.core.user.OAuth2User;

import com.hars.ArtistRegistry.Repository.User;
import com.hars.ArtistRegistry.Repository.UserRepo;
import com.hars.ArtistRegistry.Service.CustomOAuth2UserService;

@ExtendWith(MockitoExtension.class)
public class CustomOAuth2ServiceTest {
	
	@InjectMocks 
	CustomOAuth2UserService customOAuth2UserService;
	
	@Mock
	UserRepo userRepo;
	
	@Mock
	OAuth2User oAuth2User;
	
	@BeforeEach
	void setUp() {
		when(oAuth2User.getAttribute("email")).thenReturn("xyz@gmail.com");
		when(oAuth2User.getAttribute("name")).thenReturn("xyz");
	}
	
	@Test
	void processUserTest_with_existing_user() {
		when(userRepo.findByEmail("xyz@gmail.com")).thenReturn(Optional.of(User.builder()
												.username("xyz")
												.email("xyz@gmail.com")
												.password("12345678")
												.provider("Google")
												.build()));
		User user = customOAuth2UserService.processUser(oAuth2User);
		
		assertNotNull(user);
		assertEquals("xyz@gmail.com", user.getEmail());
		
	}
	
	@Test
	void processUserTest_without_existing_user() {
		when(userRepo.findByEmail("xyz@gmail.com")).thenReturn(Optional.empty());
		when(userRepo.save(any(User.class))).thenAnswer(Invocation -> Invocation.getArgument(0));
		
		User user = customOAuth2UserService.processUser(oAuth2User);
		
		assertNotNull(user);
		assertEquals("xyz@gmail.com", user.getEmail());
		assertEquals("xyz", user.getUsername());
		assertEquals("No_Password_OAuth2_User", user.getPassword());
        assertEquals("Google", user.getProvider());
        verify(userRepo, times(1)).save(any(User.class));
	}
}
