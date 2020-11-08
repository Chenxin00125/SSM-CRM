package com.cx.workbench.service.impl;

import com.cx.workbench.dao.TranDao;
import com.cx.workbench.domain.Tran;
import com.cx.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class TranServiceImpl implements TranService {
    @Autowired
    private TranDao tranDao;
    @Override
    public int tranDeal(Tran tran) {
        return tranDao.tranDeal(tran);
    }

    @Override
    public List<Tran> selectByCustomerId(String id) {
        return tranDao.selectByCustomerId(id);
    }
}
