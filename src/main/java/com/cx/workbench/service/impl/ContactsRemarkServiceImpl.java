package com.cx.workbench.service.impl;

import com.cx.util.UUIDUtil;
import com.cx.workbench.dao.ContactsRemarkDao;
import com.cx.workbench.domain.ClueRemark;
import com.cx.workbench.domain.ContactsRemark;
import com.cx.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ContactsRemarkServiceImpl implements ContactsRemarkService {
    @Autowired
    private ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private UUIDUtil uuidUtil;

    @Override
    public int addRemark(List<ClueRemark> remarkList,String contactsId) {
        ContactsRemark contactsRemark = new ContactsRemark();
        int num = 0;
        for (ClueRemark remark: remarkList ) {
            contactsRemark.setId(uuidUtil.getUUID());
            contactsRemark.setNoteContent(remark.getNoteContent());
            contactsRemark.setCreateBy(remark.getCreateBy());
            contactsRemark.setCreateTime(remark.getCreateTime());
            contactsRemark.setEditBy(null);
            contactsRemark.setEditTime(null);
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(contactsId);
            contactsRemarkDao.addRemark(contactsRemark);
            num++;
        }
        return num;
    }
}
