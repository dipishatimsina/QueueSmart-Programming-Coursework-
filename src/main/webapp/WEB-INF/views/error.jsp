<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Error - QueueSmart</title>
  <style>
    :root {
      --sky:#0ea5e9; --bg:#f0f9ff; --card:#fff; --text:#0c1a2e; --text2:#4b6280; --bdr:#bae6fd;
    }
    [data-theme="dark"]{
      --bg:#071520; --card:#0d2137; --text:#e2f0fb; --text2:#7aabcc; --bdr:#1e4060;
    }
    body{font-family:'Segoe UI',sans-serif;background:var(--bg);color:var(--text);display:flex;align-items:center;justify-content:center;height:100vh;margin:0;}
    .card { background: var(--card); border: 1.5px solid var(--bdr); border-radius: 16px; padding: 40px; text-align: center; max-width: 400px; box-shadow: 0 8px 36px rgba(0,0,0,0.1); }
    h1 { color: #ef4444; margin-bottom: 10px; }
    p { color: var(--text2); margin-bottom: 20px; }
    a { display: inline-block; background: var(--sky); color: #fff; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 700; }
  </style>
</head>
<body>
  <div class="card">
    <h1>${not empty errorTitle ? errorTitle : "Oops!"}</h1>
    <p>${not empty errorMessage ? errorMessage : "Something went wrong."}</p>
    <a href="${pageContext.request.contextPath}/login">Go Home</a>
  </div>
  <script>
    var th = localStorage.getItem('qs_theme') || 'light';
    document.documentElement.setAttribute('data-theme', th);
  </script>
</body>
</html>
