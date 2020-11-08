package com.cx.workbench.service;

import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.Customer;

import java.util.List;

public interface CustomerService {

    //根据公司名称获取客户信息
    Customer getCustomerByCompany(String company);

    //根据线索创建一个客户
    int saveCustomer(Clue clue,String createTime,String id);

    //获取customer总条数（包含条件）
    int getTotalCount(Customer customer);

    //获取CustomerList（包含条件）
    List<Customer> getCustomerList(Customer customer, int pageSize, int pageNum);

    //直接新建一个客户
    int saveCustomer1(Customer customer);

    //id查询客户
    Customer getCustomerById(String id);

    //修改客户
    int editCustomer(Customer customer);

    Customer detailCustomer(String id);
}
