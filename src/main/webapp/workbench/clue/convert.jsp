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
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<script type="text/javascript">
		$(function(){
			$("#isCreateTransaction").click(function(){
				if(this.checked){
					$("#create-transaction2").show(200);
					$("#flagId").val("1");
					$("#searchInput").on("keydown",function(e){
						if(e.keyCode === 13){
							return false;
						}
					});
				}else{
                    $("#flagId").val("0");
					$("#create-transaction2").hide(200);
				}
			});

			/*添加时间日期插件*/
			$(".time").datetimepicker({
				minView : "month",
				language : "zh-CN",
				format : "yyyy-mm-dd",
				autoclose : true,
				todayBtn : true,
				pickerPosition : "bottom-left"
			});

			$("#tranBtn").click(function () {
			    let form = $("#tradeForm").serialize();
			    form = form.replaceAll("+","");
			    let clueId = "clueId=" + "${param.clueId}";
				form = form + "&" +clueId;
                    $.ajax({
                        url : "workbench/clue/tran",
                        type : "post",
                        data : form,
                        dataType : "json",
                        success : function (data) {
                            if(data){
								alert("转换成功");
								location.href="workbench/clue/index.jsp";
							}else{
								alert("服务器繁忙，请稍后重新操作");
							}
                        }
                    })
			})

			$("#openWindow").click(function () {
				$.ajax({
					url : "workbench/clue/getRelationActivity",
					type : "post",
					data : {clueId : "${param.clueId}"},
					dataType : "json",
					success : function (data) {
						let html = "";
						$.each(data,function (i,activity) {
							html += '<tr >';
							html += '<td><input class="inputName" value="'+activity.id+'" type="radio" name="activity"/></td> ';
							html += '<td id="'+activity.id+'">'+activity.name+'</td>';
							html += '<td>'+activity.startDate+'</td> ';
							html += '<td>'+activity.endDate+'</td>';
							html += '<td>'+activity.owner+'</td>';
							html += '</tr>';
						})
						$("#searchActivityBody").html(html);
					}
				})

				$("#searchActivityModal").modal("show");

			})
		});

		function searchChange() {
			let name = $("#searchInput").val();
			let clueId = "${param.clueId}";
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
							html += '<tr >';
							html += '<td><input class="inputName" value="'+activity.id+'" type="radio" name="activity"/></td> ';
							html += '<td id="'+activity.id+'">'+activity.name+'</td>';
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


		function guanlian() {
		    let id = $("input[name=activity]:checked").val();
		    //console.log(id);
            $("#activityId").val(id);
            $("#activity").val($("#"+id).html());
            $("#searchActivityModal").modal("hide");
        }

	</script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog" >
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">搜索市场活动</h4>
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
						<td></td>
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
				<button type="button" class="btn btn-primary" onclick="guanlian()">关联</button>
			</div>
		</div>
	</div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
	<h4>转换线索 <small>${param.name}${param.appellation}-${param.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
	新建客户：${param.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
	新建联系人：${param.name}${param.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
	<input type="checkbox" id="isCreateTransaction"/>
	为客户创建交易
</div>
<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

	<form id="tradeForm">
        <input type="hidden" name="flagId" id="flagId" value="0">
		<div class="form-group" style="width: 400px; position: relative; left: 20px;">
			<label for="amountOfMoney">金额</label>
			<input type="text" class="form-control" id="amountOfMoney" name="money">
		</div>
		<div class="form-group" style="width: 400px;position: relative; left: 20px;">
			<label for="tradeName">交易名称</label>
			<input type="text" class="form-control" name="name" id="tradeName" value="${param.company}-">
		</div>
		<div class="form-group" style="width: 400px;position: relative; left: 20px;">
			<label for="expectedClosingDate">预计成交日期</label>
			<input type="text" class="form-control time" name="expectedDate" id="expectedClosingDate">
		</div>
		<div class="form-group" style="width: 400px;position: relative; left: 20px;">
			<label for="stage">阶段</label>
			<select id="stage"  class="form-control" name="stage">
				<c:forEach var="stage" items="${applicationScope.stage}" step="1" end="${applicationScope.stage.size()}" begin="0">
					<option id="${stage.id}"  value="${stage.value}">${stage.text}</option>
				</c:forEach>
			</select>
		</div>
		<div class="form-group" style="width: 400px;position: relative; left: 20px;">
			<label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0)" data-toggle="modal" id="openWindow" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			<input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
			<input type="hidden" name="activityId" id="activityId">
		</div>
	</form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
	记录的所有者：<br>
	<b>${param.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
	<input class="btn btn-primary" type="button" value="转换" id="tranBtn" >
	&nbsp;&nbsp;&nbsp;&nbsp;
	<a href ="workbench/clue/detailClueById?id=${param.clueId}"><input class="btn btn-default" type="button" value="返回"></a>
</div>
</body>
</html>