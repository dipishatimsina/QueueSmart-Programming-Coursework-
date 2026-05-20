<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Approval - QueueSmart</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f0f9ff; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 8px 36px rgba(14,165,233,0.13); text-align: center; max-width: 400px; border: 1.5px solid #bae6fd; }
        h2 { color: #0284c7; margin-top: 0; }
        p { color: #4b6280; font-size: 15px; line-height: 1.5; }
        .btn { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #0ea5e9; color: white; text-decoration: none; border-radius: 8px; font-weight: bold; transition: background 0.2s; }
        .btn:hover { background: #0284c7; }
        .icon { font-size: 48px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon">⏳</div>
        <h2>Pending Approval</h2>
        <p>Your account is awaiting admin approval. Please wait until your account is verified.</p>
        <a href="${pageContext.request.contextPath}/login" class="btn">Return to Login</a>
    </div>
</body>
</html>
