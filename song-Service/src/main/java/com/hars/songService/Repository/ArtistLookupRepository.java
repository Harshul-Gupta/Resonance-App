package com.hars.songService.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ArtistLookupRepository extends JpaRepository<ArtistLookup, String>{
	
	
}
