<%@page import="file.FileDAO"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href='login.jsp'");
		script.println("</script>");
	}
	int bbsID = 0;
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}
	if (bbsID == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href='bbs.jsp'");
		script.println("</script>");
	}
	Bbs bbs = new BbsDAO().getBbs(bbsID);
	if (!userID.equals(bbs.getUserID())) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href='login.jsp'");
		script.println("</script>");
	}
	
	 // 파일 삭제 요청 처리
    if (request.getParameter("deleteFile") != null) {
        String filename = request.getParameter("deleteFile");

        // 파일이 저장된 디렉토리 경로
        String directory = application.getRealPath("/upload/" + bbsID + "/");
        String filePath = directory + filename;

        File file = new File(filePath);
        if (file.exists()) {
            try {
                // 파일 삭제
                file.delete();
                // 데이터베이스에서도 파일 정보 삭제
                new FileDAO().deleteFile(bbsID, filename);
                response.sendRedirect("update.jsp?bbsID=" + bbsID);
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>alert('파일 삭제에 실패했습니다.'); history.back();</script>");
            }
        } else {
            out.println("<script>alert('존재하지 않는 파일입니다.'); history.back();</script>");
        }
    }
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 메인</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<form method="post" action="updateAction.jsp?bbsID=<%=bbsID%>" enctype="multipart/form-data">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2"
								style="background-color: #eeeeee; text-align: center;">게시판
								글 수정</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" class="form-control"
								placeholder="글 제목" name="bbsTitle" maxlength="50"
								value="<%=bbs.getBbsTitle()%>"></td>
						</tr>
						<tr>
							<td><textarea class="form-control" placeholder="글 내용"
									name="bbsContent" maxlength="2048" style="height: 350px;"><%=bbs.getBbsContent()%>"</textarea></td>
						</tr>
					</tbody>
				</table>
				첨부파일 :
			<%
			// 파일 삭제 요청 처리
			if (request.getParameter("deleteFile") != null) {
			    String filename = request.getParameter("deleteFile");

			    // 파일이 저장된 디렉토리 경로
			    String directory = application.getRealPath("/upload/" + bbsID + "/");
			    String filePath = directory + filename;

			    File file = new File(filePath);
			    if (file.exists()) {
			        try {
			            // 파일 삭제
			            file.delete();
			            // 데이터베이스에서도 파일 정보 삭제
			            new FileDAO().deleteFile(bbsID, filename);
			            response.sendRedirect("update.jsp?bbsID=" + bbsID);
			        } catch (Exception e) {
			            e.printStackTrace();
			            out.println("<script>alert('파일 삭제에 실패했습니다.'); history.back();</script>");
			        }
			    } else {
			        out.println("<script>alert('존재하지 않는 파일입니다.'); history.back();</script>");
			    }
			}

// 			// 파일 등록 요청 처리
// 			if (request.getPart("file") != null) {
// 			    Part filePart = request.getPart("file");
// 			    String fileName = filePart.getSubmittedFileName();
// 			    String directory = application.getRealPath("/upload/" + bbsID + "/");

// 			    // 기존 파일 삭제
// 			    String[] files = new File(directory).list();
// 			    if (files.length > 0) {
// 			        for (String file : files) {
// 			            File deleteFile = new File(directory + file);
// 			            deleteFile.delete();
// 			            new FileDAO().deleteFile(bbsID, file);
// 			        }
// 			    }

// 			    // 새 파일 저장
// 			    File targetDir = new File(directory);
// 			    if (!targetDir.exists()) {
// 			        targetDir.mkdirs();
// 			    }
// 			    String filePath = directory + fileName;
// 			    filePart.write(filePath);
// 			    new FileDAO().upload(fileName, fileName, bbsID);

// 			    response.sendRedirect("update.jsp?bbsID=" + bbsID);
// 			}
			
			String directory = application.getRealPath("/upload/" + bbsID + "/");

			File targetDir = new File(directory);
			if (!targetDir.exists()) {
				targetDir.mkdirs();
			}

			String files[] = new File(directory).list();

			if (files.length > 0) {
				for (String file : files) {
					out.write("<a href=\"" + request.getContextPath() + "/downloadAction?bbsID=" + bbsID + "&file=" + java.net.URLEncoder.encode(file, "UTF-8") + "\">" + file + "</a><br>");
					out.write("<button class=\"btn btn-danger btn-sm\" onclick=\"deleteFile('" + file + "')\">삭제</button><br>");
				}
			} else {
				out.write("등록된 파일이 없습니다.");
			}
			%>
				파일 선택 :<input type="file" name="file"> <input type="submit"
					class="btn btn-primary pull-right" value="글 수정"
					onclick="deleteFile()">
				 <script>
                function deleteFile(filename) {
                    // 비동기 방식으로 파일 삭제 요청을 처리
                    var xhr = new XMLHttpRequest();
                    xhr.open("POST", "update.jsp?bbsID=<%=bbsID%>&deleteFile=" + filename, true);
                    xhr.onreadystatechange = function () {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                            // 파일이 성공적으로 삭제되면 해당 파일 정보를 화면에서 숨김
                            var fileElement = document.getElementById(filename);
                            fileElement.style.display = "none";
                        }
                    };
                    xhr.send();

                    // 화면에서 해당 파일을 숨기는 부분
                    var fileForm = document.querySelector('input[type="file"]');
                    fileForm.parentNode.removeChild(fileForm);
                }
            </script>
			</form>
		</div>
	</div>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>