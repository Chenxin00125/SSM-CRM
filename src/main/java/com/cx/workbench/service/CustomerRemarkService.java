package com.cx.workbench.service;

import com.cx.workbench.domain.ClueRemark;
import com.cx.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {

    //根据CustomerId查询备注
    List<CustomerRemark> selectRemarkByCustomerId(String customerId);


    //删除备注
    //int deleteById(String id);

    //修改备注
    //int updateById(ClueRemark clueRemark);

    //添加备注,线索转换，传值为线索
    int addRemark(List<ClueRemark> remarkList,String id);

    //根据activityID删除备注
    //int deleteByClueId(String id);
}
