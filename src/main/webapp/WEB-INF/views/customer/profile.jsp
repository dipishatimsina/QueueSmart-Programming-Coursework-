<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Profile - QueueSmart</title>
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
    .header-controls { position: absolute; top: 40px; right: 40px; z-index: 10; }
    .btn-theme { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); color: var(--text); padding: 10px 20px; border-radius: 30px; cursor: pointer; font-weight: 600; font-family: 'Outfit'; box-shadow: var(--sh); transition: 0.3s; }
    .btn-theme:hover { transform: translateY(-2px); }

    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 30px; max-width: 900px; }
    .card { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); border-radius: var(--r); padding: 30px; box-shadow: var(--sh); }
    .card h3 { font-size: 22px; font-weight: 800; margin-bottom: 5px; color: var(--text); }
    
    .fg { margin-bottom: 20px; }
    .fg label { display: block; margin-bottom: 8px; font-size: 14px; font-weight: 600; color: var(--text2); }
    .fg input { width: 100%; padding: 14px; border: 1px solid var(--bdr); border-radius: 12px; background: var(--inp); color: var(--text); font-family: 'Outfit'; font-size: 15px; transition: 0.3s;}
    .fg input:focus { outline: none; border-color: var(--sky); box-shadow: 0 0 0 4px rgba(14,165,233,0.1); }
    
    .btn { background: linear-gradient(135deg, #0ea5e9, #3b82f6); color: #fff; padding: 14px 24px; border: none; border-radius: 12px; cursor: pointer; text-decoration:none; font-size: 15px; font-weight: 700; transition: 0.3s; box-shadow: 0 4px 15px rgba(14,165,233,0.3); width: 100%;}
    .btn:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(14,165,233,0.4); }
    
    .al { padding: 15px; border-radius: 12px; margin-bottom: 25px; font-weight: 600; font-size: 14px; }
    .al.ok { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
    .al.err { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/customer/dashboard" class="nav-link">✨ Dashboard</a>
  <a href="${pageContext.request.contextPath}/customer/profile" class="nav-link active">👤 My Profile</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444; font-weight: 800;">🚪 Logout</a>
</div>

<div class="main">
  <div class="header-controls">
    <button class="btn-theme" onclick="toggleTheme()">🌓 Toggle Theme</button>
  </div>

  <h2 style="font-size: 36px; font-weight: 800; margin-bottom: 10px;">My Profile</h2>
  <p style="color: var(--text2); margin-bottom: 40px; font-size: 16px;">Manage your personal information and security settings.</p>

  <c:if test="${not empty successMsg}"><div class="al ok">${successMsg}</div></c:if>
  <c:if test="${not empty errorMsg}"><div class="al err">${errorMsg}</div></c:if>

  <div class="grid">
    <!-- Profile Details Card -->
    <div class="card">
      <h3 style="color: var(--sky-dk); margin-bottom: 25px;">Personal Details</h3>
      <form action="${pageContext.request.contextPath}/customer/profile" method="POST">
        <input type="hidden" name="action" value="updateDetails">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        
        <div class="fg">
          <label>Full Name</label>
          <input type="text" name="fullName" value="${user.fullName}" required>
        </div>
        <div class="fg">
          <label>Email Address</label>
          <input type="email" value="${user.email}" disabled style="opacity:0.7; cursor:not-allowed;">
        </div>
        <div class="fg">
          <label>Phone Number</label>
          <input type="text" name="phone" value="${user.phone}" required>
        </div>
        
        <button type="submit" class="btn">Save Changes</button>
      </form>
    </div>

    <!-- Security Card -->
    <div class="card">
      <h3 style="color: #f43f5e; margin-bottom: 25px;">Security Settings</h3>
      <form action="${pageContext.request.contextPath}/customer/profile" method="POST">
        <input type="hidden" name="action" value="updatePassword">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        
        <div class="fg">
          <label>New Password</label>
          <input type="password" name="newPassword" placeholder="Enter new password" required>
        </div>
        <div class="fg">
          <p style="font-size:12px; color:var(--text2); line-height: 1.5;">
            Password must be at least 8 characters long, containing uppercase, lowercase, numbers, and special characters.
          </p>
        </div>
        
        <button type="submit" class="btn" style="background: linear-gradient(135deg, #f43f5e, #e11d48); box-shadow: 0 4px 15px rgba(244,63,94,0.3);">Update Password</button>
      </form>
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
