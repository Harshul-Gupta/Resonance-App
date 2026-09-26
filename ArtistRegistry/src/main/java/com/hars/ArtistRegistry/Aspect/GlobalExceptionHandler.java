package com.hars.ArtistRegistry.Aspect;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.context.support.StaticApplicationContext;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;


@ControllerAdvice
public class GlobalExceptionHandler {
	
	private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);
	
	@ExceptionHandler(RuntimeException.class)
	public String handleRuntimeException(RuntimeException ex, Model model)
	{
		log.error("[Critical Failure] System crashed with exception: ", ex);
		model.addAttribute("statusCode", 500);
		model.addAttribute("errorMessage", "An unexpected error occured. Please try again");
		return "errors";
	}
	
}
