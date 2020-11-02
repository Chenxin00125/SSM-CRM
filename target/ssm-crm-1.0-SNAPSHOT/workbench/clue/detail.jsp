<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

			$("#openBundModal").click(function () {
				$("#bundModal").modal("show");
				$("#searchInput").on("keydown",function(e){
					if(e.keyCode === 13){
						return false;
					}
				});
			})

			$("#remark").focus(function(){
				if(cancelAndSaveBtnDefault){
					//设置remarkDiv的高度为130px
					$("#remarkDiv").css("height","130px");
					//显示
					$("#cancelAndSaveBtn").show("2000");
					cancelAndSaveBtnDefault = false;
				}
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
			$("#deleteClueBtn").click(function () {
				if (confirm("确定删除该活动吗")){
					let id = "${clue.id}"
					$.ajax({
						url : "workbench/clue/deleteClue",
						type : "post",
						data : {
							"ids" : id
						},
						dataType : "json",
						success : function (data) {
							if(data){
								alert("该活动已删除");
								location.href = "workbench/clue/index.jsp";
							}else {
								alert("服务器异常，请稍后重新操作");
							}
						}
					})
				}
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


			$("#cancelBtn").click(function(){
				//显示
				$("#cancelAndSaveBtn").hide();
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","90px");
				cancelAndSaveBtnDefault = true;
			});

			/*编辑*/
			$("#editCLueWindow").click(function () {
				let userId = "";
				$.each($("#edit-clueOwner").children(),function(i,child){
					let childValue = $(child).attr("value");
					//console.log(childValue);
					//console.log($(child).text());
					if( $(child).text() =="${clue.owner}"){
						userId = childValue;
						//console.log(userId+"${clue.owner}");
					}
				})
				$("#edit-clueOwner").val(userId);
				$("#edit-source").val("${clue.source}");
				$("#edit-state").val("${clue.state}");
				$("#edit-appellation").val("${clue.appellation}");
				$("#editClueModal").modal("show");
			})

			/*绑定更新按钮*/
			$("#editClueBtn").click(function () {
				let form = $("#editClueForm").serialize();
				form = form.replaceAll("+","");
				console.log(form);
				$.ajax({
					url : "workbench/clue/editClue",
					type : "post",
					data : form,
					dataType : "json",
					success : function (data) {
						if(data){
							alert("修改成功");
							$("#editClueModal").modal("hide");
							location.href="workbench/clue/detailClueById?id="+"${clue.id}";
						}else{
							alert("服务器异常，请稍后重新操作");
							//$("#editActivityModal").modal("hide");
						}
					}
				})
			})


			/*设置一个timeout避免页面加载过快而js找不到东西*/
			setTimeout(function () {
				//$("#edit-marketClueOwner").val("${clue.owner}");
				$.each($("#edit-clueOwner").children(),function(i,child){
					let childValue = $(child).attr("value");
					<%--if( childValue =="${activity.owner}"){--%>
					<%--	$("#afterOwner").html($(child).text());--%>
					<%--}--%>
					/*备注附上user值*/
					$("."+childValue).html($(child).text());
				})

			},200)

			/*绑定保存按钮*/
			$("#save-remark").click(function () {
				addRemark();
			})

			/*绑定全选复选框*/
			$("#inputBoxs").click(function () {
				$(".inputName").prop("checked",this.checked);
			})

			/*绑定下面的复选框*/
			/*动态的标签click方法触发不了事件，用on方法代替*/
			$("#searchActivityBody").on("click",$(".inputName"),function () {
				let length = $("input[class=inputName]:checked").length;
				$("#inputBoxs").prop("checked",$(".inputName").length==length);
			})

		});

		/*添加备注*/
		function addRemark(){

			let noteContent = $.trim($("#remark").val());
			let clueId = "${clue.id}";
			let createBy = "${sessionScope.user.id}";
			//console.log(noteContent);
			if(noteContent==""){
				alert("请填写备注信息");
				$("#remark").focus();
			}else{
				$.ajax({
					url : "workbench/clue/addRemark",
					type : "get",
					data : {
						"noteContent" : noteContent,
						"clueId" : clueId,
						"createBy" : createBy
					},
					dataType : "json",
					success : function (data) {
						if(data.flag){
							let remark = data.clueRemark;
							let html = "";
							$("#remark").val("添加备注成功");
							let time = remark.editFlag==1?remark.editTime:remark.createTime;

							html += '<div class="remarkDiv" id="'+remark.id+'div" style="height: 60px;">';
							html += '<img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">';
							html += '<div style="position: relative; top: -40px; left: 40px;" >';
							html += '<h5 id="'+remark.id+'">'+remark.noteContent+'</h5>';
							html += '<font color="gray">线索</font> <font color="gray">-</font> <b>'+"${clue.fullname}${clue.appellation}"+'-'+"${clue.company}"+'</b>&nbsp;&nbsp;&nbsp;';
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
						url : "workbench/clue/editRemark",
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
					url : "workbench/clue/deleteRemark",
					type : "post",
					data : {
						"id" : id
					},
					dataType : "json",
					success : function (data) {
						if(data){
							$("#"+id+"div").remove();
						}else{
							alert("系统繁忙，请稍后重试");
						}
					}
				})
			}
		}

		/*解除关联*/
		function freeRelation(id) {
		    /*id为关联中间表的id*/
			if(confirm("确定解除该关联")){
				$.ajax({
					url : "workbench/clue/freeRelation",
					type : "post",
					data : {
						id : id
					},
					dataType : "json",
					success : function (data) {
						if(data){
							$("#"+id+"tr").remove();
							alert("关联已解除");
						}else{
							alert("系统繁忙，请稍后重试");
						}
					}
				})
			}
		}

		/*let timer = null;
		function searchChange() {
		    /!*防抖*!/
		    clearTimeout(timer);
            timer = setTimeout(function () {
                console.log($("#searchInput").val());
            },2000)
                //alert(1);
        }*/

		function searchChange() {
			let name = $("#searchInput").val();
			let clueId = "${clue.id}";
			$.ajax({
				url : "workbench/clue/getSearchActivity",
				type : "post",
				data : {
					name : name,
					clueId : clueId
				},
				dataType : "json",
				success : function (data) {
					//console.log(data);
					if (data.length<1){
						alert("查询无结果");
					}else{
						let html = "";
						$.each(data,function (i,activity) {
							html += '<tr id="'+activity.id+'tr">';
							html += '<td><input class="inputName" value="'+activity.id+'" type="checkbox"/></td> ';
							html += '<td>'+activity.name+'</td>';
							html += '<td>'+activity.startDate+'</td> ';
							html += '<td>'+activity.endDate+'</td>';
							html += '<td>'+activity.owner+'</td>';
							html += '</tr>';
						})
						$("#searchActivityBody").html(html);
					}
				}
			})
		}

		function relation() {
			let  ids = $("input[class=inputName]:checked");
			let activityId = "";
			let length = $(ids).length;
			if(length>0){
				if(length>1){
					$.each(ids,function (i,id) {
						activityId = $(id).val() + "," + activityId  ;
					})
				}else{
					activityId = $(ids).val();
				}
				//console.log(activityId);
				$.ajax({
					url : "workbench/clue/relation",
					type : "post",
					data : {
						activityId : activityId,
						clueId : "${clue.id}"
					},
					dataType : "json",
					success : function (data) {
						if(data.flag){
							alert("关联成功");
							$("#bundModal").modal("hide");
                            $("#activityBody").html("");
							let html = "";
							$.each(data.activityList,function (i,activity) {
								html += '<tr id="'+activity.id+'tr">';
								html += '<td>'+activity.name+'</td>';
								html += '<td>'+activity.startDate+'</td>';
								html += '<td>'+activity.endDate+'</td>';
								html += '<td>'+activity.owner+'</td>';
								html += '<td><a href="javascript:void(0)"  style="text-decoration: none;" onclick="freeRelation(\''+activity.id+'\')"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
								html += '</tr>';
							})
							$("#activityBody").html(html);
							/*绑定全选复选框*/
							$("#inputBoxs").prop("checked",false);
							$.each(ids,function (i,id) {
								$("#"+$(id).val()+"tr").remove();
							})
						}else{
							alert("系统繁忙，请稍后重试");
						}
					}
				})
			}else{
				alert("请选择要关联的市场活动");
			}
		}

	</script>

</head>
<body>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">关联市场活动</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input type="text" onchange="searchChange()" id="searchInput" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td><input type="checkbox" id="inputBoxs"/></td>
						<td>名称</td>
						<td>开始日期</td>
						<td>结束日期</td>
						<td>所有者</td>
						<td></td>
					</tr>
					</thead>
					<tbody id="searchActivityBody">
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-primary" onclick="relation()">关联</button>
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
					<input type="hidden" name="id" id="edit-id" value="${clue.id}">
					<div class="form-group">
						<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-clueOwner" name="owner" >
								<c:forEach var="user" items="${userList}" step="1" end="${userList.size()}" begin="0">
									<option id="${user.id}" value="${user.id}">${user.name}</option>
								</c:forEach>
							</select>
						</div>
						<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-company" name="company" value="${clue.company}">
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
							<input type="text" class="form-control" id="edit-fullname" name="fullname" value="${clue.fullname}">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-job" class="col-sm-2 control-label">职位</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-job" name="job" value="${clue.job}">
						</div>
						<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-email" name="email" value="${clue.email}">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-phone" name="phone" value="${clue.phone}">
						</div>
						<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-website" name="website" value="${clue.website}">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-mphone" name="mphone" value="${clue.mphone}">
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
							<textarea class="form-control" rows="3" id="edit-description" name="description">${clue.description}</textarea>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

					<div style="position: relative;top: 15px;">
						<div class="form-group">
							<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary">${clue.contactSummary}</textarea>
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
								<textarea class="form-control" rows="1" id="edit-address" name="address">${clue.address}</textarea>
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

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
	<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
	<div class="page-header">
		<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
	</div>
	<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
		<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?clueId=${clue.id}&name=${clue.fullname}&appellation=${clue.appellation}&company=${clue.company}&owner=${clue.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
		<button type="button" class="btn btn-default" data-toggle="modal" id="editCLueWindow"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		<button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
	</div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
	<div style="position: relative; left: 40px; height: 30px;">
		<div style="width: 300px; color: gray;">名称</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 10px;">
		<div style="width: 300px; color: gray;">公司</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 20px;">
		<div style="width: 300px; color: gray;">邮箱</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 30px;">
		<div style="width: 300px; color: gray;">公司网站</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 40px;">
		<div style="width: 300px; color: gray;">线索状态</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 50px;">
		<div style="width: 300px; color: gray;">创建者</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 60px;">
		<div style="width: 300px; color: gray;">修改者</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 70px;">
		<div style="width: 300px; color: gray;">描述</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>
				${clue.description}
			</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 80px;">
		<div style="width: 300px; color: gray;">联系纪要</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>
				${clue.contactSummary}
			</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 90px;">
		<div style="width: 300px; color: gray;">下次联系时间</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 100px;">
		<div style="width: 300px; color: gray;">详细地址</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>
				${clue.address}
			</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;" id="remarkBody">
	<div class="page-header" id="remarkAfter">
		<h4>备注</h4>
	</div>
	<c:forEach begin="0" end="${remarkList.size()}" step="1" items="${remarkList}" var="remark">
		<div class="remarkDiv" style="height: 60px;" id="${remark.id}div">
			<img title="zhangsan" src="static/images/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5 id="${remark.id}">${remark.noteContent}</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b>&nbsp;&nbsp;&nbsp;
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

<!-- 市场活动 -->
<div>
	<div style="position: relative; top: 60px; left: 40px;">
		<div class="page-header">
			<h4>市场活动</h4>
		</div>
		<div style="position: relative;top: 0px;">
			<table class="table table-hover" style="width: 900px;">
				<thead>
				<tr style="color: #B3B3B3;">
					<td>名称</td>
					<td>开始日期</td>
					<td>结束日期</td>
					<td>所有者</td>
					<td></td>
				</tr>
				</thead>
				<tbody id="activityBody">
				<c:forEach begin="0" end="${activityList.size()}" step="1" items="${activityList}" var="activity">
					<tr id="${activity.id}tr">
						<td>${activity.name}</td>
						<td>${activity.startDate}</td>
						<td>${activity.endDate}</td>
						<td>${activity.owner}</td>
						<td><a href="javascript:void(0);"  style="text-decoration: none;" onclick="freeRelation('${activity.id}')"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>

		<div>
			<a href="javascript:void(0)" data-toggle="modal" id="openBundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
		</div>
	</div>
</div>


<div style="height: 200px;"></div>
</body>
</html>