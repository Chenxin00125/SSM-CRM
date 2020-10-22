package com.cx.workbench.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.util.DateTimeUtil;
import com.cx.util.UUIDUtil;
import com.cx.workbench.domain.Activity;
import com.cx.workbench.domain.ActivityRemark;
import com.cx.workbench.service.ActivityRemarkService;
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

@Controller
@RequestMapping("/workbench/activity/")
public class ActivityController {

    @Autowired
    private DateTimeUtil dateTimeUtil;
    @Autowired
    private UUIDUtil uuidUtil;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityRemarkService remarkService;

    @RequestMapping("saveActivity")
    @ResponseBody
    public boolean saveActivity(Activity activity, HttpServletRequest request){
//        System.out.println(activity);
        activity.setCreateTime(dateTimeUtil.getSysTime());
        User user = (User) request.getSession().getAttribute("user");
        activity.setCreateBy(user.getId());
        activity.setId(uuidUtil.getUUID());
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
    public boolean deleteActivity(String ids){
        String[] id = ids.split(",");
        boolean flag = false;
        int aNum = 0;
        int a = 0;
        for ( int i = 0 ;i < id.length ; i++){
            int b = remarkService.deleteByActivityId(id[i]);
            int num = activityService.deleteActivity(id[i]);
            aNum = aNum + num;
            a = a + b;
        }
        System.out.println(aNum+"---"+a);
        if (aNum>=1){
            flag = true;
        }
        return flag;
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
        List<ActivityRemark> remarkList = remarkService.selectRemarkByActivityId(id);
        for (User user:userList ) {
            if(user.getId().equals(activity.getCreateBy())){
                activity.setCreateBy(user.getName());
            }
            if(user.getId().equals(activity.getEditBy())){
                activity.setEditBy(user.getName());
            }
        }

        modelAndView.addObject("userList",userList);
        modelAndView.addObject("remarkList",remarkList);
        modelAndView.addObject("activity",activity);
        modelAndView.setViewName("activity/detail");
        return modelAndView;
    }

    @RequestMapping("editActivity")
    @ResponseBody
    public Map editActivity(Activity activity,HttpServletRequest request){
        Map map = new HashMap();
        boolean flag = false;
        activity.setEditTime(dateTimeUtil.getSysTime());
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

    @RequestMapping("editRemark")
    @ResponseBody
    public boolean editRemark(ActivityRemark activityRemark,HttpServletRequest request){
        boolean flag = false;
        activityRemark.setEditTime(dateTimeUtil.getSysTime());
        User user = (User)request.getSession().getAttribute("user");
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditFlag("1");
        System.out.println(activityRemark);
        int num = remarkService.updateById(activityRemark);
        if (num==1){
            flag = true;
        }
        return flag;
    }

    @RequestMapping("addRemark")
    @ResponseBody
    public Map addRemark(ActivityRemark activityRemark){
        Map map = new HashMap();
        boolean flag = false;
        String id = activityRemark.getActivityId();
        activityRemark.setCreateTime(dateTimeUtil.getSysTime());
        activityRemark.setId(uuidUtil.getUUID());
        activityRemark.setEditFlag("0");
        activityRemark.setEditBy(null);
        activityRemark.setEditTime(null);
        //System.out.println(activityRemark);
        int num = remarkService.addRemark(activityRemark);
        if (num==1){
            flag = true;
            //List<ActivityRemark> remarkList = remarkService.selectRemarkByActivityId(id);
            map.put("activityRemark",activityRemark);
        }
        map.put("flag",flag);
        return map;
    }

    @RequestMapping("deleteRemark")
    @ResponseBody
    public Map deleteRemark(String id){
        boolean flag = false;
        Map map = new HashMap();
        int num = remarkService.deleteById(id);
        if (num == 1){
            flag = true;
        }
        map.put("flag",flag);
        return map;
    }
}
