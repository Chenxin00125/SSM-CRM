package com.cx.workbench.web.controller;

import com.cx.settings.domain.User;
import com.cx.settings.service.UserService;
import com.cx.util.DateTimeUtil;
import com.cx.util.UUIDUtil;
import com.cx.workbench.domain.*;
import com.cx.workbench.service.*;
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
    private ClueRemarkService clueRemarkService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService relationService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TranService tranService;
    @Autowired
    private TranHistoryService historyService;

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
        List<ClueRemark> remarkList = clueRemarkService.selectRemarkByClueId(id);
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
        int num = clueRemarkService.updateById(clueRemark);
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
        int num = clueRemarkService.addRemark(clueRemark);
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
        int num = clueRemarkService.deleteById(id);
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
            car.setId(uuidUtil.getUUID());
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

    @RequestMapping("getRelationActivity")
    @ResponseBody
    public List<Activity> getRelationActivity(String clueId){
        List<Activity> activityList = activityService.getActivityByTran(clueId);
        return activityList;
    }

    @RequestMapping("deleteClue")
    @ResponseBody
    public boolean deleteClue(String ids){
        String[] id = ids.split(",");
        boolean flag = false;
        int aNum = 0;
        int a = 0;
        for ( int i = 0 ;i < id.length ; i++){
            int b = clueRemarkService.deleteByClueId(id[i]);
            int num = clueService.deleteClue(id[i]);
            aNum = aNum + num;
            a = a + b;
        }
        if (aNum>=1){
            flag = true;
        }
        return flag;
    }



    @RequestMapping("tran")
    @ResponseBody
    public boolean tran(String clueId,String flagId, String money, String name, String expectedDate, String stage, String activityId ,HttpServletRequest request){
        boolean flag = false;
        //第一步：获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue = clueService.detailClueById(clueId);
        //第二步：通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        Customer customer = customerService.getCustomerByCompany(clue.getCompany());
        //如果客户不存在创建客户
        boolean customerFlag = true;
        if (customer==null){
            customer = new Customer();
            customer.setId(uuidUtil.getUUID());
            String customerId = customer.getId();
            String createTime = dateTimeUtil.getSysTime();
            int customerNum = customerService.saveCustomer(clue,createTime,customerId);
            if(customerNum!=1){
                customerFlag = false;
            }
        }
        //第三步：通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(uuidUtil.getUUID());
        String contactsId = contacts.getId();
        contacts.setCustomerId(customer.getId());
        boolean contactsFlag = false;
        int contactsNum = contactsService.saveContacts(clue,customer.getId(),contactsId);
        if (contactsNum==1){
            contactsFlag = true;
        }
        //第四步：线索备注转换到客户备注以及联系人备注
        CustomerRemark customerRemark = new CustomerRemark();
        ContactsRemark contactsRemark = new ContactsRemark();
        List<ClueRemark> remarkList = clueRemarkService.selectRemarkByClueId(clueId);
        int remarkNum = clueRemarkService.selectCountByClueId(clueId);
        int contactsRemarkNum = contactsRemarkService.addRemark(remarkList,contactsId);
        int customerRemarkNum = customerRemarkService.addRemark(remarkList,customer.getId());
        boolean remarkFlag = false;
        if (contactsRemarkNum==remarkNum && customerRemarkNum==remarkNum){
            remarkFlag = true;
        }

        //第五步：“线索和市场活动”的关系转换到“联系人和市场活动”的关系
        boolean relationFlag = false;
        String[] activityIds = relationService.getActivityId(clueId);
        int num = contactsActivityRelationService.tranRelation(activityIds,contacts.getId());
        if(num == activityIds.length ){
            relationFlag = true ;
        }
        //第六步：如果有创建交易需求，创建一条交易
        boolean tranFlag = true;
        boolean hisFlag = true;
        if(flagId.equals("1")){
            Tran tran = new Tran();
            tran.setId(uuidUtil.getUUID());
            tran.setActivityId(activityId);
            tran.setMoney(money);
            tran.setCustomerId(customer.getId());
            tran.setStage(stage);
            tran.setSource(clue.getSource());
            tran.setContactsId(contacts.getId());
            tran.setDescription("转换创建的交易记录");
            tran.setExpectedDate(expectedDate);
            tran.setName(name);
            tran.setOwner(clue.getOwner());
            User user = (User) request.getSession().getAttribute("user");
            tran.setCreateBy(user.getId());
            tran.setCreateTime(dateTimeUtil.getSysTime());
            int tranNum = tranService.tranDeal(tran);
            if (tranNum!=1){
                tranFlag = false;
            }
            //第七步：如果创建了交易，则创建一条该交易下的交易历史

            String id = uuidUtil.getUUID();
            int hisNum = historyService.tranHistory(tran,id);
            if(hisNum!=1){
                hisFlag = false;
            }

        }

        //第八步：删除线索备注
        clueRemarkService.deleteByClueId(clueId);
        //第九步：删除线索和市场活动的关系
        relationService.deleteRelationByClueId(clueId);
        //第十步：删除线索
        int clueNum = clueService.deleteClue(clueId);
        boolean clueFlag = false;
        if(clueNum==1){
            clueFlag = true;
        }

        if (clueFlag&&contactsFlag&&customerFlag&&hisFlag&&relationFlag&&relationFlag&&remarkFlag&&tranFlag){
            flag = true;
        }

        return flag;
    }
}
