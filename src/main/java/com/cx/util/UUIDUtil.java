package com.cx.util;

import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class UUIDUtil {
	
	public static String getUUID(){
		
		return UUID.randomUUID().toString().replaceAll("-","");
		
	}
	
}
