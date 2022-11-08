<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="admin.AdminDAO" %>
<%@ page import="admin.Admin" %>
<%@ page import="student.StudentDAO" %>
<%@ page import="student.Student" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
  <title>Admin All Students Page</title>
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
  .form-control {
    margin-left: 10px;
    margin-right: 30px;
    min-width:120px;
    max-width: 200px;
  }
  .table-container {
    margin-top: 10px;
    height: 520px;
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
  <h3 class="subtitle">> 학생 정보 조회 및 변경</h3>
  <!--학생 목록-->
  <div class="table-container">
    <table class="table table-striped table-hover">
      <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">학번</th>
        <th scope="col">이름</th>
        <th scope="col">전공</th>
        <th scope="col">지도교수ID</th>
        <th scope="col">지도교수명</th>
        <th scope="col">성별</th>
        <th scope="col">아이디</th>
        <th scope="col">비밀번호</th>
        <th scope="col">상태</th>
        <th scope="col">성적조회</th>
        <th scope="col">금학기 시간표 조회</th>
      </tr>
      </thead>
      <tbody>
      <%
        StudentDAO studentDAO = new StudentDAO();
        ArrayList<Student> list = studentDAO.showAll(); // DAO 함수를 통해 모든 학생 정보를 불러옴
        for(int i = 0; i < list.size(); i++) {
      %>
      <tr>
        <th scope="row"><%=(i+1)%></th>
        <td><%= list.get(i).getStudentID()%></td>
        <td><%= list.get(i).getStudentName()%></td>
        <td><%= list.get(i).getMajorName()%></td>
        <td><%= list.get(i).getProfessorID()%></td>
        <td><%= list.get(i).getProfessorName()%></td>
        <td><%= list.get(i).getStudentGender()%></td>
        <td><%= list.get(i).getUserID()%></td>
        <td><%= list.get(i).getUserPassword()%></td>
        <td><%= list.get(i).getStudentState()%>
          <!--상태 변경 form-->
        <form method="post" action="AdminUpdateStudent.jsp">
          <input type="hidden" name="studentID" value="<%=list.get(i).getStudentID()%>">
          <input type="submit" class="btn btn-outline-dark btn-sm" style="font-size:small" value="변경">
        </form>
        </td>
        <!--성적 조회 form-->
        <form method="post" action="AdminShowCredit.jsp">
          <input type="hidden" name="studentID" value="<%=list.get(i).getStudentID()%>">
          <td><input type="submit" class="btn btn-outline-dark btn-sm" style="font-size:small" value="조회"></td>
        </form>
        <!--시간표 조회 form-->
        <form method="post" action="AdminShowTimetable.jsp">
          <input type="hidden" name="studentID" value="<%=list.get(i).getStudentID()%>">
          <td><input type="submit" class="btn btn-outline-dark btn-sm" style="font-size:small" value="조회"></td>
        </form>
      </tr>
      <%
        }
        if(list.size()==0) {
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