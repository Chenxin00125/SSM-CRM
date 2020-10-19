package com.cx.workbench.dao;

import com.cx.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    //根据activityId查询备注
    List<ActivityRemark> selectRemarkByActivityId(String activityId);

    //删除备注
    int deleteById(String id);

    //修改备注
    int updateById(ActivityRemark activityRemark);
}
