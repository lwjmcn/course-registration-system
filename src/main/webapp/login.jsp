<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>Login</title>
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
    .subtitle {
        margin-top: 10px;
        margin-bottom: 10px;
        font-weight: bold;
    }
    .content {
        width: 90%;
        margin: 0 auto;
    }
    .login-input {
        width: auto;
        height: auto;
        padding: 30px;
        display: flex;
        flex-direction: row;
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
            <img src="image\logo.png" onclick="location.href=`main.jsp`" width="50" height=50" style="margin-left: 20px">
            <h1 style="font-weight:bold;padding-left:10px">수강 신청</h1>
        </div>
    </div>
    <!--내용-->
    <div class="content">
        <form method="post" action="loginAction.jsp">
            <h3 class="subtitle">> 로그인</h3>
            <!--박스-->
            <div class="login-input">
                <!--로그인 입력-->
                <div style="flex-direction:column;margin-right:10px">
                    <input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20" style="margin-bottom:10px">
                    <input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
                </div>
                <!--로그인 버튼	-->
                <div style="display:flex">
                    <input type="submit" class="btn btn-primary form-control" style="width:100px" value="로그인">
                </div>
            </div>
        </form>
        <!--copyright-->
        <p class="copyright">Copyrightⓒ2022 lwjmcn All rights reserved.</p>
    </div>


    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>