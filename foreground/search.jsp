<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="col-lg-6 col-lg-offset-1">
			<div class="data_list">
				<div class="data_list_title">
					<img src="${pageContext.request.contextPath}/static/images/icon_search.png"/>
					${head }
				</div>
				<div>
				  	<c:if test="${empty jarList }">
						<div align="center" style="padding-top: 20px">不要灰心，请换个关键字试试看(注意：仅支持英文jar包名称搜索，多个关键字之间用空格隔开)</div>	  				
		  			</c:if>
					<ul style="list-style-type: none;">
						<c:if test="${not empty jarList }">
						<c:forEach var="jar" items="${jarList }">
							<li style="margin: 20px; ">
							<span class="title"><a href="../${jar.id }" target="_blank" title="${jar.id }">${jar.name }</a></span>
							</li>
						</c:forEach>
						</c:if>
					</ul>
				</div>
				<c:if test="${not empty jarList }">
			     ${pageCode }
				</c:if>
			</div>
        </div>