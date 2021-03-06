package com.cx.settings.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.util.DateTimeUtil;
import com.cx.util.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@RequestMapping("/user/")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private DateTimeUtil dateTimeUtil;

    @Autowired
    private MD5Util md5Util;

    @RequestMapping("login")
    @ResponseBody
    public Map login(User user, HttpServletRequest request, HttpServletResponse response) throws IOException {
        user.setLoginPwd(md5Util.getMD5(user.getLoginPwd()));
        String type = user.getLoginAct();
        System.out.println(type);
        //含有@走邮箱查询
        if (type.indexOf("@")!=-1){
            user.setEmail(type);
            user =  userService.selectUserByEmail(user);
        }else{
            user =  userService.selectUserByName(user);
        }
        //账号密码错误
        boolean flag = false;
        String msg = "账号或密码错误";
        if (null!=user){
            //状态码未激活
            if(user.getLockState().equals("1")){
                //判断账号是否已过期
                String Utime = user.getExpireTime();//失效时间
                String Ttime =  dateTimeUtil.getSysTime();//系统时间
                System.out.println(Ttime+"----"+Utime);
                if (Utime.compareTo(Ttime) > 0) {
                    request.getSession().setAttribute("user",user);
                    flag = true;
                }else{
                    msg = "该账号已过期，请联系专员处理";
                }
            }else {
                msg = "该未激活，请联系专员处理";
            }
        }

        Map map = new HashMap();
        map.put("flag",flag);
        map.put("msg",msg);
        map.put("page","workbench/index.jsp");
        return map;
    }

    @RequestMapping("getUserList")
    @ResponseBody
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }
}
