<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사(로그인 유무)
	if(session.getAttribute("loginMemberId") == null) { // 로그인이 되어있지 않다면
		// 로그인 페이지로 가라
		response.sendRedirect(request.getContextPath()+"/login.jsp");
		return;
	}
	// 로그인 아이디 정보 저장
	String memberId = (String)session.getAttribute("loginMemberId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addBoard</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1>PDF자료 업로드</h1>
		<form action="<%=request.getContextPath()%>/addBoardAction.jsp" method="post" enctype="multipart/form-data">
		<div>
			<table class="table table-bordered">
				<!-- 자료 업로드 제목 -->
				<tr>
					<th class="table-dark">boardTitle</th>
					<td>
						<textarea rows="3" cols="50" name="boardTitle" required="required"></textarea>
					</td>
				</tr>
				<!-- 로그인 사용자 아이디 -->
				<tr>
					<th class="table-dark">memberId</th>
					<td>
						<input type="text" name="memberId" value="<%=memberId%>" readonly="readonly">
					</td>
				</tr>
				<!-- 업로드 파일 -->
				<tr>
					<th class="table-dark">boardFile</th>
					<td>
						<input type="file" name="boardFile" required="required">
					</td>
				</tr>
			</table>
			<button type="submit">자료 업로드</button>
		</div>
		</form>
	</div>
</body>
</html>