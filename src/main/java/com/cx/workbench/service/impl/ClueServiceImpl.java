package com.cx.workbench.service.impl;

import com.cx.workbench.dao.ClueDao;
import com.cx.workbench.domain.Activity;
import com.cx.workbench.domain.Clue;
import com.cx.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;

    @Override
    public int saveClue(Clue clue) {
        int num = clueDao.saveClue(clue);
        return num;
    }

    @Override
    public List<Clue> getClueList(Clue clue, Integer pageSize, Integer pageNum) {
        int startNum = (pageNum - 1) * pageSize;
        List<Clue> clueList = clueDao.getClueList(clue,startNum,pageSize);
        return clueList;
    }

    @Override
    public int getTotalCount(Clue clue) {
        int totalCount = clueDao.getTotalCount(clue);
        return totalCount;
    }

    @Override
    public Clue getClueById(String id) {
        Clue clue = clueDao.getClueById(id);
        return clue;
    }

    @Override
    public int editClueById(Clue clue) {
        int num = clueDao.editClueById(clue);
        return num;
    }

    @Override
    public Clue detailClueById(String id) {
        Clue clue = clueDao.detailClueById(id);
        return clue;
    }

    @Override
    public int deleteClue(String id) {
        return clueDao.deleteClue(id);
    }
}
