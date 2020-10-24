package com.cx.workbench.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.util.DateTimeUtil;
import com.cx.util.UUIDUtil;
import com.cx.workbench.domain.Activity;
import com.cx.workbench.domain.ActivityRemark;
import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.ClueRemark;
import com.cx.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/clue/")
public class ClueController {

    @Autowired
    private ClueService clueService;
    @Autowired
    private UUIDUtil uuidUtil;
    @Autowired
    private DateTimeUtil dateTimeUtil;
    @Autowired
    private UserService userService;

    @RequestMapping("saveClue")
    @ResponseBody
    public boolean saveClue(Clue clue, HttpServletRequest request){
        boolean flag = false;
        User user = (User) request.getSession().getAttribute("user");
        clue.setId(uuidUtil.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(dateTimeUtil.getSysTime());
        int num = clueService.saveClue(clue);
        if (num>0){
            flag = true;
        }
        System.out.println(clue);
        return flag;
    }

    @RequestMapping("getClueList")
    @ResponseBody
    public Map getClueList(Clue clue, Integer pageNum, Integer pageSize){

        List<Clue> clueList = clueService.getClueList(clue,pageSize,pageNum);
        int totalCount = clueService.getTotalCount(clue);
        Map map = new HashMap();
        map.put("clueList",clueList);
        map.put("totalCount",totalCount);
        return map;
    }


    @RequestMapping("getClueById")
    @ResponseBody
    public Clue getClueById(String id){
        Clue clue = clueService.getClueById(id);
        return clue;
    }

    @RequestMapping("editClue")
    @ResponseBody
    public boolean editClue(Clue clue,HttpServletRequest request){
        boolean flag = false;
        clue.setEditTime(dateTimeUtil.getSysTime());
        User user = (User)request.getSession().getAttribute("user");
        clue.setEditBy(user.getId());
        int num = clueService.editClueById(clue);
        if (num==1){
            flag = true;
        }
        return flag;
    }

    @RequestMapping("detailClueById")
    public ModelAndView detailClueById(String id){
        Clue clue = clueService.detailClueById(id);
        ModelAndView modelAndView = new ModelAndView();
        List<User> userList = userService.getUserList();
       // List<ClueRemark> remarkList = remarkService.selectRemarkByActivityId(id);
        for (User user:userList ) {
            if(user.getId().equals(clue.getCreateBy())){
                clue.setCreateBy(user.getName());
            }
            if(user.getId().equals(clue.getOwner())){
                clue.setOwner(user.getName());
            }
            if(user.getId().equals(clue.getEditBy())){
                clue.setEditBy(user.getName());
            }
        }

        modelAndView.addObject("userList",userList);
        //modelAndView.addObject("remarkList",remarkList);
        modelAndView.addObject("clue",clue);
        modelAndView.setViewName("clue/detail");
        return modelAndView;
    }

}
