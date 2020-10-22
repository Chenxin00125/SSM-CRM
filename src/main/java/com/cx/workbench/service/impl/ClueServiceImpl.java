package com.cx.workbench.service.impl;

import com.cx.workbench.dao.ClueDao;
import com.cx.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;
}
