<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="credit.CreditDAO" %>
<%@ page import="credit.Credit" %>
<%@ page import="student.Student" %>
<%@ page import="student.StudentDAO" %>
<%@ page import="java.util.ArrayList" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
  <title>Admin Show Credit Page</title>
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
    width: 1000px;
    height: 500px;
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
  <div class="btn-group" role="group" aria-label="Button group with nested dropdown" style="margin-top:10px;">
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminMain.jsp'">수강편람</button>
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminStudent.jsp'">학생정보</button>
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminClasses.jsp'">과목정보</button>
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminOpenClass.jsp'">수업설강</button>
    <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='AdminOLAP.jsp'">통계조회</button>
  </div>
  <%
    String studentID = request.getParameter("studentID");
  %>
  <h3 class="subtitle">> 학생 정보 조회 및 변경 > 성적 조회</h3>
  <p style="color:#0a53be;font-weight:bold">학생 정보(학번): <%=studentID%></p>
  <!--성적조회-->
  <div class="table-container">
    <table class="table table-bordered">
      <thead>
      <%
        StudentDAO studentDAO = new StudentDAO();
        Student student = studentDAO.showGrade(studentID);
      %>
      <tr>
        <th scope="col">평점평균</th>
        <th scope="col"><%=student.getGrade()%></th>
      </tr>
      </thead>
    </table>
    <p><br>과목별 학점</p>
    <table class="table table-bordered">
      <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">학수번호</th>
        <th scope="col">과목명</th>
        <th scope="col">성적</th>
        <th scope="col">학점</th>
      </tr>
      </thead>
      <tbody>
      <%
        CreditDAO creditDAO = new CreditDAO();
        ArrayList<Credit> list = creditDAO.courseCredit(studentID);
        for(int i = 0; i < list.size(); i++) {
      %>
      <tr>
        <td><%=(i+1)%></td>
        <td><%=list.get(i).getCourseID()%></td>
        <td><%=list.get(i).getCourseName()%></td>
        <td><%=list.get(i).getCredit()%></td>
        <td><%=list.get(i).getCreditByNum()%></td>
      </tr>
      <%
        }
        if(list.size()==0) {
      %>
      <tr>
        <td colspan="5"><p style="text-align:center">조회를 하지 않았거나 조회된 데이터가 없습니다.</p></td>
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