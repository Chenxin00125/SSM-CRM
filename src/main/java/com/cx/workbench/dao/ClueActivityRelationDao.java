package com.cx.workbench.dao;

import com.cx.workbench.domain.ClueActivityRelation;

public interface ClueActivityRelationDao {

    //解除关联
    int deleteRelation(String id);

    //添加联系
    int relation(ClueActivityRelation car);

	

}
