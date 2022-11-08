<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="student.StudentDAO" %>
<%@ page import="student.Student" %>
<%@ page import="classes.ClassesDAO" %>
<%@ page import="classes.Classes" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
    <title>Register Page</title>
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
        <img src="image\logo.png" onclick="location.href='main.jsp'" width="50" height=50" style="margin-left: 20px">
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
        <%
        } else {
            StudentDAO studentDAO = new StudentDAO();
            Student student = studentDAO.showMe(userID);
        %>
        <p>학번: <%=student.getStudentID()%> 이름: <%=student.getStudentName()%></p>
        <button type="button" class="btn btn-primary" onClick="location.href='logoutAction.jsp'">로그아웃</button>
        <%
            }
        %>
    </div>
</div>
<!--내용-->
<div class="content">
    <%
        if(userID!=null)
        {
    %>
    <div style="display:flex;flex-direction:row;justify-content:space-between">
        <!--메뉴-->
        <div class="btn-group" role="group" aria-label="Button group with nested dropdown" style="margin-top:10px;">
            <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='main.jsp'">수강편람</button>
            <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='Register.jsp'">수강신청</button>
            <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='showWant.jsp'">희망내역</button>
            <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='showRegister.jsp'">신청내역</button>
            <button type="button" class="btn btn-primary" style="margin-left:2px" onclick="location.href='showTimetable.jsp'">수업시간표 조회</button>
        </div>
        <!--신청학점-->
        <div style="display:flex;flex-direction:row;justify-content:space-between;margin-top:10px;height:30px" >
            <ul class="list-group list-group-horizontal">
                <li class="list-group-item">신청학점</li>
                <%
                    StudentDAO studentDAO = new StudentDAO();
                    Student student = studentDAO.showMe(userID);
                %>
                <li class="list-group-item"><%=studentDAO.showCreditNum(student.getStudentID())%> / 18</li>
            </ul>
        </div>
    </div>
    <%
        }
    %>
    <h3 class="subtitle">> 수업시간표 조회</h3>
    <p>아래 시간표에는 E-러닝 과목이 포함되어 있지 않습니다</p>
    <!--시간표-->
    <div class="table-container">
        <table class="table table-bordered">
            <thead>
            <tr>
                <th scope="col">시간</th>
                <th scope="col">월</th>
                <th scope="col">화</th>
                <th scope="col">수</th>
                <th scope="col">목</th>
                <th scope="col">금</th>
            </tr>
            </thead>
            <tbody>
            <%
                ClassesDAO classesDAO = new ClassesDAO();
                StudentDAO studentDAO = new StudentDAO();
                Student student = studentDAO.showMe(userID);
                String[][] table = classesDAO.makeTable(student.getStudentID()); // 함수로 수업시간 배열 생성 (주솟값을 그대로 가져옴)
                for(int i = 0; i < 20; i++) {
            %>
            <tr>
                <%
                    if((i+16)%2==0) {
                %>
                <th scope="row"><%=(i+16)/2%>:00 - <%=(i+16)/2%>:30</th>
                <%
                    } else {
                %>
                <th scope="row"><%=(i+16)/2%>:30 - <%=(i+16)/2+1%>:00</th>
                <%
                    }
                %>
                <td class="col-md-2"><%=table[0][i]%></td>
                <td class="col-md-2"><%=table[1][i]%></td>
                <td class="col-md-2"><%=table[2][i]%></td>
                <td class="col-md-2"><%=table[3][i]%></td>
                <td class="col-md-2"><%=table[4][i]%></td>
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