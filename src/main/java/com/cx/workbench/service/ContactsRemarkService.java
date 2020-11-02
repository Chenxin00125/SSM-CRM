package com.cx.workbench.service;

import com.cx.workbench.domain.ClueRemark;
import com.cx.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {
    //添加备注
    int addRemark(List<ClueRemark> remarkList,String contactsId);
}
