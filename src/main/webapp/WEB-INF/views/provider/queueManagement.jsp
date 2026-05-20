<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Queue Command Center - QueueSmart</title>
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
    .header-controls { position: absolute; top: 40px; right: 40px; z-index: 10; display:flex; gap:10px; align-items:center; }
    
    .btn-theme { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); color: var(--text); padding: 10px 20px; border-radius: 30px; cursor: pointer; font-weight: 600; font-family: 'Outfit'; box-shadow: var(--sh); transition: 0.3s; }
    .btn-theme:hover { transform: translateY(-2px); }
    
    .back-btn { color: var(--sky-dk); text-decoration: none; font-weight: 800; font-size: 16px; padding: 10px 20px; background: var(--sky-lt); border-radius: 30px; transition: 0.3s;}
    .back-btn:hover { background: rgba(14, 165, 233, 0.2); }

    .card { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); border-radius: var(--r); padding: 40px; box-shadow: var(--sh); max-width: 900px; margin: 0 auto; width: 100%;}
    .card h3 { font-size: 28px; font-weight: 800; margin-bottom: 10px; color: var(--text); }
    
    .q-item { padding: 25px; border: 1px solid var(--bdr); border-radius: 16px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; background: var(--inp); transition: all 0.3s ease; box-shadow: 0 4px 10px rgba(0,0,0,0.02);}
    .q-item:hover { border-color: var(--sky); transform: translateY(-2px); box-shadow: 0 8px 25px rgba(14,165,233,0.15);}
    
    .q-item.SERVING { border-color: #10b981; background: rgba(16, 185, 129, 0.05); box-shadow: 0 0 0 2px rgba(16,185,129,0.3); animation: pulse-border 2s infinite;}
    @keyframes pulse-border { 0% { box-shadow: 0 0 0 0 rgba(16,185,129,0.4); } 70% { box-shadow: 0 0 0 10px rgba(16,185,129,0); } 100% { box-shadow: 0 0 0 0 rgba(16,185,129,0); } }
    
    .q-num { font-size: 32px; font-weight: 900; color: var(--sky-dk); width: 70px; }
    .SERVING .q-num { color: #10b981; }
    
    .q-info { flex: 1; padding-left: 15px; border-left: 2px dashed var(--bdr);}
    .q-info strong { font-size: 20px; color: var(--text); font-weight: 800; display: block; margin-bottom: 5px;}
    .q-info p { font-size: 14px; color: var(--text2); font-weight: 600;}
    
    .q-actions { display: flex; gap: 10px;}
    .btn { padding: 12px 20px; font-size: 14px; font-weight: 800; border-radius: 12px; border: none; cursor: pointer; color: #fff; transition: 0.3s; box-shadow: 0 4px 15px rgba(0,0,0,0.1); font-family: 'Outfit';}
    .btn:hover { transform: translateY(-2px); }
    .btn:disabled { opacity: 0.7; cursor: not-allowed; transform: none; }
    
    .btn-serve { background: linear-gradient(135deg, #0ea5e9, #3b82f6); box-shadow: 0 4px 15px rgba(14,165,233,0.3); }
    .btn-serve:hover { box-shadow: 0 6px 20px rgba(14,165,233,0.4); }
    
    .btn-complete { background: linear-gradient(135deg, #10b981, #059669); box-shadow: 0 4px 15px rgba(16,185,129,0.3); }
    .btn-complete:hover { box-shadow: 0 6px 20px rgba(16,185,129,0.4); }
    
    .btn-skip { background: transparent; border: 2px solid #ef4444; color: #ef4444; box-shadow: none; }
    .btn-skip:hover { background: #ef4444; color: white; }
    
    .badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 800; text-transform: uppercase; margin-right: 10px;}
    .badge-WAITING { background: #fef9c3; color: #854d0e; border: 1px solid #fef08a;}
    .badge-SERVING { background: #dcfce7; color: #16a34a; border: 1px solid #bbf7d0;}
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/provider/dashboard" class="nav-link">✨ Overview</a>
  <a href="${pageContext.request.contextPath}/provider/services" class="nav-link active">📋 Command Center</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444; font-weight:800;">🚪 Logout</a>
</div>

<div class="main">
  <div class="header-controls">
    <a href="${pageContext.request.contextPath}/provider/dashboard" class="back-btn">&larr; Back to Dashboard</a>
    <button class="btn-theme" onclick="toggleTheme()">🌓 Theme</button>
  </div>

  <div style="text-align: center; margin-bottom: 40px; margin-top: 20px;">
    <div style="display:inline-block; padding: 10px 20px; background: var(--sky-lt); color: var(--sky-dk); border-radius: 30px; font-weight: 800; margin-bottom: 15px; border: 1px solid var(--bdr);">🟢 LIVE SYSTEM ACTIVE</div>
    <h2 style="font-size: 42px; font-weight: 800; color: var(--text);">Queue Command Center</h2>
    <p style="font-size: 18px; color: var(--text2);">Manage and transition your active customers in real-time.</p>
  </div>

  <div class="card">
    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom: 2px solid var(--bdr); padding-bottom: 20px; margin-bottom: 30px;">
        <h3>Current Lineup</h3>
        <span style="font-size: 14px; color: var(--text2); font-weight: 600;">Updates automatically via AJAX</span>
    </div>
    
    <c:forEach var="q" items="${queueEntries}">
      <c:if test="${q.status == 'WAITING' || q.status == 'SERVING'}">
        <div class="q-item ${q.status}" id="qitem-${q.id}">
          <div class="q-num">#${q.queueNumber}</div>
          <div class="q-info">
            <strong>${q.customerName}</strong>
            <p><span class="badge badge-${q.status}">${q.status}</span> Joined at ${q.joinedAt}</p>
          </div>
          <div class="q-actions">
            <c:if test="${q.status == 'WAITING'}">
                <button type="button" class="btn btn-serve" onclick="updateStatus(${q.id}, 'SERVING', this)">🔔 Call Next</button>
                <button type="button" class="btn btn-skip" onclick="updateStatus(${q.id}, 'SKIPPED', this)">Skip</button>
            </c:if>
            <c:if test="${q.status == 'SERVING'}">
                <button type="button" class="btn btn-complete" onclick="updateStatus(${q.id}, 'COMPLETED', this)">✅ Mark Complete</button>
            </c:if>
          </div>
        </div>
      </c:if>
    </c:forEach>
    <c:if test="${empty queueEntries}">
      <div style="text-align:center; padding:50px; color:var(--text2);">
        <div style="font-size: 50px; margin-bottom: 20px; opacity:0.5;">☕</div>
        <h4 style="font-size: 24px; font-weight: 800; color: var(--text);">The queue is empty</h4>
        <p>Time for a quick break! Customers will appear here when they join.</p>
      </div>
    </c:if>
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

  function updateStatus(queueId, status, btnElement) {
      btnElement.disabled = true;
      let originalText = btnElement.innerText;
      btnElement.innerText = "Processing...";

      const formData = new URLSearchParams();
      formData.append("queueId", queueId);
      formData.append("status", status);

      fetch('${pageContext.request.contextPath}/api/provider/queue/update', {
          method: 'POST',
          headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: formData.toString()
      })
      .then(res => res.json())
      .then(data => {
          if (data.success) {
              const itemDiv = document.getElementById('qitem-' + queueId);
              itemDiv.style.transform = 'translateX(20px)';
              itemDiv.style.opacity = '0';
              setTimeout(() => {
                  location.reload(); 
              }, 400);
          } else {
              alert("Failed to update status.");
              btnElement.disabled = false;
              btnElement.innerText = originalText;
          }
      })
      .catch(err => {
          console.error("AJAX error", err);
          btnElement.disabled = false;
          btnElement.innerText = originalText;
      });
  }
</script>
</body>
</html>
