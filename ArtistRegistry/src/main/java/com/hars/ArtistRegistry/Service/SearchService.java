package com.hars.ArtistRegistry.Service;

import org.springframework.stereotype.Service;

import com.hars.ArtistRegistry.Repository.ArtistSlice;
import com.hars.ArtistRegistry.Repository.SearchRepo;

@Service
public class SearchService {
	
	private final SearchRepo sRepo;
	
	public SearchService(SearchRepo sRepo) {
		this.sRepo = sRepo;
	}
	
	public ArtistSlice searchArtists(String name, String genre, int page)
	{
		return sRepo.findByNameAndGenre(name, genre, page);
	}
}
