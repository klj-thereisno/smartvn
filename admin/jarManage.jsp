<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/themes/icon.css">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/favicon.ico">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.5.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
	
	function forName(val, row){
		return "<a href='../jar/" + row.id + "'>" + row.name + "</a>";
	}
	
	function forSize(val, row){
		var val = val / 1024;
		if(val >= 1024)
			return ((val / 1024).toFixed(2) + 'MB').fontcolor("red");
		return val.toFixed(2) + 'KB';
	}
	
	function forSub(val, row){
		if(row.crawlDate){
			if(val)
				return "<a href='" + row.url + val + "'>点击下载</a>";
		}else
			if(val)
				return "<a href='${pageContext.request.contextPath}" + row.url + val + "'>点击下载</a>";
		return "无";
	}
	
	var method = '';
	
	function changeDisplay(){
		var obj  = document.getElementsByName('method');
        for(var i=0;i<obj.length;i++){
            if(obj[i].checked==true){
                if(obj[i].value=='file'){
                	method = 'file';
                	$("#url").css("display","none");
                	$("#file").css("display","block");
                }else if(obj[i].value=='url'){
                	method = 'url';
                	$("#file").css("display","none");
                	$("#url").css("display","block");
                }
            }
        }
	}
	
	$(function(){
		var t = $('#s_name');
		t.textbox('textbox').bind('keydown', function(e){
			if (e.keyCode == 13){	// when press ENTER key, accept the inputed value.
				search();
			}
		});
	});
	
	function search(){
		$("#dg").datagrid("load",{
			name:$("[name=s_name]").val(),
			s_b_releaseDate:$("#s_b_releaseDate").datebox("getValue"),
			s_e_releaseDate:$("#s_e_releaseDate").datebox("getValue"),
			docSize:$("#s_doc").combobox("getValue")
		});
	}
	
	function add(){
		changeDisplay();
		$("#dlg").dialog("open").dialog("setTitle","新增jar包");
	}
	
	function save(){
		if(method == 'file'){
			var file = $("[name=jarFile]");
			if(file.val() == ''){
				$.messager.alert("提示","请选择要上传的jar文件");
				return;
			}
			if(file.val().search(/\.jar$/) == -1){
				$.messager.alert("提示","请选择jar文件");
				return;
			}
			$("[name=jarUrl]").val('');
			$("#fm").form("submit",{
				onSubmit:function(){
					
				},
				success:function(r){
					var r = JSON.parse(r);
					if(r.success){
						$.messager.alert("提示","jar文件上传成功");
						$("#dg").datagrid("reload");
					}else if(r.errMsg){
						$.messager.alert("提示", r.errMsg);
					}else
						$.messager.alert("提示","系统错误","error");
					cancel();
				},
				onLoadError:function(){
					$.messager.alert("提示","系统错误","error");
					$("#dlg").dialog("close");
				}
			});
		}else{
			var jarUrl = $("[name=jarUrl]");
			$("#fm").form("submit",{
				onSubmit:function(r){
					if(jarUrl.val().trim() == ''){
						$.messager.alert("提示","请填写url地址");
						return false;
					}
					if(jarUrl.val().search(/^http:\/\/central.maven.org\/maven2\/.*\.jar$/) == -1){
						$.messager.alert("提示","请填写正确的maven仓库url地址");
						return false;
					}
					/* var file = $("[name=jarFile]");
					file.after(file.clone().val(""));      
					file.remove();   */
					$("[name=jarFile]").val("");
				},
				success:function(r){
					var r = JSON.parse(r);
					if(r.success){
						$.messager.alert("提示","已成功抓取jar包,赶紧搜索试试，看看还发现了什么","info");
						$("#dg").datagrid("reload");
					}else if(r.errMsg){
						$.messager.alert("提示", r.errMsg);
					}else
						$.messager.alert("提示","系统错误","error");
					cancel();
				},
				onLoadError:function(){
					$.messager.alert("提示","系统错误","error");
					$("#dlg").dialog("close");
				}
			});
		}
	}
	
	function cancel(){
		$("#fm").form("reset");
		$("#dlg").dialog("close");
	}
	
	function deletes(){
		var row = $("#dg").datagrid("getSelected");
		if(!row){
			$.messager.alert("info","请选择要删除的jar file" ,"info");
			return;
		}
		$.messager.confirm("提示：数据不易，且删且珍惜","确定删除" + row.name + "？",function(r){
			if(r){
				$.ajax({
					url:'../jar/admin',
					data:{id:row.id},
					dataType:'json',
					success:function(r){
						if(r.success){
							$.messager.alert("提示","删除成功","info");
							$("#dg").datagrid("reload");
						}else
							$.messager.alert("提示","删除失败，请联系管理员");
					}
				});
			}
		});
	}
	
