package com.hars.songService.Configuration;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;

import io.netty.channel.ChannelOption;
import io.netty.handler.timeout.ReadTimeoutHandler;
import io.netty.handler.timeout.WriteTimeoutHandler;
import reactor.netty.http.client.HttpClient;

@Configuration
public class WebClientConfig {
	
	@Bean
	@LoadBalanced
	public WebClient.Builder webClientBuilder(){
		return WebClient.builder();
	}
	
	@Bean
	public WebClient webClient(WebClient.Builder webClientBuilder) {
		HttpClient httpClient = HttpClient.create()
									.option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 5000)
									.responseTimeout(Duration.ofSeconds(5))
									.doOnConnected(con -> con
											.addHandlerLast(new ReadTimeoutHandler(5, TimeUnit.SECONDS))
											.addHandlerLast(new WriteTimeoutHandler(5, TimeUnit.SECONDS)));
		
		return webClientBuilder
				.clientConnector(new ReactorClientHttpConnector(httpClient))
				.codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(2 * 1024 * 1024))
				.build();
	}
}
