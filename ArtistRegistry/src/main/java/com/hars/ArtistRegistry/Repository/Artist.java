package com.hars.ArtistRegistry.Repository;

import java.util.HashSet;
import java.util.Set;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Document(collection = "Artist")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Artist {
	@Id
	private String mongoId;
	   
	@Field("id") 
	private String id;

	@NotBlank(message = "Name is required")
	private String name;

    private ArtistType type; 

    @NotBlank(message = "Bio is required field")
    private String bio;

	@NotBlank(message = "Country is required")
	private String country;
	
	private Set<String> genre = new HashSet<>();
	
	private String imageURL;
	
	private String spotifyId;
	
	private Long viewCount = 0L;

}
