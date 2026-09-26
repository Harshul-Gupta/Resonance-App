package com.hars.ArtistRegistry.Repository;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;

import org.jspecify.annotations.Nullable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.oidc.OidcIdToken;
import org.springframework.security.oauth2.core.oidc.OidcUserInfo;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.security.oauth2.core.user.OAuth2User;

public class UserPrincipal implements OAuth2User, UserDetails, OidcUser {

	private final User user;
	private Map<String, Object> oAuth2Attributes;
	private OidcIdToken oidcIdToken;
	private OidcUserInfo oidcUserInfo;
	
	public UserPrincipal(User user) {
		this.user = user;
	}
	
	public UserPrincipal(User user, Map<String, Object> oAuth2Attributes)
	{
		this.user= user;
		this.oAuth2Attributes= oAuth2Attributes;
	}
	
	public UserPrincipal(User user, Map<String, Object> oAuth2Attributes, OidcIdToken oidcIdToken, OidcUserInfo oidcUserInfo) {
		this.user= user;
		this.oAuth2Attributes= oAuth2Attributes;
		this.oidcIdToken= oidcIdToken;
		this.oidcUserInfo= oidcUserInfo;
	}
	
	public String getInitials() {
		return ""+ user.getUsername().charAt(0);
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return Collections.singleton(new SimpleGrantedAuthority("USER"));
	}

	@Override
	public @Nullable String getPassword() {
		return user.getPassword();
	}

	@Override
	public String getUsername() {
		return user.getUsername();
	}
	
	@Override
	public Map<String, Object> getAttributes(){
		return oAuth2Attributes;
	}
	
	@Override
	public String getName() {
		return oAuth2Attributes !=null? (String) oAuth2Attributes.get("sub"): user.getUsername();
	}

	@Override
	public Map<String, Object> getClaims() {
		return this.oAuth2Attributes;
	}

	@Override
	public OidcUserInfo getUserInfo() {
		return this.oidcUserInfo;
	}

	@Override
	public OidcIdToken getIdToken() {
		return this.oidcIdToken;
	}

}
