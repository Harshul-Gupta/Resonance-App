package com.hars.songService.Event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ArtistEvent {
	
	private String actionType;
	private String mongoId;
	private String artistName;
}
