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
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" >
        $(function () {
            //页面加载完毕后，经用户文本框的内容清空
            $("#loginName").val("");
            //页面加载后input获得光标
            $("#loginName").focus();
            //为登录按钮绑定登录事件
            $("#loginBtn").click(function () {
                login()
            })
            //绑定回车键登录
            $(window).keydown(function (event) {
                //回车键数值为13
                if (13==event.keyCode){
                    login()
                }
            })
        })
        function login() {
            let loginAct = $.trim($("#loginAct").val());
            let loginPwd = $.trim($("#loginPwd").val());

            if(loginAct=="" && loginPwd==""){
                $("#msg").html("账号密码不能为空");
                return false;
            }else if(loginAct==""){
                $("#msg").html("账号不能为空");
                return false;
            }else  if(loginPwd==""){
                $("#msg").html("密码不能为空");
                return false;
            }
            $.ajax({
                url : "user/login",
                data : {
                    loginAct : loginAct,
                    loginPwd : loginPwd
                },
                type : "post",
                success : function (data) {
                    if(data.flag){
                        location.href=data.page;
                    }else{
                        $("#msg").html(data.msg);
                    }
                }
            })
        }
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%; height: 100%;">
    <img src="static/images/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="user/login" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="邮箱或者用户名"  name="loginAct" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" name="loginPwd" id="loginPwd">
                </div>
                <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>