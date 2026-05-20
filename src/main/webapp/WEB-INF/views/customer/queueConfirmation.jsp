<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Queue Confirmation - QueueSmart</title>
  <style>
    :root {
      --sky:#0ea5e9; --sky-dk:#0284c7; --sky-lt:#e0f2fe;
      --bg:#f0f9ff; --card:#fff; --text:#0c1a2e; --text2:#4b6280;
      --bdr:#bae6fd; --inp:#f8fbff;
      --sh:0 8px 36px rgba(14,165,233,0.13);
      --r:16px;
    }
    [data-theme="dark"]{
      --bg:#071520; --card:#0d2137; --text:#e2f0fb; --text2:#7aabcc;
      --bdr:#1e4060; --inp:#0a1e30; --sky-lt:#0a1e30;
    }
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Segoe UI',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;align-items:center;justify-content:center;}
    
    .card { width: 100%; max-width: 450px; background: var(--card); border: 1.5px solid var(--bdr); border-radius: var(--r); padding: 40px; box-shadow: var(--sh); text-align:center; }
    
    h2 { color: var(--sky-dk); margin-bottom: 10px; }
    .q-number { font-size: 64px; font-weight: 900; color: var(--sky); margin: 20px 0; }
    .info { font-size: 16px; color: var(--text2); margin-bottom: 30px; }
    
    .btn { display: inline-block; background: var(--sky); color: #fff; padding: 12px 24px; border: none; border-radius: 10px; cursor: pointer; text-decoration:none; font-size: 15px; font-weight: 700; transition:.2s;}
    .btn:hover { background: var(--sky-dk); }
  </style>
</head>
<body>

<div class="card">
  <h2>You're in the Queue!</h2>
  <p style="color:var(--text2);">Your queue number for <strong>${service.serviceName}</strong> is:</p>
  
  <div class="q-number">#${queueEntry.queueNumber}</div>
  
  <div class="info">
    <p>Estimated Wait Time: <strong>${queueEntry.estimatedWaitMinutes} mins</strong></p>
    <p>Please wait for your number to be called.</p>
  </div>
  
  <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn">Return to Dashboard</a>
</div>

<script>
  var th = localStorage.getItem('qs_theme') || 'light';
  document.documentElement.setAttribute('data-theme', th);
</script>
</body>
</html>
