package com.cx.workbench.dao;

import com.cx.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    //根据activityId查询备注
    List<ActivityRemark> selectRemarkByActivityId(String activityId);
}
