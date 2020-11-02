package com.cx.workbench.service;

import com.cx.workbench.domain.Clue;

public interface ContactsService {

    //根据线索创建一个客户
    int saveContacts(Clue clue,String customerId, String id);

}
