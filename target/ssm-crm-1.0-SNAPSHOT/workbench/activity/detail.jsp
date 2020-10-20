<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/css/time.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <%--日期插件--%>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">


        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        function hiden(){
            $("#remark").val("");
            $("#remark").focusout();
            $("#cancelAndSaveBtn").hide();
            //设置remarkDiv的高度为130px
            $("#remarkDiv").css("height","90px");
            cancelAndSaveBtnDefault = true;
        }
        $(function(){

            /*添加时间日期插件*/
            $(".time").datetimepicker({
                minView : "month",
                language : "zh-CN",
                format : "yyyy-mm-dd",
                autoclose : true,
                todayBtn : true,
                pickerPosition : "bottom-left"
            });

            /*获取user列表*/
            // getUserList();

            $("#remark").focus(function(){
                if(cancelAndSaveBtnDefault){
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height","130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });



            $("#cancelBtn").click(function(){
                //显示
                hiden();
                $("#save-remark").off("click");
                $("#save-remark").on("click",addRemark);

                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height","90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#remarkBody").on("mouseover",".remarkDiv",function(){
                $(this).children("div").children("div").show();
            });

            $("#remarkBody").on("mouseout",".remarkDiv",function(){
                $(this).children("div").children("div").hide();
            });

            $("#remarkBody").on("mouseover",".myHref",function(){
                $(this).children("span").css("color","red");
            });

            $("#remarkBody").on("mouseout",".myHref",function(){
                $(this).children("span").css("color","#E6E6E6");
            });
            /*绑定删除按钮*/
            $("#deleteActivity").click(function () {
                if (confirm("确定删除该活动吗")){
                    let id = "${activity.id}"
                    $.ajax({
                        url : "workbench/activity/deleteActivity",
                        type : "post",
                        data : {
                            "ids" : id
                        },
                        dataType : "json",
                        success : function (data) {
                            if(data){
                                alert("该活动已删除");
                                location.href = "workbench/activity/index.jsp";
                            }else {
                                alert("服务器异常，请稍后重新操作");
                            }
                        }
                    })
                }
            })


            /*绑定编辑按钮*/
            $("#editWindow").click(function () {
                $("#editActivityModal").modal("show");
            })

            /*绑定更新按钮*/
            $("#editActivityBtn").click(function () {
                let id = "${activity.id}"
                $.ajax({
                    url : "workbench/activity/editActivity",
                    type : "post",
                    data : {
                        "id" : id,
                        "name" :      $("#edit-marketActivityName").val(),
                        "owner" :     $("#edit-marketActivityOwner").val(),
                        "startDate" : $("#edit-startTime").val(),
                        "endDate" :   $("#edit-endTime").val(),
                        "cost" :      $("#edit-cost").val(),
                        "description":$("#edit-describe").val(),
                    },
                    dataType : "json",
                    success : function (data) {
                        if(data.flag){
                            $("#titleName").html("市场活动-"+data.activity.name+"<small>"+data.activity.startDate+" ~ "+data.activity.endDate+"</small>")
                            $("#afterOwner").html($("#"+data.activity.owner+"").val());
                            $("#afterName").html(data.activity.name);
                            $("#afterStartDate").html(data.activity.startDate);
                            $("#afterEndDate").html(data.activity.endDate);
                            $("#afterCost").html(data.activity.cost);
                            $("#afterEditBy").html($("#"+data.activity.editBy+"").val());
                            $("#afterEditTime").html(data.activity.editTime);
                            $("#afterDescription").html(data.activity.description);
                            $("#editActivityModal").modal("hide");
                        }else{
                            alert("服务器异常，请稍后重新操作");
                            $("#editActivityModal").modal("hide");
                        }
                    }
                })
            })

            /*绑定保存按钮*/
            $("#save-remark").click(function () {
                addRemark();
            })
        });

        function addRemark(){

            let noteContent = $.trim($("#remark").val());
            let activityId = "${activity.id}";
            let createBy = "${sessionScope.user.id}";
            //console.log(noteContent);
            if(noteContent==""){
                alert("请填写备注信息");
                $("#remark").focus();
            }else{
                $.ajax({
                    url : "workbench/activity/addRemark",
                    type : "get",
                    data : {
                        "noteContent" : noteContent,
                        "activityId" : activityId,
                        "createBy" : createBy
                    },
                    dataType : "json",
                    success : function (data) {
                        if(data.flag){
                            let remark = data.activityRemark;
                            let html = "";
                            $("#remark").val("添加备注成功");
                            let time = remark.editFlag==1?remark.editTime:remark.createTime;

                            html += '<div class="remarkDiv" id="'+remark.id+'div" style="height: 60px;">';
                            html += '<img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="'+remark.id+'">'+remark.noteContent+'</h5>';
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>'+"${activity.name}"+'</b>&nbsp;&nbsp;&nbsp;';
                            html += '<small style="color: gray;" id="'+remark.id+'time">'+time+'</small><small>&nbsp;&nbsp;&nbsp;&nbsp;由 </small>';
                            html += '<small style="color: gray;" id="'+remark.id+'ByUser" class="'+"${sessionScope.user.id}"+'">'+"${sessionScope.user.name}"+'</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px;display: none" >';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="bjRemark(\''+remark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+remark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
                            html += '</div></div></div>';
                            $("#remarkAfter").after(html);
                            setTimeout(function () {
                                hiden();
                            },4000)
                        }else{
                            alert("系统繁忙，请稍后重试");
                            $("#remark").val(noteContent);
                            $("#remark").focus();
                        }
                    }
                })
            }
        }

        /*设置一个timeout避免页面加载过快而js找不到东西*/
        setTimeout(function () {
            $("#edit-marketActivityOwner").val("${activity.owner}");
            $.each($("#edit-marketActivityOwner").children(),function(i,child){
                let childValue = $(child).attr("value");
                if( childValue =="${activity.owner}"){
                    $("#afterOwner").html($(child).text());
                }
                /*备注附上user值*/
                $("."+childValue).html($(child).text());
            })

        },200)

        function bjRemark(id) {
            //alert(id);
            let text = $("#"+id).text();
            //alert(text);
            $("#remark").focus();
            $("#remark").val(text);

            /*给之前的点击事件解绑*/
            $("#save-remark").off("click");
            $("#save-remark").on("click",function () {
                let noteContent = $.trim($("#remark").val());
                if(noteContent==""){
                    alert("不能修改为空");
                }else if(noteContent==text){
                    alert("您还没有修改内容");
                } else{
                    $.ajax({
                        url : "workbench/activity/editRemark",
                        type : "post",
                        data : {
                            "id" : id,
                            "noteContent" : noteContent
                        },
                        dataType : "json",
                        success : function (data) {
                            if(data){
                                $("#"+id).html(noteContent);
                                /*修改完成获取当前时间给备注时间显示*/
                                //获取当前日期
                                let date = (new Date()).toLocaleDateString().replaceAll("/","-")
                                //获取当前时间 ，时 分 秒
                                let time = (new Date()).getHours()+":"+(new Date()).getMinutes()+":"+(new Date()).getSeconds();
                                $("#"+id+"time").html(date+"&nbsp;"+time);
                                $("#"+id+"ByUser").html("${sessionScope.user.name}");
                                $("#remark").val("修改成功");
                                /*修改完成后清除事件*/
                                $("#save-remark").off("click");
                                setTimeout(function () {
                                    hiden();
                                },4000)
                            }else{
                                alert("系统繁忙，请稍后重试");
                                $("#remark").val(noteContent);
                                $("#remark").focus();
                            }
                        }
                    })
                }
            })
        }

        function deleteRemark(id) {
            if(confirm("确定删除该备注吗")){
                $.ajax({
                    url : "workbench/activity/deleteRemark",
                    type : "post",
                    data : {
                        "id" : id
                    },
                    dataType : "json",
                    success : function (data) {
                        if(data.flag){
                            $("#"+id+"div").remove();
                        }else{
                            alert("系统繁忙，请稍后重试");
                        }
                    }
                })
            }
        }



    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId" >

    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner"  name="owner">
                                <c:forEach begin="0" end="${userList.size()}" step="1" items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName"  value="${activity.name}" name="name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startTime" readonly value="${activity.startDate}" name="startDate">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endTime" readonly value="${activity.endDate}" name="endDate">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="${activity.cost}" name="cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe" name="description">${activity.description}</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="editActivityBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3 id="titleName">市场活动-${activity.name}<small>${activity.startDate} ~ ${activity.endDate}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button type="button" class="btn btn-danger" id="deleteActivity"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="afterOwner"></b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="afterName">${activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="afterStartDate">${activity.startDate} </b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="afterEndDate">${activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="afterCost">${activity.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="afterEditBy">${activity.editBy}&nbsp;&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="afterEditTime">${activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b id="afterDescription">
                ${activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
    <div class="page-header" id="remarkAfter">
        <h4>备注</h4>
    </div>

    <c:forEach begin="0" end="${remarkList.size()}" step="1" items="${remarkList}" var="remark">
        <div class="remarkDiv" style="height: 60px;" id="${remark.id}div">
            <img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;" >
                <h5 id="${remark.id}">${remark.noteContent}</h5>
                <font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b>&nbsp;&nbsp;&nbsp;
                <small style="color: gray;" id="${remark.id}time">${remark.editFlag==1?remark.editTime:remark.createTime}</small><small>&nbsp;&nbsp;&nbsp;由</small>
                <small style="color: gray;" id="${remark.id}ByUser" class="${remark.editFlag==1?remark.editBy:remark.createBy}"></small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);" onclick="bjRemark('${remark.id}')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);" onclick="deleteRemark('${remark.id}')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="save-remark">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>