<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Jar包系统-登录界面</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/static/bootstrap-3.3.7-dist/css/bootstrap-theme.min.css">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/favicon.ico" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/smartvn.css">
<script src="${pageContext.request.contextPath}/static/bootstrap-3.3.7-dist/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<div style="float:right;" id="hub_iframe"></div>

<script type="text/javascript">
    function async_load() {
           
        i.scrolling = "no";
        i.frameborder = "0";
        i.border = "0";
        i.setAttribute("frameborder", "0", 0);
        i.width = "100px";
        i.height = "20px";
        document.getElementById("hub_iframe").appendChild(i);
    }

    if (window.addEventListener) {window.addEventListener("load", async_load, false);}
    else if (window.attachEvent) {window.attachEvent("onload", async_load);}
    else {window.onload = async_load;}
</script>

<script>
! function() {
	//封装方法，压缩之后减少文件大小
	function get_attribute(node, attr, default_value) {
		return node.getAttribute(attr) || default_value;
	}
	//封装方法，压缩之后减少文件大小
	function get_by_tagname(name) {
		return document.getElementsByTagName(name);
	}
	//获取配置参数
	function get_config_option() {
		var scripts = get_by_tagname("script"),
			script_len = scripts.length,
			script = scripts[script_len - 1]; //当前加载的script
		return {
			l: script_len, //长度，用于生成id用
			z: get_attribute(script, "zIndex", -1), //z-index
			o: get_attribute(script, "opacity", 0.5), //opacity
			c: get_attribute(script, "color", "0,0,0"), //color
			n: get_attribute(script, "count", 99) //count
		};
	}
	//设置canvas的高宽
	function set_canvas_size() {
		canvas_width = the_canvas.width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth, 
		canvas_height = the_canvas.height = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	}

	//绘制过程
	function draw_canvas() {
		context.clearRect(0, 0, canvas_width, canvas_height);
		//随机的线条和当前位置联合数组
		var e, i, d, x_dist, y_dist, dist; //临时节点
		//遍历处理每一个点
		random_lines.forEach(function(r, idx) {
			r.x += r.xa, 
			r.y += r.ya, //移动
			r.xa *= r.x > canvas_width || r.x < 0 ? -1 : 1, 
			r.ya *= r.y > canvas_height || r.y < 0 ? -1 : 1, //碰到边界，反向反弹
			context.fillRect(r.x - 0.5, r.y - 0.5, 1, 1); //绘制一个宽高为1的点
			//从下一个点开始
			for (i = idx + 1; i < all_array.length; i++) {
				e = all_array[i];
				//不是当前点
				if (null !== e.x && null !== e.y) {
						x_dist = r.x - e.x, //x轴距离 l
						y_dist = r.y - e.y, //y轴距离 n
						dist = x_dist * x_dist + y_dist * y_dist; //总距离, m
					dist < e.max && (e === current_point && dist >= e.max / 2 && (r.x -= 0.03 * x_dist, r.y -= 0.03 * y_dist), //靠近的时候加速
						d = (e.max - dist) / e.max, 
						context.beginPath(), 
						context.lineWidth = d / 2, 
						context.strokeStyle = "rgba(" + config.c + "," + (d + 0.2) + ")", 
						context.moveTo(r.x, r.y), 
						context.lineTo(e.x, e.y), 
						context.stroke());
				}
			}
		}), frame_func(draw_canvas);
	}
	//创建画布，并添加到body中
	var the_canvas = document.createElement("canvas"), //画布
		config = get_config_option(), //配置
		canvas_id = "c_n" + config.l, //canvas id
		context = the_canvas.getContext("2d"), canvas_width, canvas_height, 
		frame_func = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(func) {
			window.setTimeout(func, 1000 / 45);
		}, random = Math.random, 
		current_point = {
			x: null, //当前鼠标x
			y: null, //当前鼠标y
			max: 20000
		},
		all_array;
	the_canvas.id = canvas_id;
	the_canvas.style.cssText = "position:fixed;top:0;left:0;z-index:" + config.z + ";opacity:" + config.o;
	get_by_tagname("body")[0].appendChild(the_canvas);
	//初始化画布大小

	set_canvas_size(), window.onresize = set_canvas_size;
	//当时鼠标位置存储，离开的时候，释放当前位置信息
	window.onmousemove = function(e) {
		e = e || window.event, current_point.x = e.clientX, current_point.y = e.clientY;
	}, window.onmouseout = function() {
		current_point.x = null, current_point.y = null;
	};
	//随机生成config.n条线位置信息
	for (var random_lines = [], i = 0; config.n > i; i++) {
		var x = random() * canvas_width, //随机位置
			y = random() * canvas_height,
			xa = 2 * random() - 1, //随机运动方向
			ya = 2 * random() - 1;
		random_lines.push({
			x: x,
			y: y,
			xa: xa,
			ya: ya,
			max: 6000 //沾附距离
		});
	}
	all_array = random_lines.concat([current_point]);
	//0.1秒后绘制
	setTimeout(function() {
		draw_canvas();
	}, 100);
}();
</script>


