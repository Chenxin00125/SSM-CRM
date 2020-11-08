package com.cx.workbench.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.util.DateTimeUtil;
import com.cx.util.UUIDUtil;
import com.cx.workbench.domain.Contacts;
import com.cx.workbench.domain.Customer;
import com.cx.workbench.domain.CustomerRemark;
import com.cx.workbench.domain.Tran;
import com.cx.workbench.service.ContactsService;
import com.cx.workbench.service.CustomerRemarkService;
import com.cx.workbench.service.CustomerService;
import com.cx.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("workbench/customer/")
public class CustomerController {
    @Autowired
    private CustomerService customerService;
    @Autowired
    private CustomerRemarkService remarkService;
    @Autowired
    private TranService tranService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private UserService userService;
    @Autowired
    private DateTimeUtil dateTimeUtil;
    @Autowired
    private UUIDUtil uuidUtil;

    @RequestMapping("getCustomerList")
    @ResponseBody
    public Map getCustomerList(Customer customer, Integer pageNum, Integer pageSize){
        List<Customer> customerList = customerService.getCustomerList(customer,pageSize,pageNum);
        int totalCount = customerService.getTotalCount(customer);
        Map map = new HashMap();
        map.put("customerList",customerList);
        map.put("totalCount",totalCount);
        return map;
    }

    @RequestMapping("saveCustomer")
    @ResponseBody
    public boolean saveCustomer(Customer customer, HttpServletRequest request){
        customer.setCreateTime(dateTimeUtil.getSysTime());
        User user = (User) request.getSession().getAttribute("user");
        customer.setCreateBy(user.getId());
        customer.setId(uuidUtil.getUUID());
        boolean flag = false;
        int num = customerService.saveCustomer1(customer);
        if (num==1){
            flag = true;
        }
        return flag;
    }

    @RequestMapping("getCustomerById")
    @ResponseBody
    public Customer getCustomerById(String id){
        Customer customer = customerService.getCustomerById(id);
        return customer;
    }

    @RequestMapping("editCustomer")
    @ResponseBody
    public Map editCustomer(Customer customer,HttpServletRequest request){
        Map map = new HashMap();
        boolean flag = false;
        customer.setEditTime(dateTimeUtil.getSysTime());
        User user = (User)request.getSession().getAttribute("user");
        customer.setEditBy(user.getId());
        System.out.println(customer);
        int num = customerService.editCustomer(customer);
        if (num==1){
            flag = true;
            map.put("customer",customer);
        }
        map.put("flag",flag);
        return map;
    }

    @RequestMapping("detailCustomerById")
    @ResponseBody
    public ModelAndView detailCustomerById(String id){
        ModelAndView modelAndView = new ModelAndView();
        Customer customer = customerService.detailCustomer(id);
        modelAndView.addObject("customer",customer);
        List<CustomerRemark> remarkList = remarkService.selectRemarkByCustomerId(id);
        modelAndView.addObject("remarkList",remarkList);
        List<Tran> tranList = tranService.selectByCustomerId(id);
        modelAndView.addObject("tranList",tranList);
        List<Contacts> contactsList = contactsService.selectByCustomerId(id);
        modelAndView.addObject("contactsList",contactsList);
        List<User> userList = userService.getUserList();
        modelAndView.addObject("userList",userList);
        modelAndView.setViewName("customer/detail");
        return modelAndView;
    }

}
