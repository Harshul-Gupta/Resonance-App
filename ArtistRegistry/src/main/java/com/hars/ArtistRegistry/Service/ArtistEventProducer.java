package com.hars.ArtistRegistry.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import com.hars.ArtistRegistry.Event.ArtistEvent;

@Service
public class ArtistEventProducer {
	
	private static final String TOPIC = "artist-events";
	
	@Autowired
	KafkaTemplate<String, ArtistEvent> kafkaTemplate;
	
	public void sendArtistEvent(String actionType, String mongoId, String artistName) {
		
		ArtistEvent event = ArtistEvent.builder()
								.actionType(actionType)
								.mongoId(mongoId)
								.artistName(artistName)
								.build();
		
		System.out.println("Publishing event to Kafka [ "+ TOPIC + "]: "+ event);
		kafkaTemplate.send(TOPIC, mongoId, event);
	}
}
