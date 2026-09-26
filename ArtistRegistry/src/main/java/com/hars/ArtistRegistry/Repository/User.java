package com.hars.ArtistRegistry.Repository;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Document(collection = "User")
public class User {

	@Id
	private String mongoId;
	
	@NotBlank(message = "Username can't be empty")
	private String username;
	
	@NotBlank(message = "Password can't be empty")
	private String password;
	
//	@NotBlank(message = "Name can't be empty")
	private String name;
	
	@Email
	private String email;
	
	private String provider;
	
}
