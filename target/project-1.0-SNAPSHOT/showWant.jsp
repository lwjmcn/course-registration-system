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
    <title>Show Want Page</title>
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
    <h3 class="subtitle">> 희망 내역</h3>
    <p>희망수업 추가 이후에 과목 상태가 변경될 수 있으므로, 반드시 수강신청 전에 확인해주시기 바랍니다.</p>
    <!--희망내역-->
    <div class="table-container">
        <table class="table table-striped table-hover">
            <thead>
            <tr>
                <th scope="col">신청</th>
                <th scope="col">신청인원/수강정원</th>
                <th scope="col">재수강여부</th>
                <th scope="col">수업번호</th>
                <th scope="col">학수번호</th>
                <th scope="col">교과목명</th>
                <th scope="col">교강사명</th>
                <th scope="col">수업시간</th>
                <th scope="col">강의실</th>
                <th scope="col">희망삭제</th>
            </tr>
            </thead>
            <tbody>
            <%
                StudentDAO studentDAO = new StudentDAO();
                Student student = studentDAO.showMe(userID); //로그인 정보로 학생 본인 정보 불러옴
                ClassesDAO classesDAO = new ClassesDAO();
                ArrayList<Classes> list = classesDAO.showWant(student.getStudentID()); // 희망 추가 내역을 불러옴
                for(int i = 0; i < list.size(); i++) {
            %>
            <tr>
                <th scope="row">
                    <%
                        String studentID = student.getStudentID();
                        String classID = list.get(i).getClassID();
                        if (!classesDAO.ifRegistered(studentID, classID)) { //이미 신청되어있다면 신청 버튼이 뜨지않음
                    %>
                    <form method="post" action="RegisterAction.jsp">
                        <input type="hidden" name="studentID" value="<%=studentID%>">
                        <input type="hidden" name="classID" value="<%=classID%>">
                        <input type="submit" class="btn btn-outline-dark btn-sm" style="font-size:small" value="신청">
                    </form>
                    <%
                        }
                    %>
                </th>
                <td><%= classesDAO.showPersonNum(list.get(i).getClassID())%>/<%= list.get(i).getPersonMax()%></td>
                <td><%= classesDAO.ifRetake(student.getStudentID(), list.get(i).getCourseID())%></td>
                <td><%= list.get(i).getClassNum()%></td>
                <td><%= list.get(i).getCourseID()%></td>
                <td><%= list.get(i).getCourseName()%></td>
                <td><%= list.get(i).getLecturerName()%></td>
                <td><%= classesDAO.showTime(list.get(i).getClassID())%></td>
                <td><%= list.get(i).getBuildingName()%> <%= list.get(i).getRoomID()%>호</td>
                <!--희망삭제-->
                <form method="post" action="DeleteWantAction.jsp">
                    <input type="hidden" name="studentID" value="<%=studentID%>">
                    <input type="hidden" name="classID" value="<%=classID%>">
                    <td><input type="submit" class="btn btn-outline-dark btn-sm" style="font-size:small" value="삭제"></td>
                </form>
            </tr>
            <%
                }
                if(list.size()==0) {
            %>
            <tr>
                <td colspan="10">
                    <p style="text-align:center">희망내역이 없습니다.</p>
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