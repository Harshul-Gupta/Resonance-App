package com.hars.ArtistRegistry.Aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import com.hars.ArtistRegistry.Repository.Artist;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Aspect
@Component
public class LoggingAspect {
	
	private static final Logger logger= LoggerFactory.getLogger(LoggingAspect.class);
	
	@After("execution(public * com.hars.ArtistRegistry.Controller.HomeController.getArtist(String)) && args(id)")
	public void logArtist(String id)
	{
		logger.info("getArtist() method called for Artist ID: {}",id);
	}
	
	 @After("execution(public * com.hars.ArtistRegistry.Controller.HomeController.addArtist(..))")
	    public void logSave(JoinPoint joinPoint) {
	        // Grab the actual runtime argument array passed to the method
	        Object[] args = joinPoint.getArgs();
	        
	        if (args != null && args.length > 0) {
	            // Check if the first parameter is an instance of your Artist model
	            if (args[0] instanceof Artist) {
	                Artist artist = (Artist) args[0];
	                logger.info("Artist: {} added", artist.getName());
	            }
	        }
	 }
	
	@After("execution(public * com.hars.ArtistRegistry.Controller.ArtistController.indexPage(..))")
	public void logHome()
	{
		logger.info("Homepage called.. ");
	}
	
	@Around("execution(public String com.hars.ArtistRegistry.Controller.ArtistController.search(..))")
	public Object logSearch(ProceedingJoinPoint joinPoint) throws Throwable
	{
		long startTime= System.currentTimeMillis();
		Object result = joinPoint.proceed();
		logger.info("[Search Metrics] Search method took {} ms", (System.currentTimeMillis()-startTime));
		return result;
	}
	
	@After("execution(public String com.hars.ArtistRegistry.Controller.ArtistController.getArtistDetails(..))")
	public void logArtistDetails(JoinPoint joinPoint)
	{
		String id = (String)joinPoint.getArgs()[0];
		logger.info("Artist details called for artist: "+ id);
	}
}
