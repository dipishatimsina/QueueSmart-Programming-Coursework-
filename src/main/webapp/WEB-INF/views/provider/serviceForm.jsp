<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Create Service - QueueSmart</title>
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
    
    .main { flex: 1; padding: 30px; display:flex; flex-direction:column; align-items:center; overflow-y:auto;}
    .header { width: 100%; max-width: 600px; margin-bottom: 30px; }
    
    .card { width: 100%; max-width: 600px; background: var(--card); border: 1.5px solid var(--bdr); border-radius: var(--r); padding: 30px; box-shadow: var(--sh); }
    
    .fg { margin-bottom: 15px; }
    .fg label { display: block; font-size: 13px; font-weight: 700; color: var(--text2); margin-bottom: 5px; }
    .fg input, .fg select, .fg textarea { width: 100%; padding: 12px 15px; border: 1.5px solid var(--bdr); border-radius: 10px; font-size: 14px; background: var(--inp); color: var(--text); outline: none; }
    .fg input:focus, .fg select:focus, .fg textarea:focus { border-color: var(--sky); }
    
    .btn { background: var(--sky); color: #fff; padding: 12px 20px; border: none; border-radius: 10px; cursor: pointer; text-decoration:none; font-size: 15px; font-weight: 700; width: 100%; margin-top: 10px;}
    .btn:hover { background: var(--sky-dk); }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/provider/dashboard" class="nav-link">Dashboard</a>
  <a href="${pageContext.request.contextPath}/provider/services" class="nav-link active">My Services</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444;">Logout</a>
</div>

<div class="main">
  <div class="header">
    <h2>Create New Service</h2>
  </div>

  <div class="card">
    <form action="${pageContext.request.contextPath}/provider/services" method="POST">
      <input type="hidden" name="action" value="create">
      
      <div class="fg">
        <label>Service Name</label>
        <input type="text" name="serviceName" required>
      </div>
      
      <div class="fg">
        <label>Category</label>
        <select name="category" required>
          <option value="Healthcare">Healthcare</option>
          <option value="Banking">Banking</option>
          <option value="Government">Government</option>
          <option value="Salon">Salon & Beauty</option>
          <option value="Other">Other</option>
        </select>
      </div>
      
      <div class="fg">
        <label>Description</label>
        <textarea name="description" rows="3" required></textarea>
      </div>
      
      <div style="display:flex; gap:15px;">
        <div class="fg" style="flex:1;">
          <label>Price ($)</label>
          <input type="number" step="0.01" min="0" name="price" value="0.00" required>
        </div>
        <div class="fg" style="flex:1;">
          <label>Duration (Minutes)</label>
          <input type="number" min="5" name="durationMinutes" value="30" required>
        </div>
        <div class="fg" style="flex:1;">
          <label>Capacity Per Slot</label>
          <input type="number" min="1" name="capacityPerSlot" value="1" required>
        </div>
      </div>
      
      <button type="submit" class="btn">Submit for Approval</button>
      <div style="text-align:center; margin-top:15px;">
        <a href="${pageContext.request.contextPath}/provider/services" style="color:var(--text2); font-size:14px; text-decoration:none;">Cancel</a>
      </div>
    </form>
  </div>
</div>
<script>
  var th = localStorage.getItem('qs_theme') || 'light';
  document.documentElement.setAttribute('data-theme', th);
</script>
</body>
</html>
