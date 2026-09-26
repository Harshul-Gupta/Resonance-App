package com.hars.ArtistRegistry.Service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import com.hars.ArtistRegistry.Repository.Artist;
import com.hars.ArtistRegistry.Repository.ArtistSlice;

@Service
public class LibraryService {
	
	@Autowired
	MongoTemplate mongoTemplate;
	
	private static final int LIMIT_SIZE = 5;
	
	public List<Artist> getTopArtists(int pageNum){
		
		if(pageNum<0 || pageNum>1)
			return List.of();
		Query query = new Query();
		Pageable page = PageRequest.of(pageNum, LIMIT_SIZE, Sort.by(Sort.Direction.DESC, "viewCount"));
		query.with(page);
		
		List<Artist> artists = mongoTemplate.find(query, Artist.class);
		return artists;
	}
	
public ArtistSlice getArtistsByGenre(String genre, int pageNum){
		
		int limit = LIMIT_SIZE*2; //loading 2 shelves at a time
		if(pageNum<0)
			pageNum = 0;
		Query query = new Query();
		query.addCriteria(Criteria.where("genre").in(genre));
		query.skip((long)pageNum*limit);
		query.limit(limit+1);
		List<Artist> artists = mongoTemplate.find(query, Artist.class);
		
		boolean hasNext = false;
		if(artists.size()>limit) {
			hasNext = true;
			artists = new ArrayList<>(artists.subList(0, limit));
		}
		boolean hasPrevious = pageNum>0;
		
		
		return new ArtistSlice(artists, hasPrevious, hasNext);
	}
}
