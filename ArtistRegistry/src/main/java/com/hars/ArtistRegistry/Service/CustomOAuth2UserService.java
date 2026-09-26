package com.hars.ArtistRegistry.Service;

import java.security.PublicKey;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.hars.ArtistRegistry.Repository.User;
import com.hars.ArtistRegistry.Repository.UserPrincipal;
import com.hars.ArtistRegistry.Repository.UserRepo;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

	private final UserRepo userRepo;
	
	public CustomOAuth2UserService(UserRepo userRepo) {
		this.userRepo= userRepo;
	}
	@Override
	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {

		OAuth2User googleUser= super.loadUser(userRequest);
		User user= processUser(googleUser);
		return new UserPrincipal(user, googleUser.getAttributes());
	}
	
	public User processUser(OAuth2User oAuth2User) {
		String email= oAuth2User.getAttribute("email");
		String name= oAuth2User.getAttribute("name");
		
		return  userRepo.findByEmail(email)
				.orElseGet(() -> {
					User newUser= new User();
					newUser.setUsername(name); 
					newUser.setEmail(email);
					newUser.setPassword("No_Password_OAuth2_User");
					newUser.setProvider("Google");
					return userRepo.save(newUser);
				});
	}
}
