<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Services - QueueSmart</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap');
    
    :root {
      --sky:#0ea5e9; --sky-dk:#0284c7; --sky-lt:#e0f2fe;
      --bg: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
      --card: rgba(255, 255, 255, 0.85);
      --card-blur: blur(20px);
      --text:#0f172a; --text2:#475569;
      --bdr: rgba(255, 255, 255, 0.5);
      --inp: rgba(255, 255, 255, 0.9);
      --sh: 0 10px 40px rgba(14, 165, 233, 0.1);
      --r: 20px;
    }
    [data-theme="dark"]{
      --bg: linear-gradient(135deg, #0f172a 0%, #020617 100%);
      --card: rgba(30, 41, 59, 0.7);
      --text:#f8fafc; --text2:#94a3b8;
      --bdr: rgba(255, 255, 255, 0.05);
      --inp: rgba(15, 23, 42, 0.8);
      --sky-lt:#1e3a5f;
    }
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Outfit',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;}
    
    .sidebar { width: 280px; background: var(--card); backdrop-filter: var(--card-blur); border-right: 1px solid var(--bdr); padding: 30px 20px; display:flex; flex-direction:column; z-index:10;}
    .logo { font-size: 24px; font-weight: 800; color: var(--sky-dk); text-decoration: none; display: flex; align-items: center; gap: 12px; margin-bottom: 50px; }
    .logo-box { width: 40px; height: 40px; background: linear-gradient(135deg, #0ea5e9, #3b82f6); border-radius: 12px; color: #fff; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 15px rgba(14,165,233,0.3); }
    .nav-link { padding: 14px 18px; border-radius: 12px; text-decoration: none; color: var(--text2); font-weight: 600; margin-bottom: 8px; display: block; transition: all 0.3s ease; }
    .nav-link:hover, .nav-link.active { background: var(--sky-lt); color: var(--sky-dk); transform: translateX(5px); }
    
    .main { flex: 1; padding: 40px; display:flex; flex-direction:column; overflow-y:auto; position: relative; z-index:1;}
    .btn-theme { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); color: var(--text); padding: 10px 20px; border-radius: 30px; cursor: pointer; font-weight: 600; font-family: 'Outfit'; box-shadow: var(--sh); transition: 0.3s; }
    .btn-theme:hover { transform: translateY(-2px); }
    
    .card { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); border-radius: var(--r); padding: 30px; box-shadow: var(--sh); overflow:hidden;}
    
    table { width: 100%; border-collapse: collapse; margin-top: 10px;}
    th, td { padding: 15px; text-align: left; border-bottom: 1px solid var(--bdr); }
    th { color: var(--text2); font-weight: 800; text-transform: uppercase; font-size: 13px; letter-spacing: 1px;}
    td { font-size: 15px; font-weight: 500;}
    tr:last-child td { border-bottom: none; }
    
    .btn { background: linear-gradient(135deg, #0ea5e9, #3b82f6); color: #fff; padding: 12px 24px; border: none; border-radius: 12px; cursor: pointer; text-decoration:none; font-size: 15px; font-weight: 800; display:inline-block; transition: 0.3s; box-shadow: 0 4px 15px rgba(14,165,233,0.3);}
    .btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(14,165,233,0.4); }
    .btn-err { background: linear-gradient(135deg, #ef4444, #dc2626); box-shadow: 0 4px 15px rgba(239,68,68,0.3); padding: 8px 16px; font-size: 13px;}
    .btn-err:hover { box-shadow: 0 8px 20px rgba(239,68,68,0.4); }

    .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 800; }
    .badge.ACTIVE { background: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid rgba(16,185,129,0.2);}
    .badge.PENDING_APPROVAL { background: rgba(245, 158, 11, 0.1); color: #f59e0b; border: 1px solid rgba(245,158,11,0.2);}
    .badge.INACTIVE { background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239,68,68,0.2);}
    
    .alert { padding:15px; border-radius:12px; margin-bottom:25px; font-weight:600; font-size: 14px;}
    .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
    .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/provider/dashboard" class="nav-link">✨ Dashboard</a>
  <a href="${pageContext.request.contextPath}/provider/queue" class="nav-link">🎯 Command Center</a>
  <a href="${pageContext.request.contextPath}/provider/services" class="nav-link active">📋 My Services</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444; font-weight:800;">🚪 Logout</a>
</div>

<div class="main">
  <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 30px;">
    <div>
        <h2 style="font-size: 36px; font-weight: 800; margin-bottom: 10px;">My Services</h2>
        <p style="color: var(--text2); font-size: 16px;">Manage the services you offer to customers.</p>
    </div>
    <div style="display:flex; align-items:center; gap: 15px;">
        <button class="btn-theme" onclick="toggleTheme()">🌓 Toggle Theme</button>
        <a href="${pageContext.request.contextPath}/provider/services?action=new" class="btn">+ Create New Service</a>
    </div>
  </div>

  <c:if test="${param.success == 'created'}">
    <div class="alert alert-success">Service created successfully! Pending admin approval.</div>
  </c:if>
  <c:if test="${param.success == 'deleted'}">
    <div class="alert alert-success">Service deleted successfully.</div>
  </c:if>

  <div class="card">
    <table>
      <thead>
        <tr>
          <th>Service Name</th>
          <th>Category</th>
          <th>Price</th>
          <th>Capacity</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="srv" items="${services}">
          <tr>
            <td><strong>${srv.serviceName}</strong></td>
            <td><span style="background:var(--inp); padding:4px 8px; border-radius:6px; font-size:12px; font-weight:800; border:1px solid var(--bdr);">${srv.category}</span></td>
            <td style="color:#10b981; font-weight:800;">$${srv.price}</td>
            <td style="color:var(--text2);">${srv.capacityPerSlot} slots</td>
            <td><span class="badge ${srv.status}">${srv.status}</span></td>
            <td>
              <form action="${pageContext.request.contextPath}/provider/services" method="POST" style="display:inline;">
                <input type="hidden" name="serviceId" value="${srv.id}">
                <button type="submit" name="action" value="delete" class="btn btn-err" onclick="return confirm('Delete this service permanently?')">Delete</button>
              </form>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty services}">
          <tr>
            <td colspan="6" style="text-align:center; padding: 40px; color:var(--text2); font-size: 16px;">
              <div style="font-size: 40px; margin-bottom: 15px;">🔍</div>
              You haven't created any services yet.<br>Click "Create New Service" to get started.
            </td>
          </tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>
<script>
  function toggleTheme() {
    var th = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', th);
    localStorage.setItem('qs_theme', th);
  }
  var th = localStorage.getItem('qs_theme') || 'light';
  document.documentElement.setAttribute('data-theme', th);
</script>
</body>
</html>
