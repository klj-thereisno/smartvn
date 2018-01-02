<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="col-lg-4">
	<div class="data_list">
		<div class="data_list_title">
			<img src="${pageContext.request.contextPath}/static/images/icon_hot.png"/>
			热门排行
	    </div>
	    <div class="datas search">
		  <c:forEach var="jar" items="${topJar }">
			  <a href="${pageContext.request.contextPath }/jar/${jar.id }" target="_blank" title="${jar.name }">${jar.name }<small>(${jar.jarSize })</small></a>
		  </c:forEach>
		</div>
	</div>
</div>
