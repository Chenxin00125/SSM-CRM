package com.cx.listener;

import com.cx.settings.domain.DicValue;
import com.cx.settings.service.DicService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class DataDicListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        ServletContext application = servletContextEvent.getServletContext();
        DicService dicService = WebApplicationContextUtils.getWebApplicationContext(application).getBean(DicService.class);
        Map<String, List<DicValue>> map = dicService.getAllDic();
        Set set = map.keySet();
        //获取一个迭代器，遍历集合
        Iterator iterator = set.iterator();
        while (iterator.hasNext()){
            String code = (String) iterator.next();
            application.setAttribute(code,map.get(code));
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
