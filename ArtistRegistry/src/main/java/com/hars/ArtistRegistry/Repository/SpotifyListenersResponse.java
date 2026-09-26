package com.hars.ArtistRegistry.Repository;

public record SpotifyListenersResponse(
	String artistId,
	Long monthlyListeners)
{}
