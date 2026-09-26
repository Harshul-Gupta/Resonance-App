package com.hars.ArtistRegistry;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.hars.ArtistRegistry.Repository.User;
import com.hars.ArtistRegistry.Repository.UserRepo;
import com.hars.ArtistRegistry.Service.UserDetailsServiceImpl;


public class UserDetailsServiceImplTest {
	
	@InjectMocks
	private UserDetailsServiceImpl userDetailsServiceImpl;
	
	@Mock
	private UserRepo repo;
	
	private AutoCloseable closeable;
	
	@BeforeEach
	void setUp() {
		closeable= MockitoAnnotations.openMocks(this);
	}
	
	@AfterEach
	void tearDown() throws Exception{
		closeable.close();
	}
	
	@Test
	void loadByUsernameTest() {
		when(repo.findByUsername("Jay")).thenReturn(Optional.of(User.builder().username("Jay").password("doggosivnov").build()));
		
		UserDetails	result = userDetailsServiceImpl.loadUserByUsername("Jay");
		
		assertNotNull(result);
		assertEquals(result.getUsername(), "Jay");
		assertEquals(result.getPassword(), "doggosivnov");
		
	}
	
	@Test
	void loadByUsernameNegativeTest() {
		when(repo.findByUsername("Fred")).thenReturn(Optional.of(User.builder().username("Fred").password("kioncoisn").build()));

		assertThrows(UsernameNotFoundException.class, () -> {
			userDetailsServiceImpl.loadUserByUsername("Harshul");
		});
	}
}
