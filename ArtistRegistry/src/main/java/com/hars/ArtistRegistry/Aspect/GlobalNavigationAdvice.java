package com.hars.ArtistRegistry.Aspect;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.hars.ArtistRegistry.Repository.UserPrincipal;

@ControllerAdvice
public class GlobalNavigationAdvice {
	
	@ModelAttribute("currentUser")
	public UserPrincipal getCurrentUser(@AuthenticationPrincipal UserPrincipal principal)
	{
		return principal;
	}
}
