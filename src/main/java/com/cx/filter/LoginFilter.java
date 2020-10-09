package com.cx.filter;

import com.cx.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String path = request.getServletPath();
        //获取到的是 ：/login.jsp  -----http://localhost:8080/ssm_crm/login.jsp
        System.out.println(path);

        User user = (User) request.getSession().getAttribute("user");
        if ("/user/login".equals(path) || "/login.jsp".equals(path) || "/index.jsp".equals(path) || user!=null){
            filterChain.doFilter(servletRequest,servletResponse);
            System.out.println("没被拦截");
        }else{
            response.sendRedirect(request.getContextPath()+"/login.jsp");
            System.out.println("被拦截");
        }
    }

    @Override
    public void destroy() {

    }
}
