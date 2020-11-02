package com.cx.workbench.service;

import com.cx.workbench.domain.ActivityRemark;
import com.cx.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    //根据activityId查询备注
    List<ClueRemark> selectRemarkByClueId(String clueId);

    //删除备注
    int deleteById(String id);

    //修改备注
    int updateById(ClueRemark clueRemark);

    //添加备注
    int addRemark(ClueRemark clueRemark);

    //根据activityID删除备注
    int deleteByClueId(String id);

    //根据clueId查询备注的条数
    int selectCountByClueId(String clueId);
}
