package com.cx.settings.dao;

import com.cx.settings.domain.User;

public interface UserDao {
    //user根据loginAct登录功能
    User selectUserByName(User user);
    //user根据email登录功能
    User selectUserByEmail(User user);
}
