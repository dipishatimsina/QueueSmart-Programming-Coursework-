<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>System Audit Logs - QueueSmart</title>
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
    body{font-family:'Segoe UI',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;}
    
    .sidebar { width: 260px; background: var(--card); border-right: 1.5px solid var(--bdr); padding: 20px; display:flex; flex-direction:column; }
    .logo { font-size: 20px; font-weight: 800; color: var(--sky-dk); text-decoration: none; display: flex; align-items: center; gap: 10px; margin-bottom: 40px; }
    .logo-box { width: 34px; height: 34px; background: var(--sky); border-radius: 8px; color: #fff; display: flex; align-items: center; justify-content: center; }
    .nav-link { padding: 12px 15px; border-radius: 10px; text-decoration: none; color: var(--text); font-weight: 600; margin-bottom: 5px; display: block; transition: .2s; }
    .nav-link:hover, .nav-link.active { background: var(--sky-lt); color: var(--sky-dk); }
    
    .main { flex: 1; padding: 30px; display:flex; flex-direction:column; overflow-y:auto;}
    .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    
    .card { background: var(--card); border: 1.5px solid var(--bdr); border-radius: var(--r); padding: 20px; box-shadow: var(--sh);}
    
    .log-box { background: #1e293b; color: #a5b4fc; padding: 20px; border-radius: 10px; font-family: monospace; font-size: 13px; height: 500px; overflow-y: auto; white-space: pre-wrap; line-height: 1.6;}
    .log-info { color: #34d399; }
    .log-error { color: #f87171; }

    @media print {
      body { background: #fff; color: #000; }
      .sidebar, .header-buttons { display: none !important; }
      .main { padding: 0; overflow: visible; display: block; }
      .card { box-shadow: none; border: none; padding: 0; }
      .log-box { height: auto; overflow: visible; background: #fff; color: #000; border: 1px solid #ccc; font-size: 11px; }
      .log-info { color: #000; }
      .log-error { color: #d00; font-weight: bold; }
    }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">Manage Users</a>
  <a href="${pageContext.request.contextPath}/admin/services" class="nav-link">Manage Services</a>
  <a href="${pageContext.request.contextPath}/admin/logs" class="nav-link active">System Audit Logs</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444;">Logout</a>
</div>

<div class="main">
  <div class="header">
    <h2>System Audit Logs</h2>
    <div class="header-buttons">
      <button class="btn btn-outline" onclick="window.print()" style="padding: 8px 16px; border: 1.5px solid var(--bdr); border-radius: 8px; background: transparent; color: var(--text); cursor: pointer; font-weight: bold; margin-right: 10px;">🖨️ Print Logs</button>
      <button class="btn btn-outline" onclick="location.reload()" style="padding: 8px 16px; border: 1.5px solid var(--bdr); border-radius: 8px; background: transparent; color: var(--text); cursor: pointer; font-weight: bold;">🔄 Refresh Logs</button>
    </div>
  </div>

  <div class="card">
    <h3 style="margin-bottom:15px;">Application Event Stream</h3>
    <div class="log-box">
<c:forEach var="line" items="${logs}">
  <c:choose>
    <c:when test="${line.contains('[INFO]')}"><span class="log-info">${line}</span></c:when>
    <c:when test="${line.contains('[ERROR]')}"><span class="log-error">${line}</span></c:when>
    <c:otherwise>${line}</c:otherwise>
  </c:choose>
</c:forEach>
    </div>
  </div>
</div>

<script>
  var th = localStorage.getItem('qs_theme') || 'light';
  document.documentElement.setAttribute('data-theme', th);
</script>
</body>
</html>
