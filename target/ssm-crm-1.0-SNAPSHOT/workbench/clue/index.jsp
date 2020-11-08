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
			$("#searchClueBtn").click(function () {
				$("#hidden-fullname").val($("#search-fullname").val());
				$("#hidden-owner").val($("#search-owner").val());
				$("#hidden-company").val($("#search-company").val());
				$("#hidden-mphone").val($("#search-mphone").val());
				$("#hidden-source").val($("#search-source").val());
				$("#hidden-phone").val($("#search-phone").val());
				$("#hidden-state").val($("#search-state").val());
				pageList(1,2);
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


			/*点击创建按钮，查询用户列表*/
			$("#createClueBtn").click(function () {
				/*获取到用户下拉框的长度，如果有值了就不在去数据库查询了*/
				let length = $("#create-clueOwner").children().length;
				//console.log($("#create-marketActivityOwner").children());
				if(length==0){
					let data = getUserList();
					//console.log(data);
					$.each(data ,function(i,user){
						$("#create-clueOwner").append("<option value="+user.id+">"+user.name+"</option>");
					})

					$.each(data ,function(i,user){
						$("#edit-clueOwner").append("<option value="+user.id+">"+user.name+"</option>");
					})

				}
				let userId = $("#hidden-user").val();
				$("#create-clueOwner").val(userId);
				//打开创建的模块窗口
				$("#createClueModal").modal("show");

			})


			$("#saveClueBtn").click(function () {
				let form = $("#createClueForm").serialize();
				form = form.replaceAll("+","");
				console.log(form);
				$.ajax({
					url : "workbench/clue/saveClue",
					type : "post",
					data : form,
					dataType : "json",
					contentType : "application/x-www-form-urlencoded",
					success : function (data) {
						if(data){
							$("#createClueModal").modal("hide");
							$("#createClueForm")[0].reset();
							pageList(1,2);
						}else{
							alert("服务器异常，请稍后重新操作");
							$("#createClueModal").modal("hide");
						}
					}
				})
			})

            /*修改*/
            $("#editCLueWindow").click(function () {
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
                    let length = $("#edit-clueOwner").children().length;
                    if(length==0){
                        let data = getUserList();
                        console.log(data);
                        $.each(data ,function(i,user){
                            $("#edit-clueOwner").append("<option value="+user.id+">"+user.name+"</option>");
                        })
                        $.each(data ,function(i,user){
                            $("#create-clueOwner").append("<option value="+user.id+">"+user.name+"</option>");
                        })
                    }
                    let id = $(inputName).val();
                    $.ajax({
                        url : "workbench/clue/getClueById",
                        type : "get",
                        data : {
                            "id" : id
                        },
                        dataType : "json",
                        success : function (data) {
                            console.log(data);
                            $("#edit-clueOwner").val(data.owner);
                            $("#edit-appellation").val(data.appellation);
                            $("#edit-job").val(data.job);
                            $("#edit-phone").val(data.phone);
                            $("#edit-mphone").val(data.mphone);
                            $("#edit-source").val(data.source);
                            $("#edit-description").val(data.description);
                            $("#edit-contactSummary").val(data.contactSummary);
                            $("#edit-nextContactTime").val(data.nextContactTime);
                            $("#edit-address").val(data.address);
                            $("#edit-fullname").val(data.fullname);
                            $("#edit-email").val(data.email);
                            $("#edit-website").val(data.website);
                            $("#edit-company").val(data.company);
                            $("#edit-state").val(data.state);
                            $("#edit-id").val(data.id);
                        }
                    })
                    $("#editClueModal").modal("show");
                }
            })


            /*绑定更新按钮*/
            $("#editClueBtn").click(function () {
                let form = $("#editClueForm").serialize();
                form = form.replaceAll("+","");
                $.ajax({
                    url : "workbench/clue/editClue",
                    type : "post",
                    data : form,
                    dataType : "json",
                    contentType : "application/x-www-form-urlencoded",
                    success : function (data) {
                        if(data){
                        	alert("修改成功");
                            $("#editClueModal").modal("hide");
                            pageList(1,2);
                        }else{
                            alert("服务器异常，请稍后重新操作");
                            //$("#editClueModal").modal("hide");
                        }
                    }
                })
            })

			/*绑定删除按钮*/
			$("#deleteClueBtn").click(function () {
				if(confirm("确定删除选择的线索吗")){
					/*获取到打勾的复选框的jQuery对象*/
					let inputName = $("input[class=inputName]:checked");
					let ids = "";
					if (inputName.length>0){
						for (let i = 0; i <inputName.length; i++) {
							ids = $(inputName[i]).val()+ "," +ids ;
						}
						//console.log(ids);
						$.ajax({
							url : "workbench/clue/deleteClue",
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
		function pageList(pageNum,pageSize) {
			$("#inputBoxs").prop("checked",false);
			let form = $("#searchForm").serialize();
			let pageSize1 = pageSize;
			let pageNum1 = pageNum;

			pageSize = "pageSize=" + pageSize;
			pageNum = "pageNum=" + pageNum;
			/*
             * 用”“代替serialize()方法获取到的form表单的空字符
             */
			form = form.replaceAll("+", "");
			/*把pageSize和pageNum拼接到form里面*/
			form = form + "&" + pageNum + "&" + pageSize;
			$.ajax({
				url: "workbench/clue/getClueList",
				type: "post",
				data: form,
				contentType: "application/x-www-form-urlencoded",
				dataType: "json",
				success: function (data) {
					let html = "";
					$.each(data.clueList, function (i, clue) {
						html += '<tr class="clue">';
						html += '<td><input type="checkbox"  class="inputName" value="' + clue.id + '" /></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="href = \'workbench/clue/detailClueById?id=' + clue.id + '\'">' + clue.fullname + '</a></td>';
						html += '<td>' + clue.company + '</td>';
						html += '<td>' + clue.phone + '</td>';
						html += '<td>' + clue.mphone + '</td>';
						html += '<td>' + clue.source + '</td>';
						html += '<td>' + clue.owner + '</td>';
						html += '<td>' + clue.state + '</td>';
						html += '</tr>'
					})
					$("#clueBody").html(html);
					//console.log(data);

					/*计算总页数*/
					let totalPage = Math.ceil(data.totalCount / pageSize1);
					/*加入分页插件,调用插件带的js的方法*/
					$("#cluePage").bs_pagination({
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
						onChangePage: function (event, data) {
							$("#search-fullname").val($("#hidden-fullname").val());
							$("#search-owner").val($("#hidden-owner").val());
							$("#search-company").val($("#hidden-company").val());
							$("#search-mphone").val($("#hidden-mphone").val());
							$("#search-source").val($("#hidden-source").val());
							$("#search-phone").val($("#hidden-phone").val());
							$("#search-state").val($("#hidden-state").val());
							pageList(data.currentPage, data.rowsPerPage);
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
			$("#clueBody").on("click",$(".inputName"),function () {
				let length = $("input[class=inputName]:checked").length;
				$("#inputBoxs").prop("checked",$(".inputName").length==length);
			})

		}
	</script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">创建线索</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form" id="createClueForm">

					<div class="form-group">
						<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-clueOwner" name="owner">
							</select>
						</div>
						<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-company" name="company">
						</div>
					</div>

					<div class="form-group">
						<label for="create-call" class="col-sm-2 control-label">称呼</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-call" name="appellation">
								<c:forEach var="appellation" items="${applicationScope.appellation}" step="1" end="${applicationScope.appellation.size()}" begin="0">
									<option id="${appellation.id}" value="${appellation.value}">${appellation.text}</option>
								</c:forEach>
							</select>
						</div>
						<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-surname" name="fullname">
						</div>
					</div>

					<div class="form-group">
						<label for="create-job" class="col-sm-2 control-label">职位</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-job" name="job">
						</div>
						<label for="create-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-email" name="email">
						</div>
					</div>

					<div class="form-group">
						<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-phone" name="phone">
						</div>
						<label for="create-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-website" name="website">
						</div>
					</div>

					<div class="form-group">
						<label for="create-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-mphone" name="mphone">
						</div>
						<label for="create-status" class="col-sm-2 control-label">线索状态</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-status" name="state">
								<c:forEach var="clueState" items="${applicationScope.clueState}" step="1" end="${applicationScope.clueState.size()}" begin="0">
									<option id="${clueState.id}"  value="${clueState.value}">${clueState.text}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="create-source" class="col-sm-2 control-label">线索来源</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-source" name="source">
								<c:forEach var="source" items="${applicationScope.source}" step="1" end="${applicationScope.source.size()}" begin="0">
									<option id="${source.id}"  value="${source.value}">${source.text}</option>
								</c:forEach>
							</select>
						</div>
					</div>


					<div class="form-group">
						<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
				<button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
			</div>
		</div>
	</div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">修改线索</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form" id="editClueForm">
                    <input type="hidden" name="id" id="edit-id">
					<div class="form-group">
						<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-clueOwner" name="owner">
							</select>
						</div>
						<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-company" name="company">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-appellation" name="appellation">
								<c:forEach var="appellation" items="${applicationScope.appellation}" step="1" end="${applicationScope.appellation.size()}" begin="0">
									<option id="${appellation.id}"  value="${appellation.value}">${appellation.text}</option>
								</c:forEach>
							</select>
						</div>
						<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-fullname" name="fullname">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-job" class="col-sm-2 control-label">职位</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-job" name="job">
						</div>
						<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-email" name="email">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-phone" name="phone">
						</div>
						<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-website" name="website">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-mphone" name="mphone">
						</div>
						<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-state" name="state">
								<c:forEach var="clueState" items="${applicationScope.clueState}" step="1" end="${applicationScope.clueState.size()}" begin="0">
									<option id="${clueState.id}"  value="${clueState.value}">${clueState.text}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-source" name="source">
								<c:forEach var="source" items="${applicationScope.source}" step="1" end="${applicationScope.source.size()}" begin="0">
									<option id="${source.id}"  value="${source.value}">${source.text}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-description" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit-description" name="description"></textarea>
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
								<input type="text" class="form-control time" id="edit-nextContactTime" name="nextContactTime" readonly value="${clue.nextContactTime}">
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
				<button type="button" class="btn btn-primary" id="editClueBtn">更新</button>
			</div>
		</div>
	</div>
</div>




<div>
	<div style="position: relative; left: 10px; top: -10px;">
		<div class="page-header">
			<h3>线索列表</h3>
		</div>
	</div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

	<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

		<%--查询div--%>
		<input type="hidden" id="hidden-fullname">
		<input type="hidden" id="hidden-company">
		<input type="hidden" id="hidden-phone">
		<input type="hidden" id="hidden-source">
		<input type="hidden" id="hidden-owner">
		<input type="hidden" id="hidden-mphone">
		<input type="hidden" id="hidden-state">
		<input type="hidden" id="hidden-user" value="${sessionScope.user.id}">
		<%--从session域中取出user对象放在隐藏域中，在用js获取--%>
		<input type="hidden" id="hidden-user-id" value="${user.id}">
		<input type="hidden" id="hidden-user-name" value="${user.name}">
		<div class="btn-toolbar" role="toolbar" style="height: 80px;">
			<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="searchForm">

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">名称</div>
						<input class="form-control" type="text" name="fullname" id="search-fullname">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">公司</div>
						<input class="form-control" type="text" name="company" id="search-company">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">公司座机</div>
						<input class="form-control" type="text" name="phone" id="search-phone">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">线索来源</div>
						<select class="form-control" name="source" id="search-source">
							<option></option>
							<c:forEach var="source" items="${applicationScope.source}" step="1" end="${applicationScope.source.size()}" begin="0">
								<option id="${source.id}"  value="${source.value}">${source.text}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<br>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">所有者</div>
						<input class="form-control" type="text" name="owner" id="search-owner">
					</div>
				</div>



				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">手机</div>
						<input class="form-control" type="text" name="mphone" id="search-mphone">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">线索状态</div>
						<select class="form-control" name="state" id="search-state">
							<option></option>
							<c:forEach var="clueState" items="${applicationScope.clueState}" step="1" end="${applicationScope.clueState.size()}" begin="0">
								<option id="${clueState.id}"  value="${clueState.value}">${clueState.text}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<button type="button" class="btn btn-default" id="searchClueBtn">查询</button>

			</form>
		</div>
		<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
			<div class="btn-group" style="position: relative; top: 18%;">
				<button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				<button type="button" class="btn btn-default" data-toggle="modal" id="editCLueWindow"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				<button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>


		</div>
		<div style="position: relative;top: 50px;">
			<table class="table table-hover">
				<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="inputBoxs" /></td>
					<td>名称</td>
					<td>公司</td>
					<td>公司座机</td>
					<td>手机</td>
					<td>线索来源</td>
					<td>所有者</td>
					<td>线索状态</td>
				</tr>
				</thead>
				<tbody id="clueBody">
				</tbody>
			</table>
		</div>

		<%--		分页--%>
			<div style="height: 50px; position: relative;top: 70px;">
				<%--这个div是加入分页插件的位置--%>
				<div id="cluePage">
				</div>
			</div>
	</div>

</div>
</body>
</html>