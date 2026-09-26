package com.hars.songService.Repository;

import java.util.Date;
import java.util.Set;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Table(name = "songs")
@Entity
public class Song {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@NotBlank(message = "Song name can not be blank")
	private String songName;
	
	@ManyToMany
	@JoinTable(name = "song_artists", joinColumns = @JoinColumn(name = "song_id"), inverseJoinColumns = @JoinColumn(name = "artist_mongo_id"))
	private Set<ArtistLookup> artists;
	
	private String albumName;
	
	@Positive(message = "Duration must be greater than 0")
	private int duration;
	
//	@NotBlank(message = "Release year can't be blank")
//	private Date releaseDate;
//	
//	private int streamCount;
	
	@NotBlank(message = "S3 URL is required")
	private String s3URL;
}
