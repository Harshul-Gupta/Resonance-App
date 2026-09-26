package com.hars.songService.Repository;

import java.util.Set;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class SongCreationDTO {

    @NotBlank(message = "Song name cannot be blank")
    private String songName;

    private String albumName;

    @NotNull(message = "Duration is required")
    @Positive(message = "Duration must be greater than 0")
    private Integer duration;

    @NotBlank(message = "S3 URL is required")
    private String s3URL;

    @NotEmpty(message = "At least one artist ID must be provided")
    private Set<String> artistIds;

    @JsonCreator
    public SongCreationDTO(
        @JsonProperty("songName") String songName,
        @JsonProperty("albumName") String albumName,
        @JsonProperty("duration") Integer duration,
        @JsonProperty("s3URL") String s3URL,
        @JsonProperty("artistIds") Set<String> artistIds
    ) {
        this.songName = songName;
        this.albumName = albumName;
        this.duration = duration;
        this.s3URL = s3URL;
        this.artistIds = artistIds;
    }
}