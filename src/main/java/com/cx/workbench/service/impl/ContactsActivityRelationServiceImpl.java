package com.cx.workbench.service.impl;

import com.cx.util.UUIDUtil;
import com.cx.workbench.dao.ContactsActivityRelationDao;
import com.cx.workbench.domain.ClueActivityRelation;
import com.cx.workbench.domain.ContactsActivityRelation;
import com.cx.workbench.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {

    @Autowired
    private ContactsActivityRelationDao relationDao;
    @Autowired
    private UUIDUtil uuidUtil;

    @Override
    public int tranRelation(String[] activityId,String contactsId) {
        ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
        int num = 0;
        for (int i = 0; i < activityId.length; i++) {
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId[i]);
            contactsActivityRelation.setContactsId(contactsId);
            relationDao.addRelation(contactsActivityRelation);
            num ++ ;
        }

        return num;
    }
}
