package com.hars.ArtistRegistry.Service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriBuilder;

import com.hars.ArtistRegistry.Repository.SpotifyListenersResponse;

@Service
public class SpotifyMetricService {
	private final RestClient restClient;
	
	public SpotifyMetricService(
			@Value("${rapidapi.spotify.url}") String baseUrl,
            @Value("${rapidapi.spotify.key}") String apiKey,
            @Value("${rapidapi.spotify.host}") String apiHost){
		this.restClient= RestClient.builder()
				.baseUrl(baseUrl)
				.defaultHeader("X-RapidAPI-Key", apiKey)
                .defaultHeader("X-RapidAPI-Host", apiHost)
                .build();
	}
	public Long getMonthlyListeners(String spotifyArtistId)
	{
		try {
			SpotifyListenersResponse response= restClient.get()
					.uri(UriBuilder -> UriBuilder
							.path("/artist-details")
							.queryParam("id", spotifyArtistId)
							.build())
					.retrieve()
					.body(SpotifyListenersResponse.class);
			return response!=null? response.monthlyListeners(): 0L;
		}
		catch(Exception e)
		{
			System.err.println("Failed to fetch monthly listeners: "+ e.getMessage());
			return null;
		}
	}
}
