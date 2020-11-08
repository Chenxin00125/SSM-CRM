package com.cx.workbench.service;

import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {

    //根据线索创建一个客户
    int saveContacts(Clue clue,String customerId, String id);

    List<Contacts> selectByCustomerId(String id);

}
