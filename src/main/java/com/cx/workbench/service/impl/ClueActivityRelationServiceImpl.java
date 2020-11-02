package com.cx.workbench.service.impl;

import com.cx.workbench.dao.ClueActivityRelationDao;
import com.cx.workbench.domain.ClueActivityRelation;
import com.cx.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationDao relationDao;

    @Override
    public int deleteRelation(String id) {
        int num = relationDao.deleteRelation(id);
        return num;
    }

    @Override
    public int relation(ClueActivityRelation car) {
        int num = relationDao.relation(car);
        return num;
    }

    @Override
    public String[] getActivityId(String clueId) {
        return relationDao.getActivityId(clueId);
    }

    @Override
    public int deleteRelationByClueId(String id) {
        return relationDao.deleteRelationByClueId(id);
    }
}
