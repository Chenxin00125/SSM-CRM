package com.cx.workbench.service;

import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.Customer;

public interface CustomerService {

    //根据公司名称获取客户信息
    Customer getCustomerByCompany(String company);

    //根据线索创建一个客户
    int saveCustomer(Clue clue,String createTime,String id);
}
