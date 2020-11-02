package com.cx.workbench.service.impl;

import com.cx.workbench.dao.ContactsDao;
import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.Contacts;
import com.cx.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsDao contactsDao;

    @Override
    public int saveContacts(Clue clue, String customerId,String id) {
        return contactsDao.saveContacts(clue,customerId,id);
    }
}
