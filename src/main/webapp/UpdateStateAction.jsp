<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="student.StudentDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
  <title>Update Student State Action</title>
</head>
<body>
<%
  String userID = null;
  if(session.getAttribute("userID") != null)
  {
    userID = (String) session.getAttribute("userID");
  }
  if(userID != null) {
    StudentDAO studentDAO = new StudentDAO();
    String updatedState = request.getParameter("state");
    String studentID = request.getParameter("studentID");
    int result = studentDAO.updateState(updatedState, studentID); //call 상태변경함수
    if (result == -1) { //실패
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('데이터베이스 오류가 발생했습니다.')");
      script.println("history.back()");
      script.println("</script>");
    } else { //성공
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('변경되었습니다.')");
      script.println("location.href = 'AdminStudent.jsp'");
      script.println("</script>");
    }
    //휴학 혹은 자퇴 시 수강신청인원에서 제외
    if (updatedState.equals("휴학") || updatedState.equals("자퇴")) {
      int result2 = studentDAO.ifDrop(studentID);
      if (result2 == -1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('데이터베이스 오류가 발생했습니다.')");
        script.println("history.back()");
        script.println("</script>");
      }
    }
  }
%>
</body>
</html>