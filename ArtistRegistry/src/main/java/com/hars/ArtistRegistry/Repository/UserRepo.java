package com.hars.ArtistRegistry.Repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;
import java.util.Optional;


public interface UserRepo extends MongoRepository<User, String>{
	
	Optional<User> findByUsername(String username);
	Optional<User> findByEmail(String email);
}
