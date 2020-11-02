package com.cx.workbench.service.impl;

import com.cx.workbench.dao.ClueRemarkDao;
import com.cx.workbench.domain.ClueRemark;
import com.cx.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkDao remarkDao;

    @Override
    public List<ClueRemark> selectRemarkByClueId(String clueId) {
        List<ClueRemark> remarkList = remarkDao.selectRemarkByClueId(clueId);
        return remarkList;
    }

    @Override
    public int deleteById(String id) {
        int num = remarkDao.deleteById(id);
        return num;
    }

    @Override
    public int updateById(ClueRemark clueRemark) {
        int num = remarkDao.updateById(clueRemark);
        return num;
    }

    @Override
    public int addRemark(ClueRemark clueRemark) {
        int num = remarkDao.addRemark(clueRemark);
        return num;
    }

    @Override
    public int deleteByClueId(String id) {
        int num = remarkDao.deleteByClueId(id);
        return num;
    }

    @Override
    public int selectCountByClueId(String clueId) {
        return remarkDao.selectCountByClueId(clueId);
    }
}