</script>
</head>
<body>
<table id="dg" class="easyui-datagrid" title="jar包列表" fit="true" toolbar="#tb"
	data-options="
            singleSelect: true,
            rownumbers: true,
            url:'../jar/admin/list',
            pagination:true">
    <thead data-options="frozen:true">
        <tr>
            <th data-options="field:'xx',width:300,align:'left',halign:'center',formatter:forName">jar名称</th>
            <th data-options="field:'jarSize',width:90,align:'right',halign:'center'" formatter="forSize">jar包大小</th>
        </tr>
    </thead>
    <thead>
        <tr>
            <th data-options="field:'releaseDate',width:150,align:'center'">发布时间</th>
            <th data-options="field:'crawlDate',width:150,align:'center'">抓取时间</th>
            <th data-options="field:'click',width:70,align:'center'">点击次数</th>
            <th data-options="field:'down',width:70,align:'center'">下载次数</th>
            <th data-options="field:'name',width:110,align:'center',formatter:forSub">jar</th>
            <th data-options="field:'doc',width:110,align:'center',formatter:forSub">文档</th>
            <th data-options="field:'sources',width:110,align:'center',formatter:forSub">源码</th>
            <th data-options="field:'pom',width:110,align:'center',formatter:forSub">pom</th>
        </tr>
    </thead>
</table>
<div id="tb">
	<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="add()">新增</a>
	<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'" onclick="edit()">修改</a>
	<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'" onclick="deletes()">删除</a>
	&nbsp;&nbsp;
	<br/>
			&nbsp;&nbsp;<input id="s_name" name="s_name" class="easyui-textbox" label="jarName：" data-options="labelWidth:66,prompt:'Enter a jarName...',width:400">
			&nbsp;&nbsp;&nbsp;&nbsp;<input label="发布时间：" type="text" id="s_b_releaseDate" data-options="labelWidth:65,width:220,editable:false,onChange:function(){
																																		search();
																																	}" class="easyui-datebox" size="20"/>
			&nbsp;&nbsp;<input label="到：" type="text" id="s_e_releaseDate" data-options="labelWidth:35,width:190,editable:false,onChange:function(){
																																		search();
																																	}" class="easyui-datebox" size="20" />&nbsp;&nbsp;
			<select class="easyui-combobox" id="s_doc" data-options="label:'文档：',labelWidth:42,width:150,editable:false,panelHeight:'auto',onChange:function(){
																																		search();
																																	}">
					<option value="0">请选择...</option>
					<option value="1">有文档</option>
			</select>
	<a href="javascript:search()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" >搜索</a>
</div>
<div id="dlg" resizable="true" class="easyui-dialog" buttons="#bt" iconCls="icon-save" style="width:600px;height:260px;padding: 20px" closed="true">
	<form id="fm" method="post" action="../jar/admin" enctype="multipart/form-data" >
		<!-- file method -->
		<input type="radio" name="method" value="file" checked=true onclick="changeDisplay()">upload jar file
		<!-- url method -->
		<input type="radio" name="method" value="url" onclick="changeDisplay()">paste jar url in maven
		<div id="file" style="margin-bottom:20px;padding: 20px 20px 20px 0">
            <input class="easyui-filebox" name="jarFile" data-options="label:'file：',labelWidth:45,width:300">
        </div>
        <div id="url" style="margin-bottom:20px;padding: 20px 20px 20px 0">
        	<input class="easyui-textbox" id="jarUrl" name="jarUrl" data-options="label:'URL：',labelPosition:'top',labelWidth:62,labelAlign:'left',prompt:'请输入maven上的jar包地址：',width:540">
        </div>
	</form>
