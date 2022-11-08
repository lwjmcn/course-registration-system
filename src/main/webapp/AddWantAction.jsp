<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="classes.ClassesDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html" ; charset="UTF-8">
  <title>Add Want Action</title>
</head>
<body>
<%
  String userID = null; // 로그인 되어 있는지 확인 후 get userID
  if (session.getAttribute("userID") != null) {
    userID = (String) session.getAttribute("userID");
  }
  if (userID != null) { // 로그인 되어 있다면
    ClassesDAO classesDAO = new ClassesDAO();
    int result = classesDAO.addWant(request.getParameter("studentID"), request.getParameter("classID")); // call 희망 추가 함수
    if (result == -1) {
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('데이터베이스 오류가 발생했습니다.')");
      script.println("history.back()");
      script.println("</script>");
    } else {
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('추가되었습니다.')");
      script.println("location.href = 'Register.jsp'"); // 희망 추가는 수강신청 탭에서 진행하므로 수강신청 탭으로 이동
      script.println("</script>");
    }
  }
%>
</body>
</html>