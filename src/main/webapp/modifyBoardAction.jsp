<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="vo.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%
	//프로젝트안에 있는 upload 폴더의 실제 물리적 위치
	String dir = request.getServletContext().getRealPath("/upload");
	System.out.println(dir + " <-- dir");
	
	// 파일 최대 크기 = 10Mbyte
	int max = 10 * 1024 * 1024;
	
	// request객체를 MutipartReqest의 API를 사용할 수 있도록 랩핑
	MultipartRequest mRequest  = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	
	// 요청값 유효성 검사
	if(mRequest.getParameter("boardNo") == null					// boardNo나 boardFileNo가 null이거나 공백이면
		|| mRequest.getParameter("boardFileNo") == null
		|| mRequest.getParameter("boardNo").equals("")
		|| mRequest.getParameter("boardFileNo").equals("")) {
		// 파일이 저장되었다면 삭제하고
		String saveFilename = mRequest.getFilesystemName("boardFile");
		File f = new File(dir+"/"+saveFilename);
		if(f.exists()) {
			f.delete();
			System.out.println(saveFilename + "파일삭제");
		}
		// boardList로 가라
		response.sendRedirect(request.getContextPath() + "/boardList.jsp");
	}
	// 요청값 변수 저장
	int boardNo = Integer.parseInt(mRequest.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(mRequest.getParameter("boardFileNo"));
	String boardTilte = mRequest.getParameter("boardTitle");
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// boardTitle 수정
	String boardSql = "UPDATE board SET board_title = ?, createdate=NOW() WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setString(1, boardTilte);
	boardStmt.setInt(2, boardNo);
	int boardRow = boardStmt.executeUpdate();
	// 이전 boardFile 삭제, 새로운 boardFile 추가 및 board_file 테이블을 수정
	if(mRequest.getOriginalFileName("boardFile") != null) {				// 저장된 boardFile이 있다면
		// 현재 저장된 파일이 PDF 파일인지 검사
		if(!mRequest.getContentType("boardFile").equals("application/pdf")) { // PDF 파일이 아니면
			// 저장된 파일을 삭제
			System.out.println("pdf파일이 아닙니다.");
			String saveFilename = mRequest.getFilesystemName("boardFile");
			File f = new File(dir+"/"+saveFilename);
			if(f.exists()) {
				f.delete();
				System.out.println(saveFilename + "파일삭제");
			}
		} else { // PDF 파일 이면
			// 요청값 저장
			String type = mRequest.getContentType("boardFile");
			String originFilename = mRequest.getOriginalFileName("boardFile");
			String saveFilename = mRequest.getFilesystemName("boardFile");
			// BorardFile 객체에 값 저장
			BoardFile boardFile = new BoardFile();
			boardFile.setBoardFileNo(boardFileNo);
			boardFile.setType(type);
			boardFile.setOriginFilename(originFilename);
			boardFile.setSaveFilename(saveFilename);
			// 이전 파일 삭제
			String saveFilenameSql = "SElECT save_filename saveFilename FROM board_file WHERE board_file_no = ?";
			PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
			saveFilenameStmt.setInt(1, boardFile.getBoardFileNo());
			ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
			String preSaveFilename = "";
			if(saveFilenameRs.next()) {
				preSaveFilename = saveFilenameRs.getString("saveFilename");
			}
			File f = new File(dir+"/"+preSaveFilename);
			if(f.exists()) {
				f.delete();
			}
			// 새로운 파일 정보 board_file 테이블에 업데이트
			String boardFileSql = "UPDATE board_file SET origin_filename = ?, save_filename = ?, createdate=NOW() WHERE board_file_no = ?";
			PreparedStatement boardFileStmt = conn.prepareStatement(boardFileSql);
			boardFileStmt.setString(1, originFilename);
			boardFileStmt.setString(2, saveFilename);
			boardFileStmt.setInt(3, boardFile.getBoardFileNo());
			int boardFileRow = boardFileStmt.executeUpdate();
		}
	}
	// boardList로 가라
	response.sendRedirect(request.getContextPath() + "/boardList.jsp");
%>