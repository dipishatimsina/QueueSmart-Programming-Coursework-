<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Customer Dashboard - QueueSmart</title>
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
    
    /* Live Queue Card specific */
    .queue-active-card { background: linear-gradient(135deg, var(--card), var(--inp)); border: 1px solid var(--sky); border-left: 6px solid var(--sky); }
    .pulse-text { animation: pulse 2s infinite; color: #f43f5e; font-weight: 800; }
    @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.5; } 100% { opacity: 1; } }
    
    progress { width: 100%; height: 12px; border-radius: 10px; overflow: hidden; appearance: none; -webkit-appearance: none; margin-top: 15px;}
    progress::-webkit-progress-bar { background-color: var(--bdr); border-radius: 10px; }
    progress::-webkit-progress-value { background: linear-gradient(90deg, #0ea5e9, #3b82f6); border-radius: 10px; transition: width 0.5s ease; }
    
    .btn { background: linear-gradient(135deg, #0ea5e9, #3b82f6); color: #fff; padding: 12px 24px; border: none; border-radius: 12px; cursor: pointer; text-decoration:none; font-size: 15px; font-weight: 700; transition: 0.3s; box-shadow: 0 4px 15px rgba(14,165,233,0.3); display: inline-block;}
    .btn:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(14,165,233,0.4); }
    
    .service-item { padding: 20px; border: 1px solid var(--bdr); border-radius: 16px; background: var(--inp); display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; transition: 0.3s; }
    .service-item:hover { border-color: var(--sky); box-shadow: 0 4px 15px rgba(14,165,233,0.1); }
    .service-item strong { font-size: 18px; display: block; margin-bottom: 4px; }
    .service-item p { color: var(--text2); font-size: 14px; }
    
    /* Digital Ticket */
    .digital-ticket { display: flex; align-items: center; justify-content: center; flex-direction: column; padding: 20px; border-left: 2px dashed var(--bdr); margin-left: 20px; }
    .qr-img { border-radius: 12px; border: 4px solid #fff; box-shadow: 0 8px 25px rgba(0,0,0,0.15); width: 110px; height: 110px; }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/customer/dashboard" class="nav-link active">✨ Dashboard</a>
  <a href="${pageContext.request.contextPath}/customer/wishlist" class="nav-link">❤️ My Wishlist</a>
  <a href="${pageContext.request.contextPath}/customer/profile" class="nav-link">👤 My Profile</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444; font-weight: 800;">🚪 Logout</a>
</div>

<div class="main">
  <div class="header-controls">
    <button class="btn-theme" onclick="toggleTheme()">🌓 Toggle Theme</button>
  </div>

  <div class="hero">
    <div class="hero-circles"></div>
    <h2>Welcome back, ${sessionScope.userName}! 👋</h2>
    <p>Skip the waiting room. Book services and track your queue in real-time.</p>
  </div>

  <c:if test="${not empty activeQueues}">
    <h3 style="margin-bottom: 20px; font-size: 24px;">Your Active Queues</h3>
    <div class="grid" style="margin-bottom: 40px;">
      <c:forEach var="q" items="${activeQueues}">
        <div class="card queue-active-card" style="display:flex; padding:0; overflow:hidden;">
          <div style="flex:1; padding: 30px;">
            <div style="font-weight:800; font-size:22px; margin-bottom:8px;">${q.serviceName}</div>
            <div style="display:flex; justify-content:space-between; margin-bottom:15px; border-bottom: 1px solid var(--bdr); padding-bottom: 15px;">
              <span style="color:var(--text2); font-size:15px;">Your Ticket Number:</span>
              <span style="font-weight:900; color:var(--sky-dk); font-size:20px;">#${q.queueNumber}</span>
            </div>
            
            <c:choose>
              <c:when test="${q.status == 'SERVING'}">
                 <div style="padding:15px; background:rgba(34, 197, 94, 0.1); color:#16a34a; border-radius:12px; text-align:center; font-weight:800; font-size: 18px; border: 1px solid #bbf7d0;">
                   ✨ It's your turn! Please approach the counter.
                 </div>
              </c:when>
              <c:otherwise>
                 <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                   <span style="color:var(--text2); font-size:15px;">People Ahead:</span>
                   <span class="pulse-text" id="ahead-${q.id}" style="font-size:20px;">${q.peopleAhead}</span>
                 </div>
                 <div style="display:flex; justify-content:space-between;">
                   <span style="color:var(--text2); font-size:15px;">Est. Wait Time:</span>
                   <span style="font-weight:800; color:#f59e0b; font-size:18px;" id="wait-${q.id}">~${q.estimatedWaitMinutes} mins</span>
                 </div>
                 <progress id="prog-${q.id}" value="${q.peopleAhead > 10 ? 10 : (10 - q.peopleAhead)}" max="10"></progress>
              </c:otherwise>
            </c:choose>
          </div>
          
          <!-- Digital Ticket QR Code -->
          <div class="digital-ticket">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=QueueSmart-Ticket-${q.id}-${q.queueNumber}&margin=1" alt="Digital Ticket QR" class="qr-img">
            <span style="font-size:12px; letter-spacing: 2px; color:var(--text2); margin-top:12px; font-weight:800;">VIP TICKET</span>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:if>

  <div class="grid">
    <div class="card">
      <h3 style="color: var(--sky-dk);">Available Services</h3>
      <p style="margin-bottom: 25px; color:var(--text2);">Find and book your next service effortlessly.</p>
      
      <div style="display:flex; flex-direction:column;">
        <c:forEach var="srv" items="${activeServices}">
          <div class="service-item">
            <div>
              <strong>${srv.serviceName}</strong>
              <p>${srv.category} &bull; $${srv.price}</p>
            </div>
            <div style="display:flex; gap: 10px;">
                <form action="${pageContext.request.contextPath}/customer/wishlist" method="POST">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="serviceId" value="${srv.id}">
                    <button type="submit" class="btn" style="background: var(--inp); color: #f43f5e; border: 1px solid rgba(244, 63, 94, 0.3); box-shadow: none;">❤️ Save</button>
                </form>
                <a href="${pageContext.request.contextPath}/customer/book?serviceId=${srv.id}" class="btn">Book Now</a>
            </div>
          </div>
        </c:forEach>
        <c:if test="${empty activeServices}">
          <div style="text-align:center; padding: 40px 20px; color:var(--text2);">
            <div style="font-size: 40px; margin-bottom: 10px;">🔍</div>
            <p>No services are currently available.</p>
          </div>
        </c:if>
      </div>
    </div>

    <div class="card">
      <h3>Your Past Services</h3>
      <p style="margin-bottom: 25px; color:var(--text2);">History of your completed queue appointments.</p>
      
      <div style="display:flex; flex-direction:column;">
        <c:forEach var="q" items="${pastQueues}">
          <div class="service-item" style="display:block;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 10px;">
              <strong>${q.serviceName}</strong>
              <span style="background: var(--sky-lt); color: var(--sky-dk); padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 800;">${q.status}</span>
            </div>
            <p style="font-size:13px;">Joined: <b>${q.joinedAt}</b> | Ticket: <b>#${q.queueNumber}</b></p>
            
            <c:if test="${q.status == 'COMPLETED'}">
              <a href="${pageContext.request.contextPath}/customer/feedback?serviceId=${q.serviceId}" class="btn" style="background: linear-gradient(135deg, #10b981, #059669); box-shadow: 0 4px 15px rgba(16,185,129,0.3); font-size: 13px; padding: 8px 16px; margin-top: 15px; display: inline-block; width: auto;">⭐ Rate this Service</a>
            </c:if>
          </div>
        </c:forEach>
        <c:if test="${empty pastQueues}">
          <p style="color:var(--text2); font-size:14px; text-align:center; padding: 20px;">No past services found.</p>
        </c:if>
      </div>
    </div>
    <div class="card">
      <h3 style="color: #f59e0b;">Your Feedback History</h3>
      <p style="margin-bottom: 25px; color:var(--text2);">Reviews you have submitted.</p>
      
      <div style="display:flex; flex-direction:column; gap: 15px;">
        <c:forEach var="f" items="${myFeedback}">
          <div style="padding:15px; border:1px solid var(--bdr); border-radius:12px; background:var(--inp);">
            <div style="display:flex; justify-content:space-between; margin-bottom:5px;">
              <strong>${f.serviceName}</strong>
              <span style="color:#f59e0b; font-size: 14px;"><c:forEach begin="1" end="${f.rating}">★</c:forEach></span>
            </div>
            <p style="font-size:12px; color:var(--text2); margin-bottom: 8px;">${f.createdAt}</p>
            <c:if test="${not empty f.comments}">
              <p style="font-size:14px; font-style:italic;">"${f.comments}"</p>
            </c:if>
          </div>
        </c:forEach>
        <c:if test="${empty myFeedback}">
          <p style="color:var(--text2); font-size:14px; text-align:center; padding: 20px;">You haven't left any feedback yet.</p>
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

  // Live AJAX Queue Tracking
  function fetchQueueUpdates() {
      fetch('${pageContext.request.contextPath}/api/customer/queue')
          .then(res => res.json())
          .then(data => {
              data.forEach(q => {
                  const elAhead = document.getElementById('ahead-' + q.id);
                  const elWait = document.getElementById('wait-' + q.id);
                  const elProg = document.getElementById('prog-' + q.id);
                  
                  if (elAhead && q.status === 'WAITING') {
                      elAhead.innerText = q.peopleAhead;
                      elWait.innerText = '~' + q.estimatedWait + ' mins';
                      let val = q.peopleAhead > 10 ? 10 : (10 - q.peopleAhead);
                      elProg.value = val;
                  } else if (q.status === 'SERVING') {
                      if (elAhead) location.reload();
                  }
              });
          })
          .catch(err => console.error("Error fetching live queue:", err));
  }
  
  <c:if test="${not empty activeQueues}">
      setInterval(fetchQueueUpdates, 5000);
  </c:if>
</script>
</body>
</html>
