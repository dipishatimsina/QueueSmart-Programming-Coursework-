<%--
  Created by IntelliJ IDEA.
  User: Acer
  Date: 3/30/2026
  Time: 8:36 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QueueSmart — Select Role</title>
    <style>
        :root {
            --sky: #0ea5e9;
            --sky-dark: #0284c7;
            --sky-light: #e0f2fe;
            --bg: #f0f9ff;
            --card: #ffffff;
            --text: #0c1a2e;
            --text2: #4b6280;
            --border: #bae6fd;
            --shadow: 0 4px 24px rgba(14,165,233,0.10);
            --radius: 16px;
            --transition: all 0.25s cubic-bezier(.4,0,.2,1);
        }
        [data-theme="dark"] {
            --bg: #0a1929;
            --card: #0d2137;
            --text: #e2f0fb;
            --text2: #8ab0cc;
            --border: #1e4060;
            --sky-light: #0d2a40;
            --shadow: 0 4px 24px rgba(0,0,0,0.4);
        }
        * { box-sizing:border-box; margin:0; padding:0; }
        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            transition: var(--transition);
        }
        .topnav {
            display:flex;align-items:center;justify-content:space-between;
            padding:16px 32px;
            background:var(--card);
            border-bottom:1px solid var(--border);
            box-shadow:0 2px 12px rgba(14,165,233,0.07);
        }
        .logo { display:flex;align-items:center;gap:10px;font-size:22px;font-weight:800;color:var(--sky-dark); }
        .logo-icon { width:38px;height:38px;background:var(--sky);border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:900;font-size:18px; }
        .theme-btn {
            background:var(--sky-light);border:1px solid var(--border);color:var(--sky-dark);
            padding:8px 18px;border-radius:8px;cursor:pointer;font-size:14px;font-weight:600;
            transition:var(--transition);
        }
        .theme-btn:hover { background:var(--sky);color:#fff; }

        .page-body {
            flex:1;display:flex;flex-direction:column;align-items:center;
            justify-content:center;padding:40px 20px;
        }
        .greeting {
            font-size:15px;color:var(--text2);margin-bottom:6px;
        }
        .greeting strong { color:var(--sky-dark); }
        h1 { font-size:28px;font-weight:800;color:var(--sky-dark);margin-bottom:8px;text-align:center; }
        .subtitle { color:var(--text2);font-size:15px;margin-bottom:40px;text-align:center; }

        .roles-grid {
            display:flex;gap:24px;flex-wrap:wrap;justify-content:center;max-width:900px;width:100%;
        }

        .role-card {
            background:var(--card);
            border-radius:var(--radius);
            border:2px solid var(--border);
            box-shadow:var(--shadow);
            width:240px;
            padding:36px 24px 28px;
            text-align:center;
            cursor:pointer;
            transition:var(--transition);
            position:relative;
            overflow:hidden;
        }
        .role-card::before {
            content:'';
            position:absolute;top:0;left:0;right:0;height:4px;
            background:var(--accent, var(--sky));
            transition:var(--transition);
        }
        .role-card:hover {
            transform:translateY(-6px);
            box-shadow:0 12px 40px rgba(14,165,233,0.22);
            border-color:var(--accent, var(--sky));
        }

        .role-card.customer { --accent:#0ea5e9; }
        .role-card.provider { --accent:#8b5cf6; }
        .role-card.admin    { --accent:#f59e0b; }

        .role-icon-wrap {
            width:80px;height:80px;border-radius:50%;
            display:flex;align-items:center;justify-content:center;
            margin:0 auto 18px;font-size:36px;
            background:var(--sky-light);
            transition:var(--transition);
        }
        .role-card.customer .role-icon-wrap { background:#e0f2fe; }
        .role-card.provider .role-icon-wrap { background:#ede9fe; }
        .role-card.admin    .role-icon-wrap { background:#fef3c7; }

        .role-card:hover .role-icon-wrap { transform:scale(1.1); }

        .role-name {
            font-size:20px;font-weight:800;margin-bottom:10px;
            color:var(--text);
        }
        .role-card.customer .role-name { color:#0284c7; }
        .role-card.provider .role-name { color:#7c3aed; }
        .role-card.admin    .role-name { color:#d97706; }

        .role-desc {
            font-size:13px;color:var(--text2);margin-bottom:22px;line-height:1.5;
        }
        .select-btn {
            display:inline-block;
            padding:10px 32px;
            border-radius:8px;
            font-weight:700;font-size:14px;
            cursor:pointer;border:none;
            transition:var(--transition);
            color:#fff;
            width:100%;
        }
        .role-card.customer .select-btn { background:#0ea5e9; }
        .role-card.provider .select-btn { background:#8b5cf6; }
        .role-card.admin    .select-btn { background:#f59e0b; }
        .select-btn:hover { opacity:0.88; transform:translateY(-1px); }

        .logout-link {
            margin-top:32px;font-size:13px;color:var(--text2);
        }
        .logout-link a { color:var(--sky);font-weight:600;text-decoration:none; }
        .logout-link a:hover { text-decoration:underline; }

        @media(max-width:600px){
            .role-card { width:100%;max-width:300px; }
        }
    </style>
</head>
<body>

<nav class="topnav">
    <div class="logo">
        <div class="logo-icon">Q</div>
        QueueSmart
    </div>
    <button class="theme-btn" onclick="toggleTheme()" id="themeBtn">🌙 Dark</button>
</nav>

<div class="page-body">
    <div class="greeting">Welcome back, <strong id="userName">User</strong>!</div>
    <h1>Who are you logging in as?</h1>
    <p class="subtitle">Select your role to access your personalized dashboard</p>

    <div class="roles-grid">

        <!-- CUSTOMER -->
        <div class="role-card customer" onclick="goToDashboard('CUSTOMER')">
            <div class="role-icon-wrap">👤</div>
            <div class="role-name">Customer</div>
            <div class="role-desc">Book services easily, track your queue position and manage appointments</div>
            <button class="select-btn">Select</button>
        </div>

        <!-- SERVICE PROVIDER -->
        <div class="role-card provider" onclick="goToDashboard('PROVIDER')">
            <div class="role-icon-wrap">🔧</div>
            <div class="role-name">Service Provider</div>
            <div class="role-desc">Manage your services, handle bookings and control your live queue</div>
            <button class="select-btn">Select</button>
        </div>

        <!-- ADMIN -->
        <div class="role-card admin" onclick="goToDashboard('ADMIN')">
            <div class="role-icon-wrap">⚙️</div>
            <div class="role-name">Admin</div>
            <div class="role-desc">Full system control — manage users, approve services and view reports</div>
            <button class="select-btn">Select</button>
        </div>

    </div>

    <div class="logout-link">
        Not you? <a href="login.jsp" onclick="doLogout()">Logout</a>
    </div>
</div>

<script>
    // Theme
    const th = localStorage.getItem('qs_theme') || 'light';
    document.documentElement.setAttribute('data-theme', th);
    document.getElementById('themeBtn').textContent = th === 'dark' ? '☀️ Light' : '🌙 Dark';
    function toggleTheme(){
        const cur = document.documentElement.getAttribute('data-theme');
        const next = cur==='dark'?'light':'dark';
        document.documentElement.setAttribute('data-theme',next);
        localStorage.setItem('qs_theme',next);
        document.getElementById('themeBtn').textContent = next==='dark'?'☀️ Light':'🌙 Dark';
    }

    // Check session
    const sess = sessionStorage.getItem('qs_session');
    if (!sess) {
        window.location.href = 'login.jsp';
    } else {
        const s = JSON.parse(sess);
        document.getElementById('userName').textContent = s.userName || 'User';
    }

    function goToDashboard(clickedRole) {
        const s = JSON.parse(sessionStorage.getItem('qs_session'));
        // Allow any role click — for demo, update role in session to clicked
        // In real system, validate against DB role
        s.activeRole = clickedRole;
        sessionStorage.setItem('qs_session', JSON.stringify(s));

        if (clickedRole === 'CUSTOMER')  window.location.href = 'customerDashboard.jsp';
        if (clickedRole === 'PROVIDER')  window.location.href = 'providerDashboard.jsp';
        if (clickedRole === 'ADMIN')     window.location.href = 'adminDashboard.jsp';
    }

    function doLogout(){
        sessionStorage.removeItem('qs_session');
    }
</script>
</body>
</html>

