<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Provider Dashboard - QueueSmart</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap');
    
    :root {
      --sky:#0ea5e9; --sky-dk:#0284c7; --sky-lt:#e0f2fe;
      --bg: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
      --card: rgba(255, 255, 255, 0.8);
      --card-blur: blur(12px);
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
    
    .hero { background: linear-gradient(135deg, #0ea5e9, #6366f1); border-radius: var(--r); padding: 40px; color: white; margin-bottom: 30px; box-shadow: 0 15px 35px rgba(99, 102, 241, 0.2); position: relative; overflow: hidden; }
    .hero h2 { font-size: 32px; font-weight: 800; margin-bottom: 10px; position: relative; z-index: 2;}
    .hero p { font-size: 16px; opacity: 0.9; position: relative; z-index: 2;}
    .hero-circles { position: absolute; top: -50px; right: -50px; width: 200px; height: 200px; background: rgba(255,255,255,0.1); border-radius: 50%; filter: blur(20px); }
    
    .header-controls { position: absolute; top: 40px; right: 40px; z-index: 10; }
    .btn-theme { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); color: var(--text); padding: 10px 20px; border-radius: 30px; cursor: pointer; font-weight: 600; font-family: 'Outfit'; box-shadow: var(--sh); transition: 0.3s; }
    .btn-theme:hover { transform: translateY(-2px); }

    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 30px; margin-bottom: 40px; }
    .card { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); border-radius: var(--r); padding: 30px; box-shadow: var(--sh); transition: transform 0.3s ease; }
    .card:hover { transform: translateY(-5px); }
    .card h3 { font-size: 22px; font-weight: 800; margin-bottom: 5px; color: var(--text); }
    
    .btn { background: linear-gradient(135deg, #0ea5e9, #3b82f6); color: #fff; padding: 12px 24px; border: none; border-radius: 12px; cursor: pointer; text-decoration:none; font-size: 15px; font-weight: 700; transition: 0.3s; box-shadow: 0 4px 15px rgba(14,165,233,0.3); display: inline-block;}
    .btn:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(14,165,233,0.4); }
    
    .service-item { padding: 20px; border: 1px solid var(--bdr); border-radius: 16px; background: var(--inp); display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; transition: 0.3s; border-left: 5px solid var(--sky);}
    .service-item:hover { border-color: var(--sky); box-shadow: 0 4px 15px rgba(14,165,233,0.1); }
    .service-item strong { font-size: 18px; display: block; margin-bottom: 4px; }
    
    .feedback-card { background: var(--inp); border: 1px solid var(--bdr); padding: 20px; border-radius: 16px; margin-bottom: 15px; }
    .feedback-card .stars { color: #f59e0b; font-size: 18px; margin-bottom: 5px;}
    .feedback-card .comment { font-size: 15px; color: var(--text); font-style: italic; background: rgba(0,0,0,0.03); padding: 12px; border-radius: 8px; margin-top: 10px; border-left: 3px solid #10b981;}
    [data-theme="dark"] .feedback-card .comment { background: rgba(255,255,255,0.05); }

    .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 800; }
    .badge.ACTIVE { background: rgba(34, 197, 94, 0.1); color: #16a34a; border: 1px solid #bbf7d0;}
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/provider/dashboard" class="nav-link active">✨ Overview</a>
  <a href="${pageContext.request.contextPath}/provider/services" class="nav-link">📋 My Services</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444; font-weight:800;">🚪 Logout</a>
</div>

<div class="main">
  <div class="header-controls">
    <button class="btn-theme" onclick="toggleTheme()">🌓 Toggle Theme</button>
  </div>

  <div class="hero">
    <div class="hero-circles"></div>
    <h2>Provider Hub</h2>
    <p>Welcome back, ${sessionScope.userName}. Manage your queues and monitor customer feedback.</p>
  </div>

  <div class="grid">
    <div class="card" style="grid-column: span 2;">
      <h3 style="color: var(--sky-dk);">Active Services</h3>
      <p style="margin-bottom: 25px; color:var(--text2);">Control the flow of your active queues.</p>
      
      <div style="display:flex; flex-direction:column;">
        <c:forEach var="srv" items="${myServices}">
          <c:if test="${srv.status == 'ACTIVE'}">
            <div class="service-item">
              <div>
                <strong>${srv.serviceName}</strong>
                <span class="badge ACTIVE">LIVE QUEUE</span>
              </div>
              <a href="${pageContext.request.contextPath}/provider/queue?serviceId=${srv.id}" class="btn">🚀 Enter Command Center</a>
            </div>
          </c:if>
        </c:forEach>
        <c:if test="${empty myServices}">
          <div style="text-align:center; padding: 30px; color:var(--text2);">
            <div style="font-size: 40px; margin-bottom: 10px;">📋</div>
            <p>You have no active services. <a href="${pageContext.request.contextPath}/provider/services?action=new" style="color:var(--sky); font-weight:bold;">Create one now</a>.</p>
          </div>
        </c:if>
      </div>
    </div>
  </div>

  <div class="grid">
    <div class="card">
      <h3 style="color: #0ea5e9;">Recent Feedback</h3>
      <p style="margin-bottom: 25px; color:var(--text2);">See what customers are saying.</p>
      
      <div style="display:flex; flex-direction:column;">
        <c:forEach var="f" items="${recentFeedback}">
          <div class="feedback-card">
            <div style="display:flex; justify-content:space-between; align-items:center;">
              <strong style="font-size: 16px;">${f.customerName}</strong>
              <div class="stars"><c:forEach begin="1" end="${f.rating}">★</c:forEach></div>
            </div>
            <p style="font-size:12px; color:var(--text2); margin-top:4px;">${f.serviceName} &bull; ${f.createdAt}</p>
            <c:if test="${not empty f.comments}">
              <div class="comment">"${f.comments}"</div>
            </c:if>
          </div>
        </c:forEach>
        <c:if test="${empty recentFeedback}">
          <div style="text-align:center; padding: 20px; color:var(--text2);">
            <p>No feedback received yet.</p>
          </div>
        </c:if>
      </div>
    </div>
    
    <div class="card">
      <h3 style="color: #8b5cf6;">Pending Appointments</h3>
      <p style="margin-bottom: 25px; color:var(--text2);">Customers waiting for manual confirmation.</p>
      
      <div style="display:flex; flex-direction:column; gap:10px;">
        <c:forEach var="b" items="${pendingBookings}">
          <div style="padding:15px; border:1px solid var(--bdr); border-radius:12px; background:var(--inp);">
            <strong style="font-size: 16px;">Booking #${b.id}</strong>
            <p style="font-size:13px; color:var(--text2); margin-top:5px;">Date: <b>${b.bookingDate}</b> | Time: <b>${b.timeSlot}</b></p>
          </div>
        </c:forEach>
        <c:if test="${empty pendingBookings}">
          <div style="text-align:center; padding: 20px; color:var(--text2);">
            <p>No pending bookings.</p>
          </div>
        </c:if>
      </div>
    </div>
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
