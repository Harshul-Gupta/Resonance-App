package com.hars.ArtistRegistry.Exception;

public class InvalidSearchRequestException extends RuntimeException{
	public InvalidSearchRequestException(String message)
	{
		super(message);
	}
}
