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
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <%--日期插件--%>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <%--分页插件--%>
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        $(function(){




            pageList(1,2);

            /*点击查询按钮分页查询*/
            $("#searchCustomerListBtn").click(function () {
                $("#hidden-name").val($("#search-name").val());
                $("#hidden-owner").val($("#search-owner").val());
                $("#hidden-phone").val($("#hidden-phone").val());
                $("#hidden-website").val($("#hidden-website").val());
                pageList(1,2);
            })



            //定制字段
            $("#definedColumns > li").click(function(e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            /*点击创建按钮，查询用户列表*/
            $("#createWindow").click(function () {
                /*获取到用户下拉框的长度，如果有值了就不在去数据库查询了*/
                let length = $("#create-customerOwner").children().length;
                //console.log($("#create-marketActivityOwner").children());
                if(length==0){
                    let data = getUserList();
                    //console.log(data);
                    $.each(data ,function(i,user){
                        $("#create-customerOwner").append("<option value="+user.id+">"+user.name+"</option>");
                    })
                }
                let userId = $('#hidden-user-id').val();
                //console.log(userId);
                $("#create-customerOwner").val(userId);
                //打开创建的模块窗口
                $("#createCustomerModal").modal("show");
            })

            /*添加时间日期插件*/
            $(".time").datetimepicker({
                minView : "month",
                language : "zh-CN",
                format : "yyyy-mm-dd",
                autoclose : true,
                todayBtn : true,
                pickerPosition : "top-left"
            });

            /*保存*/
            $("#saveCustomerBtn").click(function () {
                let form = $("#saveCustomerForm").serialize();
                form = form.replaceAll("+","");
                $.ajax({
                    url : "workbench/customer/saveCustomer",
                    type : "post",
                    data : form,
                    dataType : "json",
                    contentType : "application/x-www-form-urlencoded",
                    success : function (data) {
                        if(data){
                            $("#createCustomerModal").modal("hide");
                            pageList(1,2);
                            $("#saveCustomerForm")[0].reset();
                        }else{
                            alert("服务器异常，请稍后重新操作");
                        }

                    }
                })
            })

            /*
             * 绑定修改窗口，
            * */

            $("#editWindow").click(function () {
                /*获取到打勾的复选框的jQuery对象*/
                let inputName = $("input[class=inputName]:checked");
                if (inputName.length>1){
                    alert("只能选择一条记录进行修改");
                    $("#inputBoxs").prop("checked",false);
                    for (let i = 0; i <inputName.length; i++) {
                        $(inputName[i]).prop("checked",false);
                    }
                }else if(inputName.length==0){
                    alert("请选择一条记录进行修改");
                }else{
                    /*获取到用户下拉框的长度，如果有值了就不在去数据库查询了*/
                    let length = $("#edit-customerOwner").children().length;
                    if(length==0){
                        let data = getUserList();
                        //console.log(data);
                        $.each(data ,function(i,user){
                            $("#edit-customerOwner").append("<option value="+user.id+">"+user.name+"</option>");
                        })
                    }
                    let id = $(inputName).val();
                    $.ajax({
                        url : "workbench/customer/getCustomerById",
                        type : "get",
                        data : {
                            "id" : id
                        },
                        dataType : "json",
                        success : function (data) {
                            //console.log(data);
                            $("#edit-customerName").val(data.name);
                            $("#edit-website").val(data.website);
                            $("#edit-phone").val(data.phone);
                            $("#edit-address").val(data.address);
                            $("#edit-nextContactTime").val(data.nextContactTime);
                            $("#edit-contactSummary").val(data.contactSummary);
                            $("#edit-describe").html(data.description);
                            $("#edit-customerOwner").val(data.owner);
                        }
                    })
                    $("#editCustomerModal").modal("show");
                }
            })


            /*绑定更新按钮*/
            $("#editCustomerBtn").click(function () {
                let form = $("#editCustomerForm").serialize();
                form = form.replaceAll("+","");
                form = form + "&id="+ $("input[class=inputName]:checked").val();
                $.ajax({
                    url : "workbench/customer/editCustomer",
                    type : "post",
                    data : form,
                    dataType : "json",
                    contentType : "application/x-www-form-urlencoded",
                    success : function (data) {
                        if(data.flag){
                            alert("修改成功");
                            $("#editCustomerModal").modal("hide");
                            pageList(1,2);
                        }else{
                            alert("服务器异常，请稍后重新操作");
                        }
                    }
                })
            })

        });

        function pageList(pageNum,pageSize) {
            $("#inputBoxs").prop("checked",false);
            let form = $("#searchForm").serialize();
            let pageSize1 = pageSize;
            let pageNum1 = pageNum;

            pageSize = "pageSize="+pageSize;
            pageNum = "pageNum=" + pageNum;
            form = form.replaceAll("+","");
            form = form + "&" +pageNum + "&" +pageSize;
            $.ajax({
                url : "workbench/customer/getCustomerList",
                type : "post",
                data : form,
                dataType : "json",
                success : function (data) {

                    let html = "";
                    $.each(data.customerList,function (i,customer) {
                        html += '<tr class="customer">';
                        html += '<td><input type="checkbox" class="inputName" value="'+customer.id+'" /></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="href = \'workbench/customer/detailCustomerById?id='+customer.id+'\'">'+customer.name+'</a></td>';
                        html += '<td>'+customer.owner+'</td>';
                        html += '<td>'+customer.phone+'</td>';
                        html += '<td>'+customer.website+'</td>';
                        html += '</tr>'
                    })
                    $("#customerBody").html(html);

                    let totalPage = Math.ceil(data.totalCount/pageSize1) ;
                    $("#customerPage").bs_pagination({
                        currentPage: pageNum1, // 页码
                        rowsPerPage: pageSize1, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPage, // 总页数
                        totalRows: data.totalCount, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        /*回调函数，点击分页控件后触发事件，*/
                        onChangePage : function(event, data){
                            $("#search-name").val($("#hidden-name").val());
                            $("#search-owner").val($("#hidden-owner").val());
                            $("#search-startDate").val($("#hidden-startDate").val());
                            $("#search-endDate").val($("#hidden-endDate").val());
                            pageList(data.currentPage , data.rowsPerPage);
                        }
                    });
                }
            })
            /*绑定全选复选框*/
            $("#inputBoxs").click(function () {
                $(".inputName").prop("checked",this.checked);
            })

            /*绑定下面的复选框*/
            /*动态的标签click方法触发不了事件，用on方法代替*/
            $("#customerBody").on("click",$(".inputName"),function () {
                let length = $("input[class=inputName]:checked").length;
                $("#inputBoxs").prop("checked",$(".inputName").length==length);
            })
        }

        function getUserList() {
            let result ;
            $.ajax({
                url : "user/getUserList",
                type : "get",
                dataType : "json",
                async:false,
                success : function (data) {
                    result= data;
                }
            })
            return result;
        }

    </script>
</head>
<body>

<%--用隐藏域存放查询表单的内容--%>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-website">
<%--从session域中取出user对象放在隐藏域中，在用js获取--%>
<input type="hidden" id="hidden-user-id" value="${user.id}">
<input type="hidden" id="hidden-user-name" value="${user.name}">
<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="saveCustomerForm">

                    <div class="form-group">
                        <label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-customerOwner" name="owner">
                            </select>
                        </div>
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName" name="name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website" name="website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone" name="phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
                        </div>
                    </div>
                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime" name="nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address" name="address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCustomerBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="editCustomerForm">

                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-customerOwner" name="owner">
                            </select>
                        </div>
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName" name="name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" name="website">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" name="phone">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe" name="description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime" readonly name="nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address" name="address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="editCustomerBtn">更新</button>
            </div>
        </div>
    </div>
</div>




<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="searchForm">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" name="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" name="owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" name="phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" name="website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchCustomerListBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" id="createWindow"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" data-toggle="modal" id="editWindow"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="inputBoxs" /></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="customerBody">
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;" >
            <div id="customerPage">
            </div>
        </div>


    </div>

</div>
</body>
</html>