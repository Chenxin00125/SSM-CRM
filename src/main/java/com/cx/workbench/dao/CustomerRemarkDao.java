package com.cx.workbench.dao;


import com.cx.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    int addRemark(CustomerRemark customerRemark);

    List<CustomerRemark> selectRemarkByCustomerId(String customerId);
}
