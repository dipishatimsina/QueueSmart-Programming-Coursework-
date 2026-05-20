<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard - QueueSmart</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
      --sh:0 8px 36px rgba(0,0,0,0.5);
    }
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Segoe UI',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;}
    
    .sidebar { width: 260px; background: var(--card); border-right: 1.5px solid var(--bdr); padding: 20px; display:flex; flex-direction:column; }
    .logo { font-size: 20px; font-weight: 800; color: var(--sky-dk); text-decoration: none; display: flex; align-items: center; gap: 10px; margin-bottom: 40px; }
    .logo-box { width: 34px; height: 34px; background: var(--sky); border-radius: 8px; color: #fff; display: flex; align-items: center; justify-content: center; }
    .nav-link { padding: 12px 15px; border-radius: 10px; text-decoration: none; color: var(--text); font-weight: 600; margin-bottom: 5px; display: block; transition: .2s; }
    .nav-link:hover, .nav-link.active { background: var(--sky-lt); color: var(--sky-dk); }
    
    .main { flex: 1; padding: 30px; display:flex; flex-direction:column; }
    .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    .user-info { font-weight: 700; color: var(--text2); display:flex; align-items:center; gap:15px; }
    
    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
    .stat-card { background: var(--card); border: 1.5px solid var(--bdr); border-radius: var(--r); padding: 20px; box-shadow: var(--sh); }
    .stat-card h3 { color: var(--text2); font-size: 14px; text-transform: uppercase; margin-bottom: 10px; }
    .stat-card .val { font-size: 32px; font-weight: 800; color: var(--sky-dk); }
    
    .btn { background: var(--sky); color: #fff; padding: 8px 16px; border: none; border-radius: 8px; cursor: pointer; text-decoration:none; font-size: 14px; font-weight: 600; }
    .btn:hover { background: var(--sky-dk); }
    .btn-outline { background: transparent; border: 1.5px solid var(--bdr); color: var(--text); }
  </style>
</head>
<body>

<div class="sidebar">
  <a href="#" class="logo"><div class="logo-box">Q</div>QueueSmart</a>
  <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">Manage Users</a>
  <a href="${pageContext.request.contextPath}/admin/services" class="nav-link">Manage Services</a>
  <a href="${pageContext.request.contextPath}/admin/bookings" class="nav-link">View Bookings</a>
  <a href="${pageContext.request.contextPath}/admin/logs" class="nav-link">System Audit Logs</a>
  <div style="flex:1"></div>
  <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color:#ef4444;">Logout</a>
</div>

<div class="main">
  <div class="header">
    <h2>Admin Dashboard</h2>
    <div class="user-info" style="display:flex; gap:10px; align-items:center;">
      <span>Welcome, ${sessionScope.userName}</span>
      <button class="btn btn-outline" onclick="downloadPDF()">📄 Download PDF Report</button>
      <button class="btn btn-outline" onclick="toggleTheme()">🌙 Theme</button>
    </div>
  </div>

  <div id="pdf-content">
  <div class="grid">
    <div class="stat-card">
      <h3>Total Customers</h3>
      <div class="val">${totalCustomers != null ? totalCustomers : 0}</div>
    </div>
    <div class="stat-card">
      <h3>Total Providers</h3>
      <div class="val">${totalProviders != null ? totalProviders : 0}</div>
    </div>
    <div class="stat-card">
      <h3>Active Services</h3>
      <div class="val">${totalServices != null ? totalServices : 0}</div>
    </div>
    <div class="stat-card">
      <h3>Total Bookings</h3>
      <div class="val">${totalBookings != null ? totalBookings : 0}</div>
    </div>
  </div>

  <!-- Analytics Graphs Section -->
  <div class="grid" style="grid-template-columns: 1fr 1fr; margin-top: 20px;">
    <div class="stat-card" style="height: 350px;">
      <h3>User Distribution</h3>
      <canvas id="userChart"></canvas>
    </div>
    <div class="stat-card" style="height: 350px;">
      <h3>Provider Approval Status</h3>
      <canvas id="providerChart"></canvas>
    </div>
    <div class="stat-card" style="height: 350px;">
      <h3>Queue Usage Statistics</h3>
      <canvas id="queueChart"></canvas>
    </div>
    <div class="stat-card" style="height: 350px;">
      <h3>Peak Usage Times</h3>
      <canvas id="peakChart"></canvas>
    </div>
  </div>

  <c:if test="${pendingUsers > 0}">
    <div class="stat-card" style="border-color:#fbbf24; background:#fffbeb;">
      <h3 style="color:#d97706;">Action Required</h3>
      <p style="color:#b45309; font-weight:600; margin-bottom:15px;">There are ${pendingUsers} pending providers waiting for approval.</p>
      <a href="${pageContext.request.contextPath}/admin/users" class="btn">Review Users</a>
    </div>
  </c:if>
  </div> <!-- end pdf-content -->
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
<script>
  function toggleTheme() {
    var th = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', th);
    localStorage.setItem('qs_theme', th);
  }
  var th = localStorage.getItem('qs_theme') || 'light';
  document.documentElement.setAttribute('data-theme', th);

  // Initialize Chart.js styling based on theme
  Chart.defaults.color = th === 'dark' ? '#7aabcc' : '#4b6280';
  Chart.defaults.borderColor = th === 'dark' ? '#1e4060' : '#bae6fd';

  // Register DataLabels Plugin
  Chart.register(ChartDataLabels);
  Chart.defaults.set('plugins.datalabels', {
      color: '#fff',
      font: { weight: 'bold', size: 14 }
  });

  // 1. User Distribution (Active Customers vs Total)
  new Chart(document.getElementById('userChart'), {
    type: 'pie',
    data: {
      labels: ['Customers', 'Providers'],
      datasets: [{
        data: [${totalCustomers != null ? totalCustomers : 0}, ${totalProviders != null ? totalProviders : 0}],
        backgroundColor: ['#0ea5e9', '#f59e0b']
      }]
    },
    options: { maintainAspectRatio: false }
  });

  // 2. Provider Status
  new Chart(document.getElementById('providerChart'), {
    type: 'doughnut',
    data: {
      labels: ['Approved', 'Pending'],
      datasets: [{
        data: [${totalProviders != null ? totalProviders - pendingUsers : 0}, ${pendingUsers != null ? pendingUsers : 0}],
        backgroundColor: ['#10b981', '#f43f5e']
      }]
    },
    options: { maintainAspectRatio: false }
  });

  // 3. Queue Usage Statistics
  new Chart(document.getElementById('queueChart'), {
    type: 'bar',
    data: {
      labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      datasets: [{
        label: 'Total Queues Joined',
        data: [45, 52, 38, 65, 48, 85, 72],
        backgroundColor: '#0ea5e9',
        borderRadius: 4
      }]
    },
    options: { 
        maintainAspectRatio: false, 
        scales: { y: { beginAtZero: true } },
        plugins: { datalabels: { align: 'end', anchor: 'end', color: th === 'dark' ? '#7aabcc' : '#4b6280' } }
    }
  });

  // 4. Peak Usage Times
  new Chart(document.getElementById('peakChart'), {
    type: 'line',
    data: {
      labels: ['8 AM', '10 AM', '12 PM', '2 PM', '4 PM', '6 PM'],
      datasets: [{
        label: 'Active Waiters',
        data: [5, 15, 40, 25, 35, 10],
        borderColor: '#f43f5e',
        tension: 0.3,
        fill: true,
        backgroundColor: 'rgba(244, 63, 94, 0.1)'
      }]
    },
    options: { 
        maintainAspectRatio: false, 
        scales: { y: { beginAtZero: true } },
        plugins: { datalabels: { align: 'top', color: th === 'dark' ? '#7aabcc' : '#4b6280' } }
    }
  });

  function downloadPDF() {
      const element = document.getElementById('pdf-content');
      // Adding a white background for transparent themes during PDF generation
      element.style.background = '#ffffff';
      element.style.padding = '20px';
      
      const opt = {
          margin:       0.2,
          filename:     'QueueSmart_Admin_Report.pdf',
          image:        { type: 'jpeg', quality: 0.98 },
          html2canvas:  { scale: 1.5, useCORS: true },
          jsPDF:        { unit: 'in', format: 'a3', orientation: 'landscape' }
      };
      
      html2pdf().set(opt).from(element).save().then(() => {
          // Reset styles after generation
          element.style.background = '';
          element.style.padding = '';
      });
  }
</script>
</body>
</html>
