<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Reset Password - QueueSmart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    body { display: flex; justify-content: center; align-items: center; min-height: 100vh; background: #f0f9ff; font-family: 'Segoe UI', sans-serif; }
    .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 8px 36px rgba(14,165,233,0.13); width: 100%; max-width: 400px; text-align: center; }
    .fg { margin-bottom: 15px; }
    input { width: 100%; padding: 12px; border: 1.5px solid #bae6fd; border-radius: 10px; box-sizing: border-box; }
    .btn { width: 100%; padding: 12px; background: #0ea5e9; color: white; border: none; border-radius: 10px; cursor: pointer; font-weight: bold; }
    .btn:hover { background: #0284c7; }
    .err { color: red; margin-bottom: 15px; }
  </style>
</head>
<body>
  <div class="card">
    <h2>Reset Password</h2>
    
    <c:if test="${not empty param.error}">
        <div class="err">${param.error}</div>
    </c:if>

    <c:choose>
        <c:when test="${param.step == 'reset'}">
            <p>Enter your new password below.</p>
            <form action="${pageContext.request.contextPath}/resetPassword" method="POST">
                <div class="fg">
                    <input type="password" name="newPassword" placeholder="New Password" required minlength="6">
                </div>
                <button type="submit" class="btn">Update Password</button>
            </form>
        </c:when>

        <c:when test="${param.step == 'verify'}">
            <p>We've sent a 6-digit code to your email.</p>
            <form action="${pageContext.request.contextPath}/verifyReset" method="POST">
                <div class="fg">
                    <input type="text" name="code" placeholder="6-digit code" required maxlength="6">
                </div>
                <button type="submit" class="btn">Verify Code</button>
            </form>
        </c:when>

        <c:otherwise>
            <p>Enter your email to receive a reset code.</p>
            <form action="${pageContext.request.contextPath}/forgotPassword" method="POST">
                <div class="fg">
                    <input type="email" name="email" placeholder="Email Address" required>
                </div>
                <button type="submit" class="btn">Send Code</button>
            </form>
        </c:otherwise>
    </c:choose>

    <br>
    <a href="${pageContext.request.contextPath}/index.jsp" style="color: #0ea5e9; text-decoration: none; font-size: 14px;">Back to Login</a>
  </div>
</body>
</html>
