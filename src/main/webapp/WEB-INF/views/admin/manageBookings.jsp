<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Bookings - QueueSmart</title>
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
    
    .card { background: var(--card); border: 1.5px solid var(--bdr); border-radius: var(--r); padding: 20px; box-shadow: var(--sh); overflow:hidden;}
    table { width: 100%; border-collapse: collapse; }
    th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid var(--bdr); }
    th { color: var(--text2); font-weight: 700; text-transform: uppercase; font-size: 13px; }
    td { font-size: 14px; }
    
    .badge { padding: 4px 8px; border-radius: 6px; font-size: 12px; font-weight: 700; }
    .badge.CONFIRMED { background: #dcfce7; color: #166534; }
    .badge.PENDING { background: #fef9c3; color: #854d0e; }
    .badge.IN_PROGRESS { background: #dbeafe; color: #1e40af; }
    .badge.COMPLETED { background: #e0e7ff; color: #3730a3; }
    .badge.CANCELLED { background: #fee2e2; color: #991b1b; }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">Manage Users</a>
  <a href="${pageContext.request.contextPath}/admin/services" class="nav-link">Manage Services</a>
  <a href="${pageContext.request.contextPath}/admin/bookings" class="nav-link active">View Bookings</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444;">Logout</a>
</div>

<div class="main">
  <div class="header">
    <h2>System Bookings</h2>
  </div>

  <div class="card">
    <table>
      <thead>
        <tr>
          <th>Booking ID</th>
          <th>Customer ID</th>
          <th>Service ID</th>
          <th>Date & Time</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="b" items="${bookings}">
          <tr>
            <td>#${b.id}</td>
            <td>${b.customerId}</td>
            <td>${b.serviceId}</td>
            <td>${b.bookingDate} at ${b.timeSlot}</td>
            <td><span class="badge ${b.status}">${b.status}</span></td>
          </tr>
        </c:forEach>
        <c:if test="${empty bookings}">
          <tr>
            <td colspan="5" style="text-align:center; padding:20px;">No bookings found in the system.</td>
          </tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>

<script>
  var th = localStorage.getItem('qs_theme') || 'light';
  document.documentElement.setAttribute('data-theme', th);
</script>
</body>
</html>
