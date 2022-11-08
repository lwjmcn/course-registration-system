<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="admin.AdminDAO" %>
<%@ page import="admin.Admin" %>
<%@ page import="classes.ClassesDAO" %>
<%@ page import="classes.Classes" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
  <title>Admin OLAP Page</title>
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
  <h3 class="subtitle">> 통계 조회</h3>
  <p>평점평균과 특정 과목의 학점 간 차이가 가장 큰 10개의 과목 목록입니다.</p>
  <!--TOP10 목록-->
  <div class="table-container">
    <table class="table table-striped table-hover">
      <thead>
      <tr>
        <th scope="col">순위</th>
        <th scope="col">학수번호</th>
        <th scope="col">교과목명</th>
        <th scope="col">(평점평균-각 과목 학점)의 평균</th>
      </tr>
      </thead>
      <tbody>
      <%
        ClassesDAO classesDAO = new ClassesDAO();
        ArrayList<Classes> list = classesDAO.showOLAP(); // DAO 함수로 OLAP 결과를 불러옴
        for(int i = 0; i < 10; i++) {
      %>
      <tr>
        <th scope="row"><%=(i+1)%></th>
        <td><%= list.get(i).getCourseID()%></td>
        <td><%= list.get(i).getCourseName()%></td>
        <td><%= list.get(i).getOLAP()%></td>
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