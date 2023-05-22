<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//세션 유효성 검사(로그인 유무)
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/login.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	// 요청값 유효성 검사
	if (request.getParameter("boardNo") == null
		|| request.getParameter("boardFileNo") == null
		|| request.getParameter("boardNo").equals("")
		|| request.getParameter("boardFileNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/boardList.jsp");
		return;
	}
	// 요청값 변수 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// boardNo와 boardFileNo가 일치하는 데이터 조회
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename FROM board b INNER JOIN board_file f ON b.board_no = f.board_no WHERE b.board_no = ? AND f.board_file_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setInt(2, boardFileNo);
	ResultSet rs = stmt.executeQuery();
	// 조회한 데이터 HashMap에 저장
	HashMap<String, Object> map = null;
	if(rs.next()) {
		map = new HashMap<>();
		map.put("boardNo",rs.getInt("boardNo"));
		map.put("boardTitle",rs.getString("boardTitle"));
		map.put("boardFileNo",rs.getInt("boardFileNo"));
		map.put("originFilename",rs.getString("originFilename"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyBoard</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1>PDF자료 수정</h1>
		<form action="<%=request.getContextPath()%>/modifyBoardAction.jsp" method="post" enctype="multipart/form-data">
			<input type="hidden" name="boardNo" value="<%=map.get("boardNo")%>">
			<input type="hidden" name="boardFileNo" value="<%=map.get("boardFileNo")%>">
			<table  class="table table-bordered">
				<tr>
					<th class="table-dark">제목</th>
					<td>
						<textarea rows="3" cols="50" name="boardTitle" required="required"><%=map.get("boardTitle")%></textarea>
					</td>
				</tr>
				<tr>
					<th class="table-dark">파일(수정전 파일 : <%=map.get("originFilename") %>)</th>
					<td>
						<input type="file" name="boardFile">
					</td>
				</tr>
			</table>
			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>