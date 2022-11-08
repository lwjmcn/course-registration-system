<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="classes.ClassesDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
  <title>Delete Register Action</title>
</head>
<body>
<%
  String userID = null;
  if(session.getAttribute("userID") != null)
  {
    userID = (String) session.getAttribute("userID");
  }
  if(userID != null) // 로그인 되어 있다면
  {
    ClassesDAO classesDAO = new ClassesDAO();
    int result = classesDAO.deleteRegister(request.getParameter("studentID"),request.getParameter("classID")); //call 수강취소함수
    if(result == -1){ //실패
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('데이터베이스 오류가 발생했습니다.')");
      script.println("history.back()");
      script.println("</script>");
    } else { //성공
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("location.href = 'showRegister.jsp'");
      script.println("</script>");
    }
  }
%>
</body>
</html>