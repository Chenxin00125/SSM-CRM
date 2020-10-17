package com.cx.workbench.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.workbench.domain.Activity;
import com.cx.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.cx.util.DateTimeUtil.getSysTime;
import static com.cx.util.UUIDUtil.getUUID;

@Controller
@RequestMapping("/workbench/activity/")
public class ActivityController {

    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;

    @RequestMapping("saveActivity")
    @ResponseBody
    public boolean saveActivity(Activity activity, HttpServletRequest request){
//        System.out.println(activity);
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
    public Map getActivityList(Activity activity, Integer pageNum, Integer pageSize){

        /*System.out.println(activity);
        System.out.println(pageNum);
        System.out.println(pageSize);*/
        List<Activity> activityList = activityService.getActivityList(activity,pageSize,pageNum);
        int totalCount = activityService.getTotalCount(activity);
        Map map = new HashMap();
        map.put("activityList",activityList);
        map.put("totalCount",totalCount);
        return map;
    }

    @RequestMapping("deleteActivity")
    @ResponseBody
    public ModelAndView deleteActivity(String ids){
        ModelAndView modelAndView = new ModelAndView();
        String[] id = ids.split(",");
        return modelAndView;
    }

    @RequestMapping("getActivityById")
    @ResponseBody
    public Activity getActivityById(String id){
        Activity activity = activityService.getActivityById(id);
        return activity;
    }

    @RequestMapping("detailActivityById")
    public ModelAndView detailActivityById(String id){
        Activity activity = activityService.detailActivityById(id);
        ModelAndView modelAndView = new ModelAndView();
        List<User> userList = userService.getUserList();
        for (User user:userList ) {
            if (user.getId().equals(activity.getOwner())){
                activity.setOwner(user.getName());
            }
            if(user.getId().equals(activity.getCreateBy())){
                activity.setCreateBy(user.getName());
            }
            if(user.getId().equals(activity.getEditBy())){
                activity.setEditBy(user.getName());
            }
        }
        modelAndView.addObject("activity",activity);
        modelAndView.setViewName("activity/detail");
        return modelAndView;
    }

    @RequestMapping("editActivity")
    @ResponseBody
    public Map editActivity(Activity activity,HttpServletRequest request){
        Map map = new HashMap();
        boolean flag = false;
        activity.setEditTime(getSysTime());
        User user = (User)request.getSession().getAttribute("user");
        activity.setEditBy(user.getId());
        System.out.println(activity);
        int num = activityService.editActivityById(activity);
        if (num==1){
            flag = true;
            map.put("activity",activity);
        }
        map.put("flag",flag);
        return map;
    }
}
