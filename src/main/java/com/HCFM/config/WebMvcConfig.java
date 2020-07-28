package com.HCFM.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.HCFM.interceptor.HCFMInterceptor;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

	@Autowired
	private HCFMInterceptor hcfmInterceptor;
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(hcfmInterceptor)
				.addPathPatterns("/**")
				.excludePathPatterns("/")
//				.excludePathPatterns("/member/login")
//				.excludePathPatterns("/inc/css/**")
//				.excludePathPatterns("/img/**")
//				.excludePathPatterns("/favicon.ico")
				.excludePathPatterns("/static/**")
				//.excludePathPatterns("/pg/**")				
				;
	}
	
}
