<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="file.FileDAO"%>

<%
int bbsID = Integer.parseInt(request.getParameter("bbsID"));
String fileName = request.getParameter("fileName");

FileDAO fileDAO = new FileDAO();
fileDAO.deleteFile(bbsID, fileName);

response.sendRedirect("bbs.jsp"); // 파일 삭제 후 게시판 페이지로 리다이렉트
%>