</div>
<div id="bt">
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="save()">submit</a>
	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="cancel()">cancel</a>
</div>

<div id="dlg2" resizable="true" class="easyui-dialog" iconCls="icon-save" style="width:570px;height:300px;padding: 10px" closed="true">
	<form id="ff" class="easyui-form" method="post" data-options="novalidate:true">
        <div style="margin-bottom:5px;display: inline-block;">
            <input class="easyui-textbox" name="name" style="width:320px" data-options="labelWidth:62,label:'jar包名称:',required:true,prompt:'.jar$'">
            <input type="hidden" name="id">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input class="easyui-textbox" name="jarSize" style="width:200px;" data-options="labelWidth:62,label:'jar包大小:',required:true">
        </div>
        <div style="margin-bottom:5px">
            <input class="easyui-textbox" name="url" style="width:524px" data-options="labelWidth:62,label:'url:',required:true,prompt:'^http://central.maven.org/maven2/'">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input name="releaseDate" style="width:320px" class="easyui-datetimebox" data-options="labelWidth:62,label:'发布时间:',required:true,editable:false,">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input name="crawlDate" style="width:200px" class="easyui-datetimebox" data-options="labelWidth:62,label:'获取时间:',editable:false">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input name="click" style="width:320px" class="easyui-numberbox" data-options="labelWidth:62,label:'点击次数:'">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input name="down" style="width:200px;" class="easyui-numberbox" data-options="labelWidth:62,label:'下载次数:'">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input class="easyui-textbox" name="doc" style="width:320px" data-options="labelWidth:62,label:'文档:',prompt:'doc.jar$'">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input class="easyui-textbox" name="docSize" style="width:200px" data-options="labelWidth:62,label:'文档大小:'">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input class="easyui-textbox" name="sources" style="width:320px" data-options="labelWidth:62,label:'源码:',prompt:'sources.jar$'">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input class="easyui-textbox" name="sourcesSize" style="width:200px" data-options="labelWidth:62,label:'源码大小:'">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input class="easyui-textbox" name="pom" style="width:320px" data-options="labelWidth:62,label:'pom文件:',prompt:'.pom$'">
        </div>
        <div style="margin-bottom:5px;display: inline-block;">
            <input class="easyui-textbox" name="pomSize" style="width:200px" data-options="labelWidth:62,label:'pom大小:'">
        </div>
    </form>
    <div style="text-align:center;padding:5px 0">
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()" style="width:80px">Submit</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" style="width:80px">Clear</a>
    </div>
</div>
<script>

	var oriRow = new Object();
  	
	function edit(){
		var row = $("#dg").datagrid("getSelected");
		if(!row){
			$.messager.alert("提示","请选择一条要修改的数据");
			return;
		}
		oriRow = row;
		$("#dlg2").dialog("open").dialog("setTitle","编辑jar包信息");
		$("#ff").form("load",row);
	}
  
	
     function submitForm(){
         $('#ff').form('submit',{
			 url:'../jar/admin/update',        	 
             onSubmit:function(){
                 return $(this).form('enableValidation').form('validate');
             },
             success:function(r){
             	var r = JSON.parse(r);
             	if(r.success){
             		$.messager.alert("提示","jar文件属性修改成功","info");
             		$("#dlg2").dialog("close");
             		$("#dg").datagrid("reload");
             		clearForm();
             	}else{
             		$.messager.alert("提示",r.errMsg,"error");
             	}
             }
         });
     }
     
     function clearForm(){
         $('#ff').form('load', oriRow);
     }
  </script>
</body>
</html>