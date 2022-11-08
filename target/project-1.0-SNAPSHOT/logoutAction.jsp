<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html"; charset="UTF-8">
    <title>Logout Action</title>
</head>
<body>
    <%
    	session.invalidate(); //로그아웃
    %>
	<script>
		location.href = 'main.jsp';
	</script>
</body>
</html>