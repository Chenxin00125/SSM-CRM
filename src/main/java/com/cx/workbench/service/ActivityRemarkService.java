package com.cx.workbench.service;

import com.cx.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    //根据activityId查询备注
    List<ActivityRemark> selectRemarkByActivityId(String activityId);

    //删除备注
    int deleteById(String id);

    //修改备注
    int updateById(ActivityRemark activityRemark);

    //添加备注
    int addRemark(ActivityRemark activityRemark);

    //根据activityID删除备注
    int deleteByActivityId(String id);
}
