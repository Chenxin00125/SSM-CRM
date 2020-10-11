package com.cx.workbench.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.workbench.domain.Activity;
import com.cx.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static com.cx.util.DateTimeUtil.getSysTime;
import static com.cx.util.UUIDUtil.getUUID;

@Controller
@RequestMapping("/workbench/activity/")
public class ActivityController {

    @Autowired
    private ActivityService activityService;

    @RequestMapping("saveActivity")
    @ResponseBody
    public boolean saveActivity(Activity activity, HttpServletRequest request){
        activity.setCreateTime(getSysTime());
        User user = (User) request.getSession().getAttribute("user");
        activity.setCreateBy(user.getId());
        activity.setId(getUUID());
        boolean flag = false;
        int num = activityService.saveActivity(activity);
        if (num==1){
            flag = true;
        }
        return flag;
    }


}
