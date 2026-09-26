 package com.hars.ArtistRegistry.Repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface ArtistRepo extends MongoRepository<Artist, String>{

	List<Artist> findByNameContainingIgnoreCaseAndGenreContaining(String name, String genre);

	List<Artist> findByNameContainingIgnoreCase(String name);

	Optional<Artist> findByName(String name);

}
