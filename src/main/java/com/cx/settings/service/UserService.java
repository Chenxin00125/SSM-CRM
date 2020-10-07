package com.cx.settings.service;

import com.cx.settings.domain.User;

public interface UserService {
    //user根据name登录功能
    User selectUserByName(String name, String loginPwd);
    //user根据email登录功能
    User selectUserByEmail(String email, String loginPwd);
}
