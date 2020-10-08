<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":"
            + request.getServerPort()
            + request.getContextPath() + "/";
%>
<html>

<head>
    <base href="<%=basePath%>">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#btn").click(function () {
               $.ajax({
                   url : "logintest.do",
                   data : {
                       name : $("#loginAct").val(),
                       loginPwd : $("#loginPwd").val()
                   },
                   type : "post",
                   dataType : "json",
                   success : function (data) {
                           location.href=data;
                   }
               })
            })
        })
    </script>
</head>
<body>
test页面<%=basePath%><br>
<%--<button id="btn" value="测试">测试</button><br/>--%>
<form action="test/test01" method="post"><br/>
    name:<input id="loginAct" type="text" name="loginAct"><br/>
    loginPwd:<input id="loginPwd" type="password" name="loginPwd"><br/>
    <input type="button" id="btn" value="提交" >
</form>
</body>
</html>

