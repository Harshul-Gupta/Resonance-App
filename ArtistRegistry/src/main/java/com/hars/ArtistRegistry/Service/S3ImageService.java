package com.hars.ArtistRegistry.Service;

import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;

@Service
public class S3ImageService {
	
	private final S3Client s3Client;
	
	@Value("${aws.bucket.name}")
	private String bucketName;
	
	public S3ImageService(S3Client s3Client)
	{
		this.s3Client= s3Client;
	}
	
	public String uploadArtistImage(MultipartFile file) throws IOException{
		
		String originalFile = file.getOriginalFilename();
		String fileExtension = originalFile != null? originalFile.substring(originalFile.lastIndexOf(".")): ".jpg";
		String key= "image/"+ UUID.randomUUID().toString()+ fileExtension;
		
		PutObjectRequest putObjectRequest= PutObjectRequest.builder()
														.bucket(bucketName)
														.key(key)
														.contentType(file.getContentType())
														.build();
		s3Client.putObject(putObjectRequest, RequestBody.fromInputStream(file.getInputStream(), file.getSize()));
		
		return String.format("https://%s.s3-%s.amazonaws.com/%s", bucketName, "ap-south-1", key);
	}
	public void deleteArtistImage(String key)
	{
		try {
			DeleteObjectRequest deleteObjectRequest= DeleteObjectRequest.builder()
																	.bucket(bucketName)
																	.key(key)
																	.build();
			s3Client.deleteObject(deleteObjectRequest);
		}
		catch(S3Exception e) {
			throw new RuntimeException("Could not delete the image from cloud storage");
		}
	}
}
