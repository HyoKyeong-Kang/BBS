<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "file.FileDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<% request.setCharacterEncoding("UTF-8"); %>
 
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"></jsp:useBean>
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP BBS</title>
</head>
<body>
    <%
    	String userID = null;
    	if (session.getAttribute("userID") != null){
            userID = (String) session.getAttribute("userID");
    	}
    	
    	BbsDAO bbsDAO = new BbsDAO();
    	Bbs Bbs= new Bbs();
    	bbs.setBbsID(bbsDAO.getNewNext());
    	int bbsID = bbs.getBbsID();
    	String directory = application.getRealPath("/upload/"+bbsID+"/");
    	
    	File targetDir = new File(directory);
    	if(!targetDir.exists()){
    		targetDir.mkdirs();
    	}
    	
    	int maxSize = 1024 * 1024 * 500;
    	String encoding = "UTF-8";
    	
    	MultipartRequest multipartRequest
    	= new MultipartRequest(request, directory, maxSize, encoding,
    					new DefaultFileRenamePolicy());
    	
    	String fileName = multipartRequest.getOriginalFileName("file");
    	String fileRealName = multipartRequest.getFilesystemName("file");
    	
    	String bbsTitle = multipartRequest.getParameter("bbsTitle");
    	String bbsContent = multipartRequest.getParameter("bbsContent");
    	bbs.setBbsTitle(bbsTitle);
    	bbs.setBbsContent(bbsContent);
    	
    
    	
    	
    	if (userID == null){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인하세요.')");
            script.println("location.href = 'login.jsp'");    // 메인 페이지로 이동
            script.println("</script>");
    	}else{
    		System.out.println("write action : check bbs parameter" + bbs.getBbsTitle());
    		
    		if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null){
        		PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('모든 문항을 입력해주세요.')");
                script.println("history.back()");    // 이전 페이지로 사용자를 보냄
                script.println("</script>");
        	}else{
        		System.out.println("getNewNext before bbsDAO.write : " + bbs.getBbsID());
    			int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
    			
    			
    			
    			new FileDAO().upload(fileName, fileRealName, bbs.getBbsID());
    			out.write("filename : " + fileName + "<br>");
    			out.write("realfilename : " + fileName + "<br>");	
        		
                if (result == -1){ // 글쓰기 실패시
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('글쓰기에 실패했습니다.')");
                    script.println("history.back()");    // 이전 페이지로 사용자를 보냄
                    script.println("</script>");
                }else{ // 글쓰기 성공시
                	PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("location.href = 'bbs.jsp'");    // 메인 페이지로 이동
                    script.println("</script>");    
                }
        	}	
    	}
    %>
 
</body>
</html>
