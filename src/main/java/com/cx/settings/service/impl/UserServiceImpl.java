package com.cx.settings.service.impl;

import com.cx.settings.dao.UserDao;
import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User selectUserByName(String name, String loginPwd) {
        User user = userDao.selectUserByName(name,loginPwd);
        return user;
    }

    @Override
    public User selectUserByEmail(String email, String loginPwd) {
        User user = userDao.selectUserByEmail(email,loginPwd);
        return user;
    }
}
