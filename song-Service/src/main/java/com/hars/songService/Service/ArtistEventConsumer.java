package com.hars.songService.Service;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.hars.songService.Event.ArtistEvent;
import com.hars.songService.Repository.ArtistLookup;
import com.hars.songService.Repository.ArtistLookupRepository;

import tools.jackson.databind.ObjectMapper;

@Service
public class ArtistEventConsumer {
	
	
	ObjectMapper objectMapper;
	ArtistLookupRepository lookupRepo;
	SongService songService;
	
	public ArtistEventConsumer(ObjectMapper objectMapper, ArtistLookupRepository lookupRepo, SongService songService) {
		this.objectMapper = objectMapper;
		this.lookupRepo = lookupRepo;
		this.songService = songService;
	}
	
	@KafkaListener(topics = "artist-events", groupId = "song-service-group")
	public void consumeArtistEvent(String message) {
		try {
			ArtistEvent event = objectMapper.readValue(message, ArtistEvent.class);
			System.out.println("Successfully parsed Kafka event: "+ event.getActionType());
			
			switch (event.getActionType()) {
			case "ARTIST_CREATED": {
				handleArtistCreation(event);
				break;
			}
			case "ARTIST_DELETED":{
				handleArtistDeletion(event);
				break;
			}
			default:
				throw new IllegalArgumentException("Unexpected value: " + event.getActionType());
			}
		}
		catch (Exception e) {
			System.err.println("Error processing Kafka event: "+ e.getMessage());
		}
	}
	
	private void handleArtistCreation(ArtistEvent event) {
		ArtistLookup lookup = ArtistLookup.builder()
								.artistMongoId(event.getMongoId())
								.artistName(event.getArtistName())
								.build();
		lookupRepo.save(lookup);
		System.out.println("Synced new artist reference: "+ event.getArtistName());
	}
	
	private void handleArtistDeletion(ArtistEvent event) {
		songService.removeSongByArtistId(event.getMongoId());
		
		lookupRepo.deleteById(event.getMongoId());
		System.out.println("Cascade deleted artist reference and all their songs for "+ event.getMongoId());
	}
}
