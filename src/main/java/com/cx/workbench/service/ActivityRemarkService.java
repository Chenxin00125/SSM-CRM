package com.cx.workbench.service;

import com.cx.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    //根据activityId查询备注
    List<ActivityRemark> selectRemarkByActivityId(String activityId);
}
