package com.cx.settings.web.controller;

import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Component
@RequestMapping("/user/")
public class UserController {

    @RequestMapping("login")
    public String login(){
        return "index";
    }
}
