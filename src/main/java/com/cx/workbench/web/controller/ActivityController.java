package com.cx.workbench.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.workbench.domain.Activity;
import com.cx.workbench.domain.PageUtil;
import com.cx.workbench.service.ActivityService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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
        System.out.println(activity);
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

    @RequestMapping("getActivityList")
    @ResponseBody
    public ModelAndView getActivityList(Activity activity,Integer pageNum,Integer pageSize){

        //System.out.println(activity);
        //System.out.println(pageNum);
        //System.out.println(pageSize);
        List<Activity> activityList = activityService.getActivityList(activity,pageSize,pageNum);
        int totalCount = activityService.getTotalCount(activity);
        ModelAndView modelAndView = new ModelAndView();
        //modelAndView.addObject("activityList",activityList);
        modelAndView.addObject("activity",activity);
        //modelAndView.addObject("totalCount",totalCount);
        return modelAndView;
    }

}
