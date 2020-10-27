package com.cx.workbench.service;

import com.cx.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ActivityService {

    int saveActivity(Activity activity);

    //获取activity总条数（包含条件）
    int getTotalCount(Activity activity);

    //获取activityList（包含条件）
    List<Activity> getActivityList(Activity activity, int pageSize, int pageNum);

    //根据id查询activity
    Activity getActivityById(String id);

    //根据id修改activity
    int editActivityById(Activity activity);

    //根据id查询activity关联user表
    Activity detailActivityById(String id);

    //删除
    int deleteActivity(String id);

    //关联关系查询市场活动，根据中间表查询 id为Clue（线索）的id
    List<Activity> getActivityByClueId(String id);

    //模糊name查询未关联线索的市场活动
    List<Activity> getClueActivity(String name,String clueId);

}
