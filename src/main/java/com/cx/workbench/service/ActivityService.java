package com.cx.workbench.service;

import com.cx.workbench.domain.Activity;

import java.util.List;

public interface ActivityService {

    int saveActivity(Activity activity);

    //获取activity总条数（包含条件）
    int getTotalCount(Activity activity);

    //获取activityList（包含条件）
    List<Activity> getActivityList(Activity activity, int pageSize, int pageNum);
}
