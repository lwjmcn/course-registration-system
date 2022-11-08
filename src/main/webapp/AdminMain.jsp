<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="admin.AdminDAO" %>
<%@ page import="admin.Admin" %>
<%@ page import="classes.ClassesDAO" %>
<%@ page import="classes.Classes" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
  <title>Admin Main Page</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Hahmlet:wght@500;700&display=swap" rel="stylesheet">
</head>
<style>
  * {
    font-family: 'Hahmlet', serif;
  }
  .mytitle {
    width: 100%;
    height: 80px;
    display: flex;
    justify-content: space-between;
    padding-right: 15px;
    border-bottom: 3px solid #0a53be;
  }
  .btn-primary {
    padding-top: 2px;
    margin-left: 5px;
  }
  .subtitle {
    margin-top: 10px;
    margin-bottom: 10px;
    font-weight: bold;
  }
  .content {
    width: 90%;
    margin: 0 auto;
  }
  .search-input {
    width: auto;
    height: auto;
    padding: 10px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    border: 2px solid darkgrey;
  }
  .form-control {
    margin-left: 10px;
    margin-right: 30px;
    min-width:120px;
    max-width: 200px;
  }
  .table-container {
    margin-top: 10px;
    height: 440px;
    overflow: auto;
    border: 1px solid darkgrey;
  }
  .copyright {
    text-align: center;
    color: darkgrey;
    font-size: smaller;
    font-weight: lighter;
    margin-top: 8px;

  }
  .table {
    font-size: small;
  }
</style>
<body>
<!--헤더-->
<div class="mytitle">
  <div style="display: flex;align-items: center">
    <img src="image\logo.png" onclick="location.href='AdminMain.jsp'" width="50" height=50" style="margin-left: 20px">
    <h1 style="font-weight:bold;padding-left:10px">수강 신청</h1>
  </div>
  <!--로그인 정보-->
  <div style="width:auto;height:30px;display:flex;align-content:center;align-self:flex-end;margin-bottom:5px">
    <%
      String userID = null;
      if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
      }
    %>
    <%
      if (userID == null) {
    %>
    <p style="font-size: large">현재 로그인 되어 있지 않습니다. </p>
    <button type="button" class="btn btn-primary" onClick="location.href='login.jsp'">로그인</button>
    <button type="button" class="btn btn-primary" onClick="location.href='join.jsp'">회원가입</button>

    <%
    } else {
    %>
    <p>관리자 모드</p>
    <button type="button" class="btn btn-primary" onClick="location.href='logoutAction.jsp'">로그아웃</button>
    <%
      }
    %>
  </div>
</div>
<!--내용-->
<div class="content">
  <!--메뉴-->
  <div class="btn-group" role="group" aria-label="Button group with nested dropdown" style="margin-top:10px">
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminMain.jsp'">수강편람</button>
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminStudent.jsp'">학생정보</button>
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminClasses.jsp'">과목정보</button>
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminOpenClass.jsp'">수업설강</button>
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminOLAP.jsp'">통계조회</button>
  </div>
  <h3 class="subtitle">> 수강 편람</h3>
  <!--검색창-->
  <form method="post" action="AdminMain.jsp">
    <div class="search-input">
      <!--검색 입력-->
      <div style="display:flex;justify-content:space-around;height:30px;margin:20px">
        <div style="display:flex">
          <p style="min-width:70px">수업 번호:</p>
          <input type="search" class="form-control" name="classNum" maxlength="5">
        </div>
        <div style="display:flex">
          <p style="min-width:70px">학수 번호:</p>
          <input type="search" class="form-control" name="courseID" maxlength="7">
        </div>
        <div style="display:flex">
          <p style="min-width:70px">교과목명:</p>
          <input type="search" class="form-control" name="courseName" maxlength="20">
        </div>
      </div>
      <!--조회 버튼	-->
      <div style="display:flex;align-items:flex-end;justify-content:flex-end;margin-right:20px">
        <input type="submit" class="btn btn-primary form-control" style="width:100px" value="조회">
      </div>
    </div>
  </form>
  <!--수강편람-->
  <div class="table-container">
    <table class="table table-striped table-hover">
      <thead>
      <tr>
        <th scope="col">신청인원/수강정원</th>
        <th scope="col">수업번호</th>
        <th scope="col">학수번호</th>
        <th scope="col">교과목명</th>
        <th scope="col">교강사명</th>
        <th scope="col">수업시간</th>
        <th scope="col">강의실</th>
      </tr>
      </thead>
      <tbody>
      <%
        ClassesDAO classesDAO = new ClassesDAO();
        String classNum = (String) request.getParameter("classNum");
        String courseID = (String) request.getParameter("courseID");
        String courseName = (String) request.getParameter("courseName");
        ArrayList<Classes> list = classesDAO.search(classNum, courseID, courseName);
        for(int i = 0; i < list.size(); i++) {
          if (list.get(i).getOpenedYear().equals("2022")) {
      %>
      <tr>
        <th scope="row"><%= classesDAO.showPersonNum(list.get(i).getClassID())%>/<%= list.get(i).getPersonMax()%></th>
        <td><%= list.get(i).getClassNum()%></td>
        <td><%= list.get(i).getCourseID()%></td>
        <td><%= list.get(i).getCourseName()%></td>
        <td><%= list.get(i).getLecturerName()%></td>
        <td><%= classesDAO.showTime(list.get(i).getClassID())%></td>
        <td><%= list.get(i).getBuildingName()%> <%= list.get(i).getRoomID()%>호</td>
      </tr>
      <%
          }
        }
        if (list.size()==0) {
      %>
      <tr>
        <td colspan="7">
          <p style="text-align:center">조회를 하지 않았거나 조회된 데이터가 없습니다.</p>
        </td>
      </tr>
      <%
        }
      %>
      </tbody>
    </table>
  </div>
  <!--copyright-->
  <p class="copyright">Copyrightⓒ2022 lwjmcn All rights reserved.</p>
</div>
</body>
</html>