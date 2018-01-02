<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Jar包系统-登录界面</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/themes/icon.css">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">

	$(function(){
		$('#pass').textbox('textbox').keydown(function (e) {
		    if (e.keyCode == 13) {
		    	submitForm();
		    }
		});
	});

	function submitForm(){
		$("#fm").form("submit",{
			onSubmit:function(){
				// var flag = $(this).form("enableValidation").form("validate");
				if($("[name=userName]").val().trim() == ""){
					$.messager.alert("提示","请填写用户名","warning");
					$("[name=userName]").focus();
					return false;
				}
				if($("[name=password]").val().trim() == ""){
					$.messager.alert("提示","请填写密码","warning");
					$("[name=password]").focus();
					return false;
				}
			},
			success:function(r){
				var r = JSON.parse(r);
				if(r.success)
					window.location.href="admin/main.jsp";
				else
					$.messager.alert("系统提示",r.errMsg,"error");
			}
		});
	}
</script>
</head>
<body>
<div style="position: absolute;width: 100%;height: 100%;z-index: -1;left: 0;top: 0">
	<img src="${pageContext.request.contextPath}/static/images/bg.jpg" width="100%" height="100%" style="left: 0;top: 0;">
</div>
<div class="easyui-window" title="登录" data-options="modal:true,closable:false,collapsible:false,
													minimizable:false,maximizable:false,
													draggable:false,resizable:false,
													border:'thin',cls:'c5'" 
													style="width: 400px;height: 280px;padding: 10px">
	<form id="fm" action="manage/login" method="post" data-options="novalidate:true">
		<div style="margin-top:30px">
            <input name="userName" class="easyui-textbox" data-options="label:'username:',labelWidth:68" prompt="Username" iconWidth="28" style="width:100%;height:34px;padding:10px;">
        </div>
        <div style="margin-top:30px">
            <input name="password" id="pass" data-options="label:'password:',labelWidth:68" class="easyui-passwordbox" prompt="Password" iconWidth="28" style="width:100%;height:34px;padding:10px" >
        </div>
    </form>
    <div id="viewer"></div>
 	<div style="text-align:center;padding:5px 0;margin-top: 20px">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()" style="width:80px">Submit</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#fm').form('clear')" style="width:80px;margin-left: 20px">Clear</a>
	</div>
 	
    <script type="text/javascript">
        $('#pass').passwordbox({
            inputEvents: $.extend({}, $.fn.passwordbox.defaults.inputEvents, {
                keypress: function(e){
                    var char = String.fromCharCode(e.which);
                    $('#viewer').html(char).fadeIn(200, function(){
                        $(this).fadeOut();
                    });
                }
            })
        })
    </script>
    <style>
        #viewer{
            position: absolute;
            padding: 0 56px;
            top: 120px;
            font-size: 54px;
            line-height: 40px;
        }
    </style>
</div>
</body>
</html>