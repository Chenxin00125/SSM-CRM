package com.cx.workbench.service.impl;

import com.cx.workbench.dao.ActivityDao;
import com.cx.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;
}
