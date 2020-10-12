package com.cx.workbench.service.impl;

import com.cx.workbench.dao.ActivityDao;
import com.cx.workbench.domain.Activity;
import com.cx.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;

    @Override
    public int saveActivity(Activity activity) {
        int num = activityDao.saveActivity(activity);
        return num;
    }

    @Override
    public int getTotalCount(Activity activity) {
        int totalCount = activityDao.getTotalCount(activity);
        return totalCount;
    }

    @Override
    public List<Activity> getActivityList(Activity activity, int pageSize, int pageNum) {
        int startNum = (pageNum - 1) * pageSize;
        List<Activity> activityList = activityDao.getActivityList(activity,startNum,pageSize);
        return activityList;
    }
}
