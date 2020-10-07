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
                   url : "test/test01",
                   data : {
                       name : "aaa",
                       loginPwd : "123"
                   },
                   type : "post",
                   dataType : "json",
                   success : function (data) {
                           alert(data.name+"---"+data.loginPwd);
                   }
               })
            })
        })
    </script>
</head>
<body>
test页面<%=basePath%><br>
<button id="btn" value="测试">测试</button><br/>
<form action="test/test01" method="post"><br/>
    <input type="text" name="name"><br/>
    <input type="password" name="loginPwd"><br/>
    <input type="submit" value="提交">
</form>
</body>
</html>

