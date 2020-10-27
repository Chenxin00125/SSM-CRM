package com.cx.workbench.service;

import com.cx.workbench.domain.ClueActivityRelation;

public interface ClueActivityRelationService {

    //解除关联
    int deleteRelation(String id);

    //添加联系
    int relation(ClueActivityRelation car);
}
