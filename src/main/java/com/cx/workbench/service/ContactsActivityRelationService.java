package com.cx.workbench.service;

import com.cx.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {

    //转换联系
    int tranRelation(String[] activityId,String contactsId);

}
