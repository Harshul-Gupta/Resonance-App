package com.hars.ArtistRegistry.Repository;

public interface SearchRepo{
	
	ArtistSlice findByNameAndGenre(String name, String genre, int page);  
}
