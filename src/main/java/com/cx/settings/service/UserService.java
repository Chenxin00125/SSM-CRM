package com.cx.settings.service;

import com.cx.settings.domain.User;

import java.util.List;

public interface UserService {
    //user根据name登录功能
    User selectUserByName(User user);
    //user根据email登录功能
    User selectUserByEmail(User user);
    //查询所有的user name
    List<User> getUserList();
}
