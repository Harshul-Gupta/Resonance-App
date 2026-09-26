package com.hars.ArtistRegistry.Event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ArtistEvent {
	
	private String actionType;
	private String mongoId;
	private String artistName;
}
