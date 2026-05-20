<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Wishlist - QueueSmart</title>
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
    
    .header-controls { position: absolute; top: 40px; right: 40px; z-index: 10; display:flex; align-items:center; gap: 15px;}
    .btn-theme { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); color: var(--text); padding: 10px 20px; border-radius: 30px; cursor: pointer; font-weight: 600; font-family: 'Outfit'; box-shadow: var(--sh); transition: 0.3s; }
    .btn-theme:hover { transform: translateY(-2px); }

    .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 30px; margin-bottom: 40px; }
    
    .card { background: var(--card); backdrop-filter: var(--card-blur); border: 1px solid var(--bdr); border-radius: var(--r); padding: 30px; box-shadow: var(--sh); transition: transform 0.3s ease; }
    .card:hover { transform: translateY(-5px); border-color: var(--sky); }
    
    .card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px; }
    .card-title { font-size: 22px; font-weight: 800; color: var(--text); }
    .card-badge { background: var(--inp); padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 800; border: 1px solid var(--bdr); }
    
    .price-tag { color: #10b981; font-weight: 900; font-size: 24px; margin-bottom: 20px; }
    
    .btn { background: linear-gradient(135deg, #0ea5e9, #3b82f6); color: #fff; padding: 12px 24px; border: none; border-radius: 12px; cursor: pointer; text-decoration:none; font-size: 15px; font-weight: 700; transition: 0.3s; box-shadow: 0 4px 15px rgba(14,165,233,0.3); display: inline-block; text-align: center; width: 100%;}
    .btn:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(14,165,233,0.4); }
    
    .btn-remove { background: transparent; color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.2); padding: 12px 24px; border-radius: 12px; cursor: pointer; text-decoration:none; font-size: 15px; font-weight: 700; transition: 0.3s; display: inline-block; text-align: center; width: 100%; margin-top: 10px;}
    .btn-remove:hover { background: rgba(239, 68, 68, 0.1); border-color: #ef4444; }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="${pageContext.request.contextPath}/customer/dashboard" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/customer/dashboard" class="nav-link">✨ Dashboard</a>
  <a href="${pageContext.request.contextPath}/customer/wishlist" class="nav-link active">❤️ My Wishlist</a>
  <a href="${pageContext.request.contextPath}/customer/profile" class="nav-link">👤 My Profile</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444; font-weight: 800;">🚪 Logout</a>
</div>

<div class="main">
  <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom: 40px;">
    <div>
        <h2 style="font-size: 36px; font-weight: 800; margin-bottom: 10px;">❤️ Saved Services</h2>
        <p style="color: var(--text2); font-size: 16px;">Services you have saved for later.</p>
    </div>
    <div style="display:flex; align-items:center; gap: 15px;">
        <button class="btn-theme" onclick="toggleTheme()">🌓 Toggle Theme</button>
    </div>
  </div>

  <div class="grid">
    <c:forEach var="srv" items="${wishlistServices}">
      <div class="card">
        <div class="card-header">
            <div class="card-title">${srv.serviceName}</div>
            <div class="card-badge">${srv.category}</div>
        </div>
        <div class="price-tag">$${srv.price}</div>
        
        <a href="${pageContext.request.contextPath}/customer/book?serviceId=${srv.id}" class="btn">Book Now</a>
        
        <form action="${pageContext.request.contextPath}/customer/wishlist" method="POST">
            <input type="hidden" name="action" value="remove">
            <input type="hidden" name="serviceId" value="${srv.id}">
            <button type="submit" class="btn-remove">❌ Remove from Wishlist</button>
        </form>
      </div>
    </c:forEach>
  </div>
  
  <c:if test="${empty wishlistServices}">
      <div style="text-align:center; padding: 80px 20px; background: var(--card); border: 1px dashed var(--bdr); border-radius: var(--r);">
        <div style="font-size: 60px; margin-bottom: 20px;">💔</div>
        <h3 style="font-size: 24px; font-weight: 800; margin-bottom: 10px;">Your wishlist is empty</h3>
        <p style="color: var(--text2); font-size: 16px; margin-bottom: 30px;">You haven't saved any services yet.</p>
        <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn" style="width: auto;">Explore Services</a>
      </div>
  </c:if>

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
