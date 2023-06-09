<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="file.FileDAO"%>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<%
    request.setCharacterEncoding("UTF-8");
%>

<%
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    BbsDAO bbsDAO = new BbsDAO();
    Bbs bbs = new Bbs();

    // 게시글 ID 가져오기
    int bbsID = 0;
    if (request.getParameter("bbsID") != null) {
        bbsID = Integer.parseInt(request.getParameter("bbsID"));
    }

    // 파일 업로드 처리
    String directory = application.getRealPath("/upload/" + bbsID + "/");
    File targetDir = new File(directory);
    if (!targetDir.exists()) {
        targetDir.mkdirs();
    }

    int maxSize = 1024 * 1024 * 500;
    String encoding = "UTF-8";

    MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding,
            new DefaultFileRenamePolicy());

    // 파일 정보 가져오기
    String fileName = multipartRequest.getOriginalFileName("file");
    String fileRealName = multipartRequest.getFilesystemName("file");

    // 게시글 정보 가져오기
    String bbsTitle = multipartRequest.getParameter("bbsTitle");
    String bbsContent = multipartRequest.getParameter("bbsContent");
    bbs.setBbsTitle(bbsTitle);
    bbs.setBbsContent(bbsContent);

    // 로그인 확인
    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = 'login.jsp'");    // 메인 페이지로 이동
        script.println("</script>");
    }

    // 게시글 수정 처리
    if (bbsID == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href = 'bbs.jsp'");
        script.println("</script>");
    } else {
        // 기존 게시글 작성자와 현재 로그인 사용자가 같은지 확인
        Bbs originalBbs = bbsDAO.getBbs(bbsID);
        if (!userID.equals(originalBbs.getUserID())) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('권한이 없습니다.')");
            script.println("location.href = 'bbs.jsp'");
            script.println("</script>");
        } else {
        	// 게시글 업데이트
            int result = bbsDAO.update(bbsTitle, bbsContent,bbsID);
            // 파일 업로드 처리
            if (fileName != null && fileRealName != null) {
                FileDAO fileDAO = new FileDAO();
                fileDAO.deleteFile(bbsID, fileRealName);  // 기존 파일 삭제
                fileDAO.upload(fileName, fileRealName, bbsID);  // 새로운 파일 업로드
            }


            PrintWriter script = response.getWriter();
            if (result > 0) {
                script.println("<script>");
                script.println("alert('게시글이 수정되었습니다.')");
                script.println("location.href = 'bbs.jsp'");
                script.println("</script>");
            } else {
                script.println("<script>");
                script.println("alert('게시글 수정에 실패했습니다.')");
                script.println("history.back()");
                script.println("</script>");
            }
        }
    }
%>
