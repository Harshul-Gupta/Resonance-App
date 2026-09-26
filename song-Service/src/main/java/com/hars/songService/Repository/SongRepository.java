package com.hars.songService.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface SongRepository extends JpaRepository<Song, Long>{
	
	@Query("SELECT s FROM Song s JOIN s.artists a WHERE a.artistMongoId = :artistMongoId")
	List<Song> getSongsByArtistId(String artistMongoId);
}
