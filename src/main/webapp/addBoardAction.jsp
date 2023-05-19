<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="vo.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	// 프로젝트안에 있는 upload 폴더의 실제 물리적 위치
	String dir = request.getServletContext().getRealPath("/upload");
	System.out.println(dir + " <-- dir");
	
	// 파일 최대 크기 = 10Mbyte
	int max = 1024 * 1024 * 10;
	
	// request객체를 MutipartReqest의 API를 사용할 수 있도록 랩핑
	MultipartRequest mRequest  = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	// 업로드 파일이 pdf파일이 아니면
	if(!mRequest.getContentType("boardFile").equals("application/pdf")) {
		// 이미 저장된 파일을 삭제
		System.out.println("pdf파일이 아닙니다.");
		String saveFilename = mRequest.getFilesystemName("boardFile");
		File f = new File(dir+"/"+saveFilename);
		if(f.exists()) {
			f.delete();
			System.out.println(saveFilename + "파일삭제");
		}
		response.sendRedirect(request.getContextPath() + "/addBoard.jsp");
		return;
	}
	
	// MultipartRequest API를 사용하여 스트림내에서 값을 반환
	// input type="text" 값반환 API
	String boardTitle = mRequest.getParameter("boardTitle");
	String memberId = mRequest.getParameter("memberId");
	// 디버깅
	System.out.println(boardTitle + " <-- boardTitle");
	System.out.println(memberId + " <-- memberId");
	
	// board 테이블에 저장
	Board board = new Board();
	board.setBoardTitle(boardTitle);
	board.setMemberId(memberId);
	
	
	// input type="file" 값(파일 메타 정보)반환 API (원본파일이름, 저장된파일이름, 컨텐츠타입)
	// 파일(바이너리)은 MultipartRequest객체 생성시(14라인)먼저 저장
	String type = mRequest.getContentType("boardFile");
	String originFilename = mRequest.getOriginalFileName("boardFile");
	String saveFilename = mRequest.getFilesystemName("boardFile");
	// 디버깅
	System.out.println(type + " <-- type");
	System.out.println(originFilename + " <-- originFilename");
	System.out.println(saveFilename + " <-- saveFilename");
	// board_file 테이블에 저장
	BoardFile boardFile = new BoardFile();
	boardFile.setOriginFilename(originFilename);
	boardFile.setSaveFilename(saveFilename);
	boardFile.setType(type);
	
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	String boardSql = "INSERT INTO board(board_title, member_id, updatedate, createdate) VALUES(?,?,NOW(),NOW())";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql, PreparedStatement.RETURN_GENERATED_KEYS);
	boardStmt.setString(1,board.getBoardTitle());
	boardStmt.setString(2,board.getMemberId());
	// RETURN_GENERATED_KEYS 옵션 적용하여 키값 저장
	int boardRow = boardStmt.executeUpdate();
	// 입력한 데이터의 키값 반환
	ResultSet keyRs = boardStmt.getGeneratedKeys();
	int boardNo = 0;
	if(keyRs.next()) {
		boardNo = keyRs.getInt(1);
	}
	
	String boardFileSql = "INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate) VALUES(?,?,?,?,'upload',NOW())";
	PreparedStatement boardFileStmt = conn.prepareStatement(boardFileSql);
	boardFileStmt.setInt(1,boardNo);
	boardFileStmt.setString(2,boardFile.getOriginFilename());
	boardFileStmt.setString(3,boardFile.getSaveFilename());
	boardFileStmt.setString(4,boardFile.getType());
	int boardFileRow = boardFileStmt.executeUpdate();
	
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>