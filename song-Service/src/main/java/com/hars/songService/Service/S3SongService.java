package com.hars.songService.Service;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

import org.apache.kafka.common.Uuid;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.hars.songService.Repository.PresignedUploadResponse;

import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;

@Service
public class S3SongService {
	
	private final S3Client s3Client;

	private final S3Presigner s3Presigner;
	
	@Value("${aws.bucket.name}")
	private String bucketName;
	
	@Value("${aws.region}")
	private String region;
	
	public S3SongService(S3Presigner s3Presigner, S3Client s3Client){
		this.s3Presigner = s3Presigner;
		this.s3Client = s3Client; 
	}
	
	public PresignedUploadResponse generatePresignedUploadUrl(String fileName, String contentType) {
		String extension = fileName != null ? (fileName.substring(fileName.lastIndexOf('.'))): ".mp3";
		String key = "songs/" + Uuid.randomUuid().toString() + extension;
		
		PutObjectRequest putObjectRequest = PutObjectRequest.builder()
												.bucket(bucketName)
												.key(key)
												.contentType(contentType)
												.build();
		
		PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
																.signatureDuration(Duration.ofMinutes(10))
																.putObjectRequest(putObjectRequest)
																.build();
		
		PresignedPutObjectRequest presignedPutObjectRequest = s3Presigner.presignPutObject(presignRequest);
		
		URL url = presignedPutObjectRequest.url();
		String finalStorageUrl = url.getProtocol() + "://" + url.getHost() + url.getPath();
		
		return new PresignedUploadResponse(presignedPutObjectRequest.url().toString(), finalStorageUrl);
	}

	public void deleteSong(String s3url){
		try {
			URI uri = new URI(s3url);
		    String path = uri.getPath();
		        
		    if (path.startsWith("/")) {
		    	path = path.substring(1); 
		    }
		        
		    String key = URLDecoder.decode(path, StandardCharsets.UTF_8);
			DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
															.key(key)
															.bucket(bucketName)
															.build();
			s3Client.deleteObject(deleteObjectRequest);
		} catch (S3Exception e) {
			throw new RuntimeException("Couldn't delete song from the cloud storage");
		}
		catch (URISyntaxException e) {
			throw new RuntimeException("Provided S3 URL is incorrect");
		}
	}
}
