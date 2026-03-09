<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>

<h2>Login</h2>

<form action="LoginServlet" method="post">
    Username: <input type="text" name="username"><br><br>
    Password: <input type="password" name="password"><br><br>

    <img src="CaptchaServlet" /><br><br>

    Enter CAPTCHA:
    <input type="text" name="captcha"><br><br>

    <button type="submit">Login</button>
</form>

</body>
</html>