package com.cx.workbench.service;

import com.cx.workbench.domain.Clue;

import java.util.List;

public interface ClueService {

    //添加线索
    int saveClue(Clue clue);

    List<Clue> getClueList(Clue clue, Integer pageSize, Integer pageNum);

    int getTotalCount(Clue clue);

    Clue getClueById(String id);

    int editClueById(Clue clue);

    Clue detailClueById(String id);
}
