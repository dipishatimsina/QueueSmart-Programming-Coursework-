<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Book Service - QueueSmart</title>
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
      --r: 24px;
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
    
    .main { flex: 1; padding: 40px; display:flex; flex-direction:column; align-items:center; overflow-y:auto; position: relative;}
    
    .header-controls { position: absolute; top: 40px; right: 40px; z-index: 10; display:flex; gap:10px;}
    .btn-theme { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); color: var(--text); padding: 10px 20px; border-radius: 30px; cursor: pointer; font-weight: 600; font-family: 'Outfit'; box-shadow: var(--sh); transition: 0.3s; }
    .btn-theme:hover { transform: translateY(-2px); }

    .header { width: 100%; max-width: 600px; margin-bottom: 30px; }
    
    .card { width: 100%; max-width: 600px; background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); border-radius: var(--r); padding: 40px; box-shadow: var(--sh); animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);}
    @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

    .fg { margin-bottom: 20px; }
    .fg label { display: block; margin-bottom: 8px; font-size: 14px; font-weight: 600; color: var(--text2); }
    .fg input, .fg select, .fg textarea { width: 100%; padding: 14px; border: 2px solid var(--bdr); border-radius: 12px; background: var(--inp); color: var(--text); font-family: 'Outfit'; font-size: 15px; transition: 0.3s; outline: none;}
    .fg input:focus, .fg select:focus, .fg textarea:focus { border-color: var(--sky); box-shadow: 0 0 0 4px rgba(14,165,233,0.15); }
    
    .btn { background: linear-gradient(135deg, #0ea5e9, #3b82f6); color: #fff; padding: 16px; border: none; border-radius: 14px; cursor: pointer; font-size: 16px; font-weight: 800; transition: 0.3s; width: 100%; box-shadow: 0 8px 20px rgba(14,165,233,0.3); margin-top: 10px;}
    .btn:hover { transform: translateY(-3px); box-shadow: 0 12px 25px rgba(14,165,233,0.4); }
    
    .alert { padding:15px; border-radius:12px; margin-bottom:20px; font-weight:600; font-size: 14px;}
    .alert.error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/customer/dashboard" class="nav-link active">✨ Dashboard</a>
  <a href="${pageContext.request.contextPath}/customer/profile" class="nav-link">👤 My Profile</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444; font-weight:800;">🚪 Logout</a>
</div>

<div class="main">
  <div class="header-controls">
    <button class="btn-theme" onclick="toggleTheme()">🌓 Toggle Theme</button>
  </div>

  <div class="header">
    <h2 style="font-size: 32px; font-weight: 800; color: var(--text);">Book Service</h2>
  </div>

  <div class="card">
    <h3 style="font-size: 24px; font-weight: 800; margin-bottom: 10px;">${service.serviceName}</h3>
    <p style="color:var(--text2); margin-bottom:30px; font-size: 15px;">${service.description}</p>
    
    <c:if test="${not empty errorMsg}">
      <div class="alert error">${errorMsg}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/customer/book" method="POST">
      <input type="hidden" name="serviceId" value="${service.id}">
      
      <div class="fg">
        <label>Booking Type</label>
        <select name="bookingType" id="bType" onchange="toggleApptFields()" required>
          <option value="walkin">Walk-in (Join queue now)</option>
          <option value="appointment">Schedule Appointment</option>
        </select>
      </div>
      
      <div id="apptFields" style="display:none; gap:15px;">
        <div class="fg" style="flex:1;">
          <label>Date</label>
          <input type="date" name="bookingDate" id="bDate">
        </div>
        <div class="fg" style="flex:1;">
          <label>Time</label>
          <input type="time" name="timeSlot" id="bTime">
        </div>
      </div>
      
      <div class="fg">
        <label>Notes (Optional)</label>
        <textarea name="notes" rows="3" placeholder="Any special requests?"></textarea>
      </div>
      
      <button type="submit" class="btn">Confirm Booking</button>
      <div style="text-align:center; margin-top:20px;">
        <a href="${pageContext.request.contextPath}/customer/dashboard" style="color:var(--text2); font-size:14px; text-decoration:none; font-weight:600;">Cancel</a>
      </div>
    </form>
  </div>
</div>
<script>
  function toggleApptFields() {
    var type = document.getElementById('bType').value;
    var f = document.getElementById('apptFields');
    if (type === 'appointment') {
      f.style.display = 'flex';
      document.getElementById('bDate').required = true;
      document.getElementById('bTime').required = true;
    } else {
      f.style.display = 'none';
      document.getElementById('bDate').required = false;
      document.getElementById('bTime').required = false;
    }
  }
  var th = localStorage.getItem('qs_theme') || 'light';
  document.documentElement.setAttribute('data-theme', th);
</script>
</body>
</html>
