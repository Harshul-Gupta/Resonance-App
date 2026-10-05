package com.hars.ArtistRegistry.Configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.security.web.SecurityFilterChain;

import com.hars.ArtistRegistry.Repository.User;
import com.hars.ArtistRegistry.Repository.UserPrincipal;
import com.hars.ArtistRegistry.Service.CustomOAuth2UserService;

import jakarta.servlet.DispatcherType;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig{
	
	private final UserDetailsService userDetailsService;
	private final CustomOAuth2UserService customOAuth2UserService;
	
	public WebSecurityConfig(UserDetailsService userDetailsService, CustomOAuth2UserService customOAuth2UserService) {
		this.customOAuth2UserService= customOAuth2UserService;
		this.userDetailsService= userDetailsService;
	}
	
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	public AuthenticationProvider authProvider()
	{
		DaoAuthenticationProvider provider= new DaoAuthenticationProvider(userDetailsService);
		provider.setPasswordEncoder(passwordEncoder());
		return provider;
	}
	
	@Bean
	public OAuth2UserService<OidcUserRequest, OidcUser> customOidcAuth2UserService(){
		OidcUserService oidcUserService= new OidcUserService();
		return (userRequest) -> {
			OidcUser oidcUser= oidcUserService.loadUser(userRequest);
			User user = customOAuth2UserService.processUser(oidcUser);
			return new UserPrincipal(user, oidcUser.getAttributes(), userRequest.getIdToken(), oidcUser.getUserInfo());
		};
	}
	
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
		
		http	
			.csrf(csrf -> csrf.disable())
			.authorizeHttpRequests(auth -> auth
					.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE, DispatcherType.ERROR).permitAll()
					.requestMatchers("/login",
							"/WEB_INF/jsp/**",
							"/register",
							"/api/artists/user",
							"/api/artists/artistEvents",
							"/error",
						    "/jsp/**",
						    "/images/**",
						    "/favicon.ico").permitAll()
					.anyRequest().authenticated()
					)
			.formLogin(form-> form.loginPage("/login")
					.loginProcessingUrl("/login")
					.defaultSuccessUrl("/", true)
					.failureUrl("/login?error=true")
					.permitAll()
					)
			.logout(logout -> logout.logoutUrl("/logout")
					.logoutSuccessUrl("/login?logout=true")
					.invalidateHttpSession(true)     
		            .clearAuthentication(true)        
		            .deleteCookies("JSESSIONID")       
		            .permitAll()
					)
			.oauth2Login(oauth2 -> oauth2
					.loginPage("/login")
					.defaultSuccessUrl("/", true)
					.userInfoEndpoint(userInfo -> userInfo.userService(this.customOAuth2UserService).oidcUserService(customOidcAuth2UserService()))
					)
		    .sessionManagement(session -> session
		        .sessionFixation(sessionFixation -> sessionFixation.newSession()) 
		    )
			.httpBasic(Customizer.withDefaults());
		
		return http.build();
	}	
}
