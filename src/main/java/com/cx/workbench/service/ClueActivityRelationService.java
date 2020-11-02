package com.cx.workbench.service;

import com.cx.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    //解除关联
    int deleteRelation(String id);

    //添加联系
    int relation(ClueActivityRelation car);

    //转换查询activityId
    String[] getActivityId(String clueId);

    //转换线索，删除线索与市场活动的关联关系
    int deleteRelationByClueId(String id);
}
