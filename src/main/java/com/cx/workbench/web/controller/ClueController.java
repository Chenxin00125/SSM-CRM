package com.cx.workbench.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.util.DateTimeUtil;
import com.cx.util.UUIDUtil;
import com.cx.workbench.domain.Activity;
import com.cx.workbench.domain.Clue;
import com.cx.workbench.domain.ClueActivityRelation;
import com.cx.workbench.domain.ClueRemark;
import com.cx.workbench.service.ActivityService;
import com.cx.workbench.service.ClueActivityRelationService;
import com.cx.workbench.service.ClueRemarkService;
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
    @Autowired
    private ClueRemarkService remarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService relationService;

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
        List<ClueRemark> remarkList = remarkService.selectRemarkByClueId(id);
        List<Activity> activityList = activityService.getActivityByClueId(id);
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
        modelAndView.addObject("remarkList",remarkList);
        modelAndView.addObject("clue",clue);
        modelAndView.addObject("activityList",activityList);
        modelAndView.setViewName("clue/detail");
        return modelAndView;
    }

    @RequestMapping("editRemark")
    @ResponseBody
    public boolean editRemark(ClueRemark clueRemark,HttpServletRequest request){
        boolean flag = false;
        clueRemark.setEditTime(dateTimeUtil.getSysTime());
        User user = (User)request.getSession().getAttribute("user");
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditFlag("1");
        System.out.println(clueRemark);
        int num = remarkService.updateById(clueRemark);
        if (num==1){
            flag = true;
        }
        return flag;
    }

    @RequestMapping("addRemark")
    @ResponseBody
    public Map addRemark(ClueRemark clueRemark){
        Map map = new HashMap();
        boolean flag = false;
        clueRemark.setCreateTime(dateTimeUtil.getSysTime());
        System.out.println(clueRemark.getCreateTime().length());
        clueRemark.setId(uuidUtil.getUUID());
        clueRemark.setEditFlag("0");
        clueRemark.setEditBy(null);
        clueRemark.setEditTime(null);
        System.out.println(clueRemark);
        int num = remarkService.addRemark(clueRemark);
        if (num==1){
            flag = true;
            map.put("clueRemark",clueRemark);
        }
        map.put("flag",flag);
        return map;
    }

    @RequestMapping("deleteRemark")
    @ResponseBody
    public boolean deleteRemark(String id){
        boolean flag = false;
        int num = remarkService.deleteById(id);
        if (num == 1){
            flag = true;
        }
        return flag;
    }

    @RequestMapping("freeRelation")
    @ResponseBody
    public boolean freeRelation(String id){
        boolean flag = false;
        int num = relationService.deleteRelation(id);
        if (num == 1){
            flag = true;
        }
        return flag;
    }

    @RequestMapping("getSearchActivity")
    @ResponseBody
    public List<Activity> getSearchActivity(String name,String clueId){
        List<Activity> activityList= activityService.getClueActivity(name,clueId);
        return  activityList;
    }

    @RequestMapping("relation")
    @ResponseBody
    public Map relation(String activityId,String clueId){
        boolean flag = false;
        Map map = new HashMap();
        ClueActivityRelation car = new ClueActivityRelation();
        car.setClueId(clueId);
        String[] aid = activityId.split(",");
        System.out.println(aid);
        int num = 0;
        for (int i = 0; i < aid.length; i++) {
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(aid[i]);
            relationService.relation(car);
            num ++;
        }
        if(num>0){
            flag = true;
            map.put("flag",flag);
            List<Activity> activityList = activityService.getActivityByClueId(clueId);
            map.put("activityList",activityList);
        }

        return map;
    }

}