<script type="text/javascript">

	$(function(){
		$("#q").keydown(function(e) {  // 给搜索文本框注册enter回车事件
		    if (e.keyCode == 13) {  
		  	  search();
		     }
		}); 
	});

	function search(){
		var q = $("#q").val();
		if(q.trim() == ''){
			alert("请输入要搜索的内容");			
			return;
		}
		window.location.href = 'jar/list/' + q;
	}
	
</script>
</head>
<body>
<div style="float:right;" class="container-fluid">
  <jsp:include page="foreground/common/head.jsp"></jsp:include>
  <div class="row" style="margin-top: 40px">
  	<div class="col-lg-4 col-lg-offset-4">
	    <div class="input-group">
	      <input id="q" type="text" class="form-control" placeholder="输入jar文件关键字进行搜索...">
	      <span class="input-group-btn">
	        <button class="btn btn-primary" type="button" onclick="search()">搜一搜</button>
	      </span>
	    </div>
  	</div>
  </div>
  <div class="row" style="text-align:center;margin-top: 8px">
  	<div class="col-lg-4 col-lg-offset-4">
	    <span><a style="color: red;" href="jar/list/spring" target="_blank" title="spring">spring</a></span>
	    <span><a style="color: red;padding:0 1px" href="jar/list/springmvc" target="_blank" title="springmvc">springmvc</a></span>
	    <span><a style="color: red;padding:0 1px" href="jar/list/maven" target="_blank" title="maven">maven</a></span>
	    <span><a style="color: red;padding:0 1px" href="jar/list/hibernate" target="_blank" title="hibernate">hibernate</a></span>
	    <span><a style="color: red;padding:0 1px" href="jar/list/bootstrap" target="_blank" title="bootstrap">bootstrap</a></span>
	    <span><a style="color: red;padding:0 1px" href="jar/list/log4j" target="_blank" title="log4j">log4j</a></span>
	    <span><a style="color: red;padding:0 1px" href="jar/list/common" target="_blank" title="common">common</a></span>
	    <span><a style="color: red;" href="jar/list/proxy" target="_blank" title="proxy">proxy</a></span>
  	</div>
  </div>
  <div class="row" style="margin-top: 10px;">
  	  <div class="col-lg-6 col-lg-offset-1">
       	<div class="data_list">
			<div class="data_list_title">
				<img src="${pageContext.request.contextPath}/static/images/icon_question.png"/>
				猜你喜欢
		    </div>
		    <div class="datas search">
			  <c:forEach var="tag" items="${tags }">
				  <a href="jar/list/${tag }" target="_blank" title="${tag }">${tag }</a>
			  </c:forEach>
			</div>
		</div>
	  </div>
	  <jsp:include page="foreground/common/slide.jsp"></jsp:include>
  </div>
</div>
<jsp:include page="foreground/common/foot.jsp"></jsp:include>
</body>
</html>