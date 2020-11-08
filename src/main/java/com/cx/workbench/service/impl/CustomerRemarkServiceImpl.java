package com.cx.workbench.service.impl;

import com.cx.util.UUIDUtil;
import com.cx.workbench.dao.CustomerRemarkDao;
import com.cx.workbench.domain.ClueRemark;
import com.cx.workbench.domain.CustomerRemark;
import com.cx.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CustomerRemarkServiceImpl implements CustomerRemarkService{

    @Autowired
    private CustomerRemarkDao remarkDao;
    @Autowired
    private UUIDUtil uuidUtil;

    @Override
    public List<CustomerRemark> selectRemarkByCustomerId(String customerId) {
        return remarkDao.selectRemarkByCustomerId(customerId);
    }

    @Override
    public int addRemark(List<ClueRemark> remarkList, String id) {
        CustomerRemark customerRemark = new CustomerRemark();
        int num = 0;
        for (ClueRemark remark: remarkList ) {
            customerRemark.setId(uuidUtil.getUUID());
            customerRemark.setNoteContent(remark.getNoteContent());
            customerRemark.setCreateBy(remark.getCreateBy());
            customerRemark.setCreateTime(remark.getCreateTime());
            customerRemark.setEditBy(null);
            customerRemark.setEditTime(null);
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(id);
            remarkDao.addRemark(customerRemark);
            num++;
        }
        return num;
    }



}
