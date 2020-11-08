package com.cx.workbench.dao;

import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.Customer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CustomerDao {

    //根据公司名称获取客户信息
    Customer getCustomerByCompany(String company);

    //根据线索创建一个客户
    int saveCustomer(@Param("clue") Clue clue, @Param("createTime") String createTime,@Param("id")String id);

    int getTotalCount(Customer customer);

    List<Customer> getCustomerList(@Param("customer")Customer customer, @Param("startNum")int startNum, @Param("pageSize")int pageSize);

    int saveCustomer1(Customer customer);

    Customer getCustomerById(String id);

    Customer detailCustomer(String id);

    int editCustomer(Customer customer);

}
