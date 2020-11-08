package com.cx.workbench.service.impl;

import com.cx.workbench.dao.CustomerDao;
import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.Customer;
import com.cx.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


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

    @Override
    public int getTotalCount(Customer customer) {
        int totalCount = customerDao.getTotalCount(customer);
        return totalCount;
    }

    @Override
    public List<Customer> getCustomerList(Customer customer, int pageSize, int pageNum) {
        int startNum = (pageNum - 1) * pageSize;
        List<Customer> customerList = customerDao.getCustomerList(customer,startNum,pageSize);
        return customerList;
    }

    @Override
    public int saveCustomer1(Customer customer) {
        return customerDao.saveCustomer1(customer);
    }

    @Override
    public Customer getCustomerById(String id) {
        return customerDao.getCustomerById(id);
    }

    @Override
    public int editCustomer(Customer customer) {
        return customerDao.editCustomer(customer);
    }

    @Override
    public Customer detailCustomer(String id) {
        return customerDao.getCustomerById(id);
    }
}
