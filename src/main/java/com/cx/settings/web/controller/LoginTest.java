package com.cx.settings.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
public class LoginTest {

    @Autowired
    private UserService userService;

    @RequestMapping("logintest.do")
    @ResponseBody
    public String login(User user, HttpServletRequest request){
        //user = userService.selectUserByName(user.getLoginAct());
        request.getSession().setAttribute("user",user);
        return "workbench/index.jsp";
    }
}
