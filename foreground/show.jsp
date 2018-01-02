<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
	
	function down(type){
		var id = $("#id").val();
		$.ajax({
			url:'../jar',
			data:{id:id},
			success:function(r){
				window.location.href = r + type;
			}
		});
	}

</script>


<div class="col-lg-6 col-lg-offset-1">
	<div class="data_list">
		<div class="data_list_title">
			<img src="${pageContext.request.contextPath}/static/images/icon_jar.png"/>
			Jar包信息
           </div>
           ${Info }
		<c:if test="${not empty jar }">
			<div style="padding: 20px;">
				<div>
					<h2 style="display: inline;"><span class="label label-info">${jar.name }</span></h2>
					<button style="margin:10px 10px " class="btn btn-success btn-lg" onclick="down(this.value)" value="${jar.name }">我要下载</button>
				</div>
			  	<table id="info">
			  		<tr>
			  			<td><span class="label label-default">大&nbsp;&nbsp;&nbsp;&nbsp;小：</span><input id="id" type="hidden" value="${jar.id }"></td>
						<td>
							<fmt:formatNumber type="number" value="${jar.jarSize / 1024 >= 1024 ? jar.jarSize / 1024 / 1024 : jar.jarSize / 1024 }" pattern="0.00" maxFractionDigits="2"/>  
							<c:if test="${jar.jarSize / 1024 >= 1024}">MB</c:if>
							<c:if test="${jar.jarSize / 1024 < 1024}">KB</c:if>
						</td>
						<td width="20px">&nbsp;</td>
						<td><span class="label label-default">贡献人/机构：</span></td>
						<td>本站</td>
						<%-- <td>有无文档：</td>
						<td>
							<c:if test="${not empty jar.doc }">有</c:if>
							<c:if test="${empty jar.doc }">无</c:if>
						</td> --%>
					</tr>
					<tr>
						<td><span class="label label-default">访问次数：</span></td>
						<td>${jar.click}</td>
						<td width="20px">&nbsp;</td>
						<td><span class="label label-default">发布时间：</span></td>
						<td><fmt:formatDate value="${jar.releaseDate }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					</tr>
					<tr>
						<td><span class="label label-default">下载次数：</span></td>
						<td>${jar.down }</td>
						<td width="20px">&nbsp;</td>
						<td><span class="label label-default">获取时间：</span></td>
						<td><fmt:formatDate value="${jar.crawlDate }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					</tr>
				</table>
				<div>
					<c:if test="${not empty jar.doc }">
						<button style="margin:10px" class="btn btn-primary btn-lg" onclick="down(this.value)" value="${jar.doc }">文档下载</button>
					</c:if>
					<c:if test="${not empty jar.sources }">
						<button style="margin:10px" class="btn btn-primary btn-lg" onclick="down(this.value)" value="${jar.sources }">源码下载</button>
					</c:if>
					<c:if test="${not empty jar.pom }">
						<button style="margin:10px" class="btn btn-primary btn-lg" onclick="down(this.value)" value="${jar.pom }">pom查看</button>
					</c:if>
			    </div>
			</div> 
		</c:if>
	</div>
	<div class="data_list">
		<div class="data_list_title">
			<img src="${pageContext.request.contextPath}/static/images/icon_about.png"/>
			相关jar包资源
		</div>
		<c:if test="${not empty jar }">
			<div style="padding: 5px;">
				<table>
					<c:choose>
						<c:when test="${not empty relList }">
							<c:forEach var="jar" items="${relList }" varStatus="status">
								<c:if test="${status.index%2==0 }">
									<tr>
								</c:if>
								<td>
								<a href="${pageContext.request.contextPath}/jar/${jar.id }.html" title="${jar.name }" target="_blank">${jar.name }</a>
								</td>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<c:if test="${status.index%2==1 ||status.last }">
									</tr>
								</c:if>
							</c:forEach>
						</c:when>
						<c:otherwise>
						未找到相关资源
						</c:otherwise>
					</c:choose>
				</table>
			</div>
		</c:if>
	</div>
</div>
