package com.cx.workbench.dao;

import com.cx.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> selectRemarkByClueId(String clueId);

    int deleteById(String id);

    int updateById(ClueRemark clueRemark);

    int addRemark(ClueRemark clueRemark);

    int deleteByClueId(String id);
}
