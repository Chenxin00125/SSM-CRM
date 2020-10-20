package com.cx.workbench.service.impl;

import com.cx.workbench.dao.ActivityRemarkDao;
import com.cx.workbench.domain.ActivityRemark;
import com.cx.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkDao remarkDao;

    @Override
    public List<ActivityRemark> selectRemarkByActivityId(String activityId) {
        List<ActivityRemark> remarkList = remarkDao.selectRemarkByActivityId(activityId);
        return remarkList;
    }

    @Override
    public int deleteById(String id) {
        int num = remarkDao.deleteById(id);
        return num;
    }

    @Override
    public int updateById(ActivityRemark activityRemark) {
        int num = remarkDao.updateById(activityRemark);
        return num;
    }

    @Override
    public int addRemark(ActivityRemark activityRemark) {
        int num = remarkDao.addRemark(activityRemark);
        return num;
    }

    @Override
    public int deleteByActivityId(String id) {
        int num = remarkDao.deleteByActivityId(id);
        return num;
    }
}
