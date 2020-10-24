
$(function(){

    /*页面加载后分页查询*/
    pageList(1,2);
    /*点击查询按钮分页查询*/
    $("#searchActivityListBtn").click(function () {
        $("#hidden-name").val($("#search-name").val());
        $("#hidden-owner").val($("#search-owner").val());
        $("#hidden-startDate").val($("#search-startDate").val());
        $("#hidden-endDate").val($("#search-endDate").val());
        pageList(1,2);
    })

    /*点击创建按钮，查询用户列表*/
    $("#createWindow").click(function () {
        /*获取到用户下拉框的长度，如果有值了就不在去数据库查询了*/
        let length = $("#create-marketActivityOwner").children().length;
        //console.log($("#create-marketActivityOwner").children());
        if(length==0){
            let data = getUserList();
            //console.log(data);
            $.each(data ,function(i,user){
                $("#create-marketActivityOwner").append("<option value="+user.id+">"+user.name+"</option>");
            })
        }
        /*给id为create-marketActivityOwner的select标签添加value属性值，从session中取出
                              默认和从查询到的user列表中的user id作比较，设置为默认option
                          */
        /*
        JS文件不可以读取Session域内的值,
        Session是会话周期域, 是服务端上同一个客户端一次会话请求的容器.
        JS是运行在浏览器上的, 无法直接访问session.
         */
        let userId = $('#hidden-user-id').val();
        //console.log(userId);
        $("#create-marketActivityOwner").val(userId);
        //打开创建的模块窗口
        $("#createActivityModal").modal("show");
    })

    /*添加时间日期插件*/
    $(".time").datetimepicker({
        minView : "month",
        language : "zh-CN",
        format : "yyyy-mm-dd",
        autoclose : true,
        todayBtn : true,
        pickerPosition : "bottom-left"
    });


    /*
    saveActivityForm
    saveActivityBtn
    绑定保存按钮的activity保存事件，发送ajax提交form表单，插入activity
    * */
    $("#saveActivityBtn").click(function () {
        let form = $("#saveActivityForm").serialize();
        form = form.replaceAll("+","");
        //console.log(form);
        $.ajax({
            url : "workbench/activity/saveActivity",
            type : "post",
            data : form,
            dataType : "json",
            contentType : "application/x-www-form-urlencoded",
            success : function (data) {
                if(data){
                    $("#createActivityModal").modal("hide");
                    pageList(1,2);
                    $("#saveActivityForm")[0].reset();
                }else{
                    alert("服务器异常，请稍后重新操作");
                    //$("#createActivityModal").modal("hide");
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
            let length = $("#edit-marketActivityOwner").children().length;
            //console.log($("#edit-marketActivityOwner"));
            if(length==0){
                let data = getUserList();
                //console.log(data);
                $.each(data ,function(i,user){
                    $("#edit-marketActivityOwner").append("<option value="+user.id+">"+user.name+"</option>");
                })
            }
            let id = $(inputName).val();
            $.ajax({
                url : "workbench/activity/getActivityById",
                type : "get",
                data : {
                    "id" : id
                },
                dataType : "json",
                success : function (data) {
                    //console.log(data);
                    $("#edit-marketActivityName").val(data.name);
                    $("#edit-startTime").val(data.startDate);
                    $("#edit-endTime").val(data.endDate);
                    $("#edit-cost").val(data.cost);
                    $("#edit-describe").html(data.description);
                    $("#edit-marketActivityOwner").val(data.owner);
                }
            })
            $("#editActivityModal").modal("show");
        }
    })


    /*绑定更新按钮*/
    $("#editActivityBtn").click(function () {
        $.ajax({
            url : "workbench/activity/editActivity",
            type : "post",
            data : {
                "id" : $("input[class=inputName]:checked").val(),
                "name" :      $("#edit-marketActivityName").val(),
                "owner" :     $("#edit-marketActivityOwner").val(),
                "startDate" : $("#edit-startTime").val(),
                "endDate" :   $("#edit-endTime").val(),
                "cost" :      $("#edit-cost").val(),
                "description":$("#edit-describe").val(),
            },
            dataType : "json",
            contentType : "application/x-www-form-urlencoded",
            success : function (data) {
                if(data.flag){
                    alert("修改成功");
                    $("#editActivityModal").modal("hide");
                    pageList(1,2);
                }else{
                    alert("服务器异常，请稍后重新操作");
                    //$("#editActivityModal").modal("hide");
                }
            }
        })
    })
    // $("editActivityBtn").click(function () {
    //     let form = $("#editActivityForm").serialize();
    //     form = form.replaceAll("+","");
    //     console.log(form);
    //     alert(11);

    // })

    /*绑定删除按钮*/
    $("#deleteBtn").click(function () {
        if(confirm("确定删除选择的活动吗")){
        /*获取到打勾的复选框的jQuery对象*/
        let inputName = $("input[class=inputName]:checked");
        let ids = "";
        if (inputName.length>0){
            for (let i = 0; i <inputName.length; i++) {
                ids = $(inputName[i]).val()+ "," +ids ;
            }
            //console.log(ids);
            $.ajax({
                url : "workbench/activity/deleteActivity",
                type : "post",
                data : {
                    "ids" : ids
                },
                dataType : "json",
                success : function (data) {
                    if(data){
                        alert("删除活动成功");
                        pageList(1,2);
                    }else{
                        alert("服务器异常，请稍后重新操作");
                    }
                }
            })
        }else{
            alert("请选择要删除的活动");
        }
        }
    })
});
/*
 * 1.市场活动2.条件查询分页3.添加修改删除后分页4.点击分页插件后分页
 */
function pageList(pageNum,pageSize) {
    $("#inputBoxs").prop("checked",false);
    let form = $("#searchForm").serialize();
    let pageSize1 = pageSize;
    let pageNum1 = pageNum;

    pageSize = "pageSize="+pageSize;
    pageNum = "pageNum=" + pageNum;
    /*
     * 用”“代替serialize()方法获取到的form表单的空字符
     */
    form = form.replaceAll("+","");
    /*把pageSize和pageNum拼接到form里面*/
    form = form + "&" +pageNum + "&" +pageSize;
    //console.log(pageNum);
    //console.log(pageSize);
    //console.log(form);
    $.ajax({
        url : "workbench/activity/getActivityList",
        type : "post",
        data : form,
        //contentType : "application/x-www-form-urlencoded",
        dataType : "json",
        success : function (data) {
            /*
             * data : 两个数据一个是查询道德activity列表
             * 				一个是总条数 ：为前台分页插件计算总页数用
             */
            /*
                拼接tbody
             */
            let html = "";
            $.each(data.activityList,function (i,activity) {
                html += '<tr class="active">';
                html += '<td><input type="checkbox" class="inputName" value="'+activity.id+'" /></td>';
                html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="href = \'workbench/activity/detailActivityById?id='+activity.id+'\'">'+activity.name+'</a></td>';
                html += '<td>'+activity.owner+'</td>';
                html += '<td>'+activity.startDate+'</td>';
                html += '<td>'+activity.endDate+'</td>';
                html += '</tr>'
            })
            $("#activityBody").html(html);
            //console.log(data);

            /*计算总页数*/
            let totalPage = Math.ceil(data.totalCount/pageSize1) ;
            /*加入分页插件,调用插件带的js的方法*/
            $("#activityPage").bs_pagination({
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
    $("#activityBody").on("click",$(".inputName"),function () {
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