package com.cx.workbench.dao;

import com.cx.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ActivityDao {
    //saveActivity添加活动
    int saveActivity(Activity activity);

    //获取activity总条数（包含条件）
    int getTotalCount(Activity activity);

    //获取activityList（包含条件）当传入参数中有对象和普通参数时，每个参数都需要使用@Param（）注解，而对象使用后需要在sql语句中用别名调用对象的属性
    List<Activity> getActivityList(@Param("activity") Activity activity, @Param("startNum") int startNum,@Param("pageSize") int pageSize);

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

    //关联关系查询市场活动，根据中间表查询 id为Clue（线索）的id
    List<Activity> getActivityByTran(String id);

    //模糊name查询未关联线索的市场活动
    List<Activity> getClueActivity(@Param("name") String name,@Param("clueId") String clueId);


}
