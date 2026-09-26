package com.hars.ArtistRegistry.Repository;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.data.mongodb.core.convert.MongoConverter;
import org.springframework.stereotype.Repository;
import org.bson.Document;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

@Repository
public class SearchRepoImpl implements SearchRepo{
	private final MongoCollection<Document> collection;
	private final MongoConverter mConverter;
	
	private static final int LIMIT_SIZE= 5;
	
	SearchRepoImpl(MongoClient mongoClient, MongoConverter mConverter){
		this.mConverter= mConverter;
		MongoDatabase database = mongoClient.getDatabase("Harshul");
		this.collection = database.getCollection("Artist");
	}
	
	@Override
	public ArtistSlice findByNameAndGenre(String name, String genre, int page) {
		
		if(page<0)
			page= 0;
	    // Fail fast: return empty list if both inputs are completely blank
	    if ((name == null || name.isBlank()) && (genre == null || genre.isBlank())) {
	        return new ArtistSlice(List.of(), false, false);
	    }

	    List<Artist> artists = new ArrayList<>();
	    
	    // Base search document
	    Document compound = new Document();
	    List<Document> mustClauses = new ArrayList<>();
	    List<Document> shouldClauses = new ArrayList<>();

	    // 1. Partial Match Name (Autocomplete + Fuzzy matching for typos)
	    if (name != null && !name.isBlank()) {
	        shouldClauses.add(new Document("autocomplete", new Document("query", name)
	                .append("path", "name")
	                .append("fuzzy", new Document("maxEdits", 1)))); 
	    }

	    // 2. Exact/Phrase Match Genre Filter
	    if (genre != null && !genre.isBlank()) {
	        mustClauses.add(new Document("text", new Document("query", genre)
	                .append("path", "genre")));
	    }

	    // Assemble the compound query structure
	    if (!mustClauses.isEmpty()) {
	        compound.append("must", mustClauses);
	    }
	    if (!shouldClauses.isEmpty()) {
	        compound.append("should", shouldClauses);
	        // Ensure at least one name matches if a name was provided
	        if (name != null && !name.isBlank()) {
	            compound.append("minimumShouldMatch", 1);
	        }
	    }

	    int skipElements= page * LIMIT_SIZE;
	    
	    int limitElements= LIMIT_SIZE + 1;
	    
	    // Execute aggregate command
	    AggregateIterable<Document> result = collection.aggregate(Arrays.asList(
	        new Document("$search", new Document("index", "default")
	                .append("compound", compound)),
	        new Document("$skip", skipElements),
            new Document("$limit", limitElements)
	    ));

	    // Convert raw MongoDB Documents into Java Artist Objects
	    result.forEach(doc -> artists.add(mConverter.read(Artist.class, doc)));
	    
	    boolean hasNext= artists.size() > LIMIT_SIZE;
	    
	    boolean hasPrevious= page > 0;
	    
	    if(hasNext)
	    	artists.remove(LIMIT_SIZE);
	    
	    return new ArtistSlice(artists, hasPrevious, hasNext);
	}
}
