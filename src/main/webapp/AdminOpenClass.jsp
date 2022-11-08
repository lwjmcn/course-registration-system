<%@ page contentType="text/html; charset=euc-kr" pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
    <meta name="viewport" content="width=devoce-width", initial-scale="1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Hahmlet:wght@500;700&display=swap" rel="stylesheet">
    <title>Admin Open Class</title>
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
    .class-input {
        width: auto;
        height: auto;
        padding: 30px;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        border: 2px solid darkgrey;
    }
    .copyright {
        text-align: center;
        color: darkgrey;
        font-size: smaller;
        font-weight: lighter;
        margin-top: 8px;
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
    <h3 class="subtitle">> 수업 설강하기</h3>
    <p>2교시가 존재하지 않는 경우 입력하지 말고 제출해주세요.</p>
    <!--박스-->
    <div class="class-input">
        <!--입력-->
        <form class="row g-3" method="post" action="OpenClassAction.jsp">
            <div class="col-md-2">
                <label for="classID" class="form-label">수업ID</label>
                <input type="text" class="form-control" id="classID" name="classID" maxlength="5" placeholder="ex 8831" required>
            </div>
            <div class="col-md-2">
                <label for="classNum" class="form-label">수업번호</label>
                <input type="text" class="form-control" id="classNum" name="classNum" maxlength="5" placeholder="ex 10003" required>
            </div>
            <div class="col-md-2">
                <label for="courseID" class="form-label">학수번호</label>
                <input type="text" class="form-control" id="courseID" name="courseID" maxlength="7" placeholder="ex CIE3022" required>
            </div>
            <div class="col-md-6"></div>
            <div class="col-md-1">
                <label for="majorID" class="form-label">전공ID</label>
                <input type="number" class="form-control" id="majorID" name="majorID" placeholder="ex 1" required>
            </div>
            <div class="col-md-1">
                <label for="year" class="form-label">학년</label>
                <select id="year" class="form-select" name="year">
                    <option selected>선택</option>
                    <option>1</option>
                    <option>2</option>
                    <option>3</option>
                    <option>4</option>
                </select>
            </div>
            <div class="col-md-1">
                <label for="credit" class="form-label">학점수</label>
                <select id="credit" class="form-select" name="credit">
                    <option selected>선택</option>
                    <option>1</option>
                    <option>2</option>
                    <option>3</option>
                </select>
            </div>
            <div class="col-md-2">
                <label for="lecturerID" class="form-label">강사ID</label>
                <input type="text" class="form-control" id="lecturerID" name="lecturerID" maxlength="10" placeholder="ex 2001001001" required>
            </div>
            <div class="col-md-7"></div>
            <div class="col-md-2">
                <label for="personMax" class="form-label">수강정원</label>
                <input type="number" class="form-control" id="personMax" name="personMax" required>
            </div>
            <div class="col-md-2">
                <label for="roomID" class="form-label">강의실ID</label>
                <input type="number" class="form-control" id="roomID" name="roomID" required>
            </div>
            <div class="col-md-8"></div>
            <div class="col-md-1">
                <label for="day1" class="form-label">요일</label>
                <select id="day1" class="form-select" name="day1">
                    <option selected>선택</option>
                    <option>Mon</option>
                    <option>Tue</option>
                    <option>Wed</option>
                    <option>Thu</option>
                    <option>Fri</option>
                    <option>Sat</option>
                </select>
            </div>
            <div class="col-md-2">
                <label for="start1" class="form-label">1교시 시작시간</label>
                <input type="time" class="form-control" id="start1" name="start1" required>
            </div>
            <div class="col-md-2">
                <label for="end1" class="form-label">1교시 종료시간</label>
                <input type="time" class="form-control" id="end1" name="end1" required>
            </div>
            <div class="col-md-7"></div>
            <div class="col-md-1">
                <label for="day2" class="form-label">요일</label>
                <select id="day2" class="form-select" name="day2">
                    <option selected>선택</option>
                    <option>Mon</option>
                    <option>Tue</option>
                    <option>Wed</option>
                    <option>Thu</option>
                    <option>Fri</option>
                    <option>Sat</option>
                </select>
            </div>
            <div class="col-md-2">
                <label for="start2" class="form-label">2교시 시작시간</label>
                <input type="time" class="form-control" id="start2" name="start2">
            </div>
            <div class="col-md-2">
                <label for="end2" class="form-label">2교시 종료시간</label>
                <input type="time" class="form-control" id="end2" name="end2">
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">설강</button>
            </div>
        </form>
    </div>
    <!--copyright-->
    <p class="copyright">Copyrightⓒ2022 lwjmcn All rights reserved.</p>
</div>


<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
</body>
</html>