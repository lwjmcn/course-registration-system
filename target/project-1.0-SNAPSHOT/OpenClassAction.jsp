<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="classes.ClassesDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="classes" class="classes.Classes" scope="page" />
<jsp:setProperty name="classes" property="classID" />
<jsp:setProperty name="classes" property="classNum" />
<jsp:setProperty name="classes" property="courseID" />
<jsp:setProperty name="classes" property="majorID" />
<jsp:setProperty name="classes" property="year" />
<jsp:setProperty name="classes" property="credit" />
<jsp:setProperty name="classes" property="lecturerID" />
<jsp:setProperty name="classes" property="personMax" />
<jsp:setProperty name="classes" property="roomID" />
<jsp:setProperty name="classes" property="day1" />
<jsp:setProperty name="classes" property="start1" />
<jsp:setProperty name="classes" property="end1" />
<jsp:setProperty name="classes" property="day2" />
<jsp:setProperty name="classes" property="start2" />
<jsp:setProperty name="classes" property="end2" />
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
  <title>Open Class Action</title>
</head>
<body>
<%
  ClassesDAO classesDAO = new ClassesDAO();
  int result; //수업 설강 여부 저장하는 변수

  // 입력 받아오기
  String classID = classes.getClassID();
  String classNum = classes.getClassNum();
  String courseID = classes.getCourseID();
  int majorID = classes.getMajorID();
  int year = classes.getYear();
  int credit = classes.getCredit();
  String lecturerID = classes.getLecturerID();
  int personMax = classes.getPersonMax();
  int roomID = classes.getRoomID();

  //수강정원 제한 조건 (일요일은 선택지에 아예 존재하지 않도록 함)
  if(personMax > classesDAO.roomPersonMax(roomID)) {
    PrintWriter script = response.getWriter();
    script.println("<script>");
    script.println("alert('수강정원은 강의실 수용인원을 초과할 수 없습니다.')");
    script.println("location.href = 'AdminMain.jsp'"); //history.back 사용 시 이전 입력이 그대로 유지되기 때문
    script.println("</script>");
  } else { //제한 조건을 만족하지 않는 경우 종료되도록 나머지를 모두 else문 안에 넣음
    //1900-01-0D0HH:MM:00.000Z 형태로 변환하기
    String day1 = classes.getDay1();
    if (day1.equals("Mon")) day1 = "1";
    else if (day1.equals("Tue")) day1 = "2";
    else if (day1.equals("Wed")) day1 = "3";
    else if (day1.equals("Thu")) day1 = "4";
    else if (day1.equals("Fri")) day1 = "5";
    else if (day1.equals("Sat")) day1 = "6";
    String start1 = classes.getStart1();
    start1 = "1900-01-0" + day1 + "0" + start1.substring(0, 2) + ":" + start1.substring(3, 5) + ":00.000Z";
    String end1 = classes.getEnd1();
    end1 = "1900-01-0" + day1 + "0" + end1.substring(0, 2) + ":" + end1.substring(3, 5) + ":00.000Z";

    //2교시 존재하는 경우
    String day2 = classes.getDay2();
    String start2 = classes.getStart2();
    String end2 = classes.getEnd2();
    if (day2 != null && start2 != null && end2 != null) {
      if (day2.equals("Mon")) day2 = "1";
      else if (day2.equals("Tue")) day2 = "2";
      else if (day2.equals("Wed")) day2 = "3";
      else if (day2.equals("Thu")) day2 = "4";
      else if (day2.equals("Fri")) day2 = "5";
      else if (day2.equals("Sat")) day2 = "6";
      start2 = "1900-01-0" + day2 + "0" + start2.substring(0, 2) + ":" + start2.substring(3, 5) + ":00.000Z";
      end2 = "1900-01-0" + day2 + "0" + end2.substring(0, 2) + ":" + end2.substring(3, 5) + ":00.000Z";

      result = classesDAO.openClass(classID, classNum, courseID, majorID, year, credit, lecturerID, personMax, roomID, start1, end1, start2, end2);
    }
    //2교시가 존재하지 않는 경우
    else
      result = classesDAO.openClass(classID, classNum, courseID, majorID, year, credit, lecturerID, personMax, roomID, start1, end1, null, null);

    if (result == -1) { //실패
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('데이터베이스 오류가 발생했습니다.')");
      script.println("location.href = 'AdminMain.jsp'"); //history.back 사용 시 이전 입력이 그대로 유지되기 때문
      script.println("</script>");
    } else { //성공
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('설강했습니다')");
      script.println("location.href = 'AdminMain.jsp'");
      script.println("</script>");
    }
  }
%>
</body>
</html>