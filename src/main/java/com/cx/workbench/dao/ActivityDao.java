package com.cx.workbench.dao;

import com.cx.workbench.domain.Activity;

import java.util.List;

public interface ActivityDao {
    //saveActivity添加活动
    int saveActivity(Activity activity);

    //获取activity总条数（包含条件）
    int getTotalCount(Activity activity);

    //获取activityList（包含条件）
    List<Activity> getActivityList(Activity activity,int startNum, int pageSize);

   // List<Activity> getActivityList(Activity activity,int startNum, int pageSize);
}
