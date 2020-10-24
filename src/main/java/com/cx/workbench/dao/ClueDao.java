package com.cx.workbench.dao;


import com.cx.workbench.domain.Clue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueDao {

    //添加线索
    int saveClue(Clue clue);

    List<Clue> getClueList(@Param("clue") Clue clue, @Param("startNum") int startNum, @Param("pageSize") Integer pageSize);

    int getTotalCount(Clue clue);

    Clue getClueById(String id);

    int editClueById(Clue clue);

    Clue detailClueById(String id);
}
