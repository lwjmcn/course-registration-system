<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="classes.ClassesDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="student.StudentDAO" %>
<%@ page import="student.Student" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
  <title>Register Action</title>
</head>
<body>
<%
  String userID = null;
  if(session.getAttribute("userID") != null)
  {
    userID = (String) session.getAttribute("userID");
  }
  if(userID != null) // 로그인이 되어있다면
  {
    ClassesDAO classesDAO = new ClassesDAO();
    StudentDAO studentDAO = new StudentDAO();

    //입력받아오기
    String studentID = request.getParameter("studentID");
    Student student = studentDAO.showMe(userID);
    String classID = request.getParameter("classID");

    //조건
    //1동일시간대
    boolean timeConflict = false;
    String time = classesDAO.showTime(classID);
    String[][] table = classesDAO.makeTable(studentID);

    int day1; //1교시 parsing
    if (!time.isEmpty()) {
      switch (time.charAt(0)) {
        case '월':
            day1 = 1;
            break;
          case '화':
            day1 = 2;
            break;
          case '수':
            day1 = 3;
            break;
          case '목':
            day1 = 4;
            break;
          case '금':
            day1 = 5;
            break;
          case '토':
            day1 = 6;
            break;
          default:
            day1 = 7;
            break;
        }
        int start1hh = Integer.parseInt(time.substring(2, 4));
        int start1mm = Integer.parseInt(time.substring(5, 7));
        int end1hh = Integer.parseInt(time.substring(10, 12));
        int end1mm = Integer.parseInt(time.substring(13, 15));
        if (start1hh >= 0 && start1hh < 5) start1hh += 12;
        if (end1hh >= 0 && end1hh < 8) end1hh += 12;
        if (day1 >= 1 && day1 <= 5 && start1hh >= 8 && start1hh < 18) {
          for (int i = ((start1hh - 8) * 2 + start1mm / 30); i < ((end1hh - 8) * 2 + end1mm / 30); i++) {
            if (!table[day1 - 1][i].equals("")) timeConflict = true;
          }
        }
        int start2hh;
        int start2mm;
        int end2hh;
        int end2mm;
        if (time.length() > 17) { //2교시 parsing
          int day2;
          switch (time.charAt(18)) {
            case '월':
              day2 = 1;
              break;
            case '화':
              day2 = 2;
              break;
            case '수':
              day2 = 3;
              break;
            case '목':
              day2 = 4;
              break;
            case '금':
              day2 = 5;
              break;
            case '토':
              day2 = 6;
              break;
            default:
              day2 = 7;
              break;
          }
          start2hh = Integer.parseInt(time.substring(19, 21));
          start2mm = Integer.parseInt(time.substring(22, 24));
          end2hh = Integer.parseInt(time.substring(27, 29));
          end2mm = Integer.parseInt(time.substring(30, 32));
          if (start2hh >= 0 && start2hh < 6) start2hh += 12;
          if (end2hh >= 0 && end2hh < 8) end2hh += 12;
          if (day2 >= 1 && day2 <= 5 && start2hh >= 8 && start2hh < 18) {
            for (int i = ((start2hh - 8) * 2 + start2mm / 30); i < ((end2hh - 8) * 2 + end2mm / 30); i++) {
              if (!table[day2 - 1][i].equals("")) timeConflict = true;
            }
          }
        }
    }
    if (timeConflict) {
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('동일 시간대에 수업이 존재합니다.')");
      script.println("history.back()");
      script.println("</script>");
    }
    //2이전성적 b0 초과
    else if(classesDAO.showRetakeCredit(studentID,classID).equals("A+") || classesDAO.showRetakeCredit(studentID,classID).equals("A0") || classesDAO.showRetakeCredit(studentID,classID).equals("B+")){
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('재수강 불가능한 과목입니다.')");
      script.println("history.back()");
      script.println("</script>");
    }
    //3정원초과
    else if(classesDAO.showPersonNum(classID)== classesDAO.showPersonMax(classID)){
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('정원을 초과했습니다.')");
      script.println("history.back()");
      script.println("</script>");
    }
    //4최대학점초과
    else if(classesDAO.showCreditNum(classID)+ studentDAO.showCreditNum(studentID) > 18) {
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('최대 신청학점을 초과했습니다.')");
      script.println("history.back()");
      script.println("</script>");
    }
    else { // 모든 조건을 통과한 경우
      int result = classesDAO.register(studentID, classID);
      if (result == -1) { //실패
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('데이터베이스 오류가 발생했습니다.')");
        script.println("history.back()");
        script.println("</script>");
      } else { //성공
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('신청되었습니다.')");
        script.println("location.href = 'showRegister.jsp'");
        script.println("</script>");
      }
    }
  }
%>
</body>
</html>