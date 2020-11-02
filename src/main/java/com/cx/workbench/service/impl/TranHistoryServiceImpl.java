package com.cx.workbench.service.impl;

import com.cx.workbench.dao.TranHistoryDao;
import com.cx.workbench.domain.Tran;
import com.cx.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class TranHistoryServiceImpl implements TranHistoryService {
    @Autowired
    private TranHistoryDao historyDao;
    @Override
    public int tranHistory(Tran tran,String id) {
        return historyDao.tranHistory(tran,id);
    }
}
