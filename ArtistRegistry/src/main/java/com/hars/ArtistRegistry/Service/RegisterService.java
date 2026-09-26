package com.hars.ArtistRegistry.Service;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.hars.ArtistRegistry.Repository.User;
import com.hars.ArtistRegistry.Repository.UserRepo;
import com.hars.ArtistRegistry.Repository.UserResponseDTO;

@Service
public class RegisterService {
	
	private final AuthenticationProvider authProvider;
	private final UserRepo repo;
	private final PasswordEncoder encoder;
	
	public RegisterService(UserRepo repo, PasswordEncoder encoder, AuthenticationProvider authProvider) {
			this.repo= repo;
			this.encoder= encoder;
			this.authProvider = authProvider;
	}
	public void registerArtist(UserResponseDTO user)
	{
		if(!repo.findByUsername(user.username()).isEmpty())
			throw new RuntimeException("Username already present");
		User newUser = new User();
		newUser.setUsername(user.username());
		newUser.setPassword(encoder.encode(user.password()));
		newUser.setName(user.name());
		repo.save(newUser);
	}
}
