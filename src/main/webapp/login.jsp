<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사(로그인 유무)
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<form action="<%=request.getContextPath()%>/loginAction.jsp">
		<div class="container">
			<h1>로그인</h1>
			<table class="table table-bordered">
				<tr>
					<th class="table-dark">ID</th>
					<td>
						<input type="text" name="memberId" required="required">
					</td>
				</tr>
				<tr>
					<th class="table-dark">PW</th>
					<td>
						<input type="password" name="memberPw" required="required">
					</td>
				</tr>
			</table>
			<button type="submit" class="btn btn-dark btn-block">로그인</button>
		</div>
	</form>
</body>
</html>