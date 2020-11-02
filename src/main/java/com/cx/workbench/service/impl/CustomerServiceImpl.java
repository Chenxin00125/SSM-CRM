package com.cx.workbench.service.impl;

import com.cx.workbench.dao.CustomerDao;
import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.Customer;
import com.cx.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerDao customerDao;

    @Override
    public Customer getCustomerByCompany(String company) {
        Customer customer = customerDao.getCustomerByCompany(company);
        return customer;
    }

    @Override
    public int saveCustomer(Clue clue,String createTime,String id) {
        return customerDao.saveCustomer(clue,createTime,id);
    }
}
