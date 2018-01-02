<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Jar包管理系统</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/favicon.ico" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/themes/icon.css">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">

	function openTab(url, title, icon){
		if($("#tab").tabs("exists",title))
			$("#tab").tabs("select",title);
		else{
			var content = "<iframe frameborder=0 scrolling='auto' src='" + url +".jsp' style='width:100%;height:100%'></iframe>";
			$("#tab").tabs("add",{
				content:content,
				iconCls:icon,
				closable:true,
				title:title
			});
		}
	}
	
	function modifyPassword(){
		$("#dlg").dialog("open");
	}
	
	var validate = false;
	
	function md5(password){
		if(password == '')
			return;
		$.ajax({
			url:'../manage/admin/valid',
			method:'post',
			data:{
				username:"${currentUser.userName}",
				password:password
			},
			dataType:"json",
			success:function(r){
				validate = r.success;
			}
		});
	}
	
	function save(){
		$("#fm").form("submit",{
			url:'../manage/admin/${currentUser.id}',
			onSubmit:function(){
				if($('[name=old]').val() == ''){
					$.messager.alert("提示",'原密码不能为空','info');
					return false;
				}
				if($('[name=password]').val() == ''){
					$.messager.alert("提示",'新密码不能为空','info');
					return false;
				}
				if($('[name=password2]').val() == ''){
					$.messager.alert("提示",'确认密码不能为空','info');
					return false;
				}
				if($('[name=password2]').val() != $('[name=password]').val()){
					$.messager.alert("提示",'确认密码与新密码不同，请重新填写','info');
					return false;
				}
				if(validate == false){
					$.messager.alert("提示",'原密码填写错误，请重新填写','error');
					$("#fm").form("clear");
					$("#userName").textbox("setValue","${currentUser.userName}");
					return false;
				}
			},
			success:function(r){
				var r = JSON.parse(r);
				if(r.success){
					$.messager.confirm("提示","密码已成功修改，请重新登录",function(r){
						$.get("../manage/admin/logout",function(r){
							location = '../login.jsp';
						});
					});
				}else
					$.messager.alert("提示","密码修改失败，请你及时修复");
			}
		});
	}
	
	function cancel(){
		$("#dlg").dialog("close");
	}
	
	function logout(){
		$.messager.confirm("提示","确定退出？",function(r){
			if(r){
				// $.get("../manage/admin/logout");
				$.get("../manage/admin/logout",function(r){
					window.location = '../login.jsp';
				});
			}
		});
	}
	
	function getCurrentDateTime(){
		 var date=new Date();
		 var year=date.getFullYear();
		 var month=date.getMonth()+1;
		 var day=date.getDate();
		 var hours=date.getHours();
		 var minutes=date.getMinutes();
		 var seconds=date.getSeconds();
		 return year+"-"+formatZero(month)+"-"+formatZero(day)+" "+formatZero(hours)+":"+formatZero(minutes)+":"+formatZero(seconds);
	 }

	function getCurrentDate(){
		 var date=new Date();
		 var year=date.getFullYear();
		 var month=date.getMonth()+1;
		 var day=date.getDate();
		 return year+"-"+formatZero(month)+"-"+formatZero(day);
	}


	function formatZero(n){
		if (n < 10)
			n = "0" + n;
		return n;
	}
	
	window.setInterval(show,1000);
	
	function show(){
		$("#time").text(getCurrentDateTime);
	}
</script>
</head>
<body class="easyui-layout">
	<div region="north" style="height:80px;background-color:  #e0edef">
		<table style="padding-top: 40px">
			<tr>
				<td width="400px"></td>
				<td><span style="font-size: 20px">欢迎：[${currentUser.userName }]</span></td>
				<td style="padding-left: 200px">现在时间：<span id="time" style="color: red;font-size: 25px;"></span></td>
			</tr>
		</table>
	</div>
	<div region="center" >
		<div class="easyui-tabs" fit="true" border="false" id="tab">
			<div title="首页" data-options="iconCls:'icon-home'">
				<div align="center" style="padding-top: 100px;"><font color="red" size="10">欢迎使用</font></div>
			</div>
		</div>
	</div>
	<div region="west" style="width: 200px;" title="导航菜单" split="true">
		<div class="easyui-accordion"  data-options="fit:true,overflow:'auto',border:false">
			<div title="Jar包管理" data-options="selected:true,iconCls:'icon-item'" style="padding: 10px">
				<a href="javascript:openTab('jarManage','Jar管理','icon-jar')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-jar'" style="width: 150px">Jar包管理</a>
			</div>
			<div title="系统管理" data-options="iconCls:'icon-item'" style="padding:10px">
				<a href="javascript:modifyPassword()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-password'" style="width: 150px;">修改密码</a>
				<a href="javascript:logout()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-exit'" style="width: 150px;">安全退出</a>
			</div>
		</div>
	</div>
	<div region="south" align="center" >
		<a href="http://www.miitbeian.gov.cn">皖ICP备17026886号</a>
		Copyright © 2017-2018 thereisno.fun 版权所有
	</div>
	<div class="easyui-dialog" id="dlg" modal="true" iconCls="icon-password" title="修改密码" closed="true" closable="true" style="width:380px;height:254px;padding: 25px">
		<form id="fm" method="post">
			<%-- <table>
				<tr>
					<td>用户名：</td>
					<td><input id="userName" value="${currentUser.userName }" readonly="readonly"></td>
				</tr>
				<tr>
					<td>原密码：</td>
					<td><input type="password" name="old" onblur="md5(this.value)"></td>
				</tr>
				<tr>
					<td>新密码：</td>
					<td><input type="password" name="password"></td>
				</tr>
				<tr>
					<td>确认新密码：</td>
					<td><input type="password" name="password2"></td>
				</tr>
			</table> --%>
			<div style="margin-bottom:5px;display: inline-block;">
	            <input id="userName" class="easyui-textbox" value="${currentUser.userName }" readonly="readonly" style="width:260px;height: 25px; " data-options="labelWidth:82,label:'用户名:'">
	        </div>
	        <div style="margin-bottom:5px;display: inline-block;">
	            <input id="old" class="easyui-passwordbox" name="old" style="width:260px;height: 25px;" data-options="labelWidth:82,label:'原密码:',prompt:'请先确认你的密码',onChange:function(){
	            																																								md5(this.value);
	            																																							}">
	        </div>
	        <div style="margin-bottom:5px;display: inline-block;">
	            <input class="easyui-passwordbox" name="password" style="width:260px;height: 25px;" data-options="labelWidth:82,label:'新密码:',prompt:'请输入新密码'">
	        </div>
	        <div style="margin-bottom:5px;display: inline-block;">
	            <input class="easyui-passwordbox" name="password2" style="width:260px;height: 25px;" data-options="labelWidth:82,label:'确认新密码:',prompt:'请确认新密码'">
	        </div>
		</form>
		<div style="float: right;margin-top: 15px">
			<a href="javascript:save()" class="easyui-linkbutton" iconCls="icon-ok" >保存</a>
			<a href="javascript:cancel()" class="easyui-linkbutton" iconCls="icon-cancel" >取消</a>
		</div>
	</div>
</body>
</html>