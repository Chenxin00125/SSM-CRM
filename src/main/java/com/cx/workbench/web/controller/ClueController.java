package com.cx.workbench.web.controller;

import com.cx.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench/clue/")
public class ClueController {

    @Autowired
    private ClueService clueService;
}
