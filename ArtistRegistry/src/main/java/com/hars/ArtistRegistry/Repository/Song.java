package com.hars.ArtistRegistry.Repository;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import lombok.Getter;
import lombok.Setter;

@Document(collection = "Songs")
@Setter
@Getter
public class Song {
	@Id
	private String mongoID;
	
	@Field("artist_id")
	private String artistId;
	
	private String title;
	private String album;
	
	@Field("duration_seconds")
	    private int durationSeconds;
	 
	@Field("release_year") // Maps directly to release_year in MongoDB
	    private int releaseYear;
	    
	@Field("stream_count")
	    private long streamCount;
	    
	@Field("cover_art_url")
	    private String coverURL;

}
