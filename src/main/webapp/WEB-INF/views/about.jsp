<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    boolean isLoggedIn = userRole != null;
    String dashLink = request.getContextPath() + "/login";
    if (isLoggedIn) {
        if ("ADMIN".equals(userRole)) dashLink = request.getContextPath() + "/admin/dashboard";
        else if ("PROVIDER".equals(userRole)) dashLink = request.getContextPath() + "/provider/dashboard";
        else dashLink = request.getContextPath() + "/customer/dashboard";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - QueueSmart</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800;900&display=swap');
        :root {
            --primary: #0ea5e9; --primary-dark: #0284c7; --sky-lt: #e0f2fe; --bg: #f4f9fc;
            --text-main: #0c1a2e; --text-muted: #64748b; --card: #ffffff; --border: #e2e8f0;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Inter', system-ui, sans-serif; }
        body { background: var(--bg); color: var(--text-main); line-height: 1.6; }
        
        /* Navbar */
        .navbar { display: flex; justify-content: space-between; align-items: center; padding: 20px 50px; background: rgba(255,255,255,0.85); backdrop-filter: blur(12px); position: sticky; top: 0; z-index: 100; border-bottom: 1px solid var(--border); }
        .brand { display: flex; align-items: center; gap: 10px; font-size: 22px; font-weight: 900; color: var(--primary-dark); text-decoration: none; }
        .brand-icon { background: var(--primary); color: white; width: 34px; height: 34px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 18px; }
        .nav-links { display: flex; gap: 30px; }
        .nav-links a { text-decoration: none; color: var(--text-muted); font-weight: 600; transition: 0.2s; font-size: 15px;}
        .nav-links a:hover { color: var(--primary); }
        .nav-auth { display: flex; gap: 15px; }
        .btn { padding: 10px 20px; border-radius: 8px; font-weight: 700; text-decoration: none; transition: 0.2s; cursor: pointer; border: none; font-size: 14px;}
        .btn-outline { background: transparent; color: var(--primary); border: 2px solid var(--primary); }
        .btn-outline:hover { background: var(--sky-lt); }
        .btn-primary { background: var(--primary); color: white; border: 2px solid var(--primary); }
        .btn-primary:hover { background: var(--primary-dark); border-color: var(--primary-dark); }
        
        /* Page Header */
        .page-header { background: linear-gradient(135deg, #f4f9fc, #e0f2fe); padding: 80px 50px; text-align: center; border-bottom: 1px solid var(--border); }
        .page-header h1 { font-size: 48px; font-weight: 900; color: var(--primary-dark); margin-bottom: 15px; letter-spacing: -1px; }
        .page-header p { font-size: 18px; color: var(--text-muted); max-width: 600px; margin: 0 auto; }
        
        /* Content Section */
        .content-container { max-width: 900px; margin: 60px auto; padding: 0 30px; }
        .card { background: var(--card); padding: 40px; border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); margin-bottom: 40px; }
        .card h2 { font-size: 28px; font-weight: 800; color: var(--primary-dark); margin-bottom: 20px; border-bottom: 2px solid var(--sky-lt); padding-bottom: 10px; display: inline-block;}
        .card p { font-size: 16px; color: var(--text-muted); margin-bottom: 20px; line-height: 1.8; }
        
        /* Technologies Grid */
        .tech-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin-top: 20px; }
        .tech-item { background: var(--bg); padding: 15px; border-radius: 8px; text-align: center; font-weight: 700; color: var(--primary-dark); border: 1px solid var(--border); }
        
        /* Roles Grid */
        .roles-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-top: 20px; }
        .role-card { background: var(--bg); padding: 25px; border-radius: 12px; border: 1px solid var(--border); }
        .role-card h3 { font-size: 20px; color: var(--text-main); margin-bottom: 10px; display: flex; align-items: center; gap: 10px;}
        .role-card p { margin-bottom: 0; font-size: 15px; }

        /* Footer */
        .footer { background: var(--card); padding: 40px 50px; text-align: center; border-top: 1px solid var(--border); margin-top: 40px; }
        .footer p { color: var(--text-muted); font-weight: 600; margin-top: 10px;}
        
        @media (max-width: 900px) {
            .navbar { padding: 15px 20px; flex-direction: column; gap: 15px; }
            .nav-links { gap: 15px; flex-wrap: wrap; justify-content: center; }
            .page-header { padding: 50px 20px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="<%= request.getContextPath() %>/" class="brand">
        <div class="brand-icon">Q</div> QueueSmart
    </a>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/">Home</a>
        <a href="<%= request.getContextPath() %>/about">About Us</a>
        <a href="<%= request.getContextPath() %>/contact">Contact Us</a>
    </div>
    <div class="nav-auth">
        <% if (isLoggedIn) { %>
            <a href="<%= dashLink %>" class="btn btn-primary">Go to Dashboard</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/login" class="btn btn-outline">Login</a>
            <a href="<%= request.getContextPath() %>/register" class="btn btn-primary">Sign Up</a>
        <% } %>
    </div>
</nav>

<div class="page-header">
    <h1>About QueueSmart</h1>
    <p>A smart digital solution designed to replace traditional manual queue systems with an efficient, real-time platform.</p>
</div>

<div class="content-container">
    <div class="card">
        <h2>Purpose and Value</h2>
        <p>QueueSmart is an innovative digital platform built to revolutionize how businesses and individuals manage their time. Traditional manual queuing systems often lead to long waiting times, severe overcrowding, lack of transparency, and overall inefficient service management.</p>
        <p>Our solution solves these exact problems by providing a seamless, real-time environment where customers can join queues remotely and track their status live, allowing service providers to manage their operational capacities effortlessly.</p>
    </div>

    <div class="card">
        <h2>System Architecture & Technologies</h2>
        <p>To ensure high scalability, reliability, and ease of maintainability, QueueSmart is engineered using robust industry-standard technologies following the MVC (Model-View-Controller) architecture.</p>
        <div class="tech-grid">
            <div class="tech-item">Java (J2EE)</div>
            <div class="tech-item">Servlets</div>
            <div class="tech-item">JSP</div>
            <div class="tech-item">MySQL</div>
            <div class="tech-item">MVC Pattern</div>
        </div>
    </div>

    <div class="card">
        <h2>Dedicated System Roles</h2>
        <p>The system is dynamically divided into three core interactive roles, each equipped with dedicated dashboards to ensure maximum efficiency.</p>
        <div class="roles-grid">
            <div class="role-card">
                <h3>👤 Customer</h3>
                <p>Can browse available services, remotely join queues, book appointments, and monitor their real-time position without standing in a physical line.</p>
            </div>
            <div class="role-card">
                <h3>🔧 Service Provider</h3>
                <p>Can create service listings, manage daily queue capacities, and utilize a command center to call or complete customer appointments interactively.</p>
            </div>
            <div class="role-card">
                <h3>🛡️ Administrator</h3>
                <p>Maintains complete oversight of the platform by approving pending services, analyzing system-wide statistics, and moderating user activity.</p>
            </div>
        </div>
    </div>

    <div class="card">
        <h2>Real-World Impact</h2>
        <p>By digitizing the reception process, QueueSmart delivers a profoundly improved customer experience. Customers regain control over their valuable time, reducing the stress of physical waiting rooms. Simultaneously, businesses benefit from smarter queue management and noticeably better service efficiency.</p>
        <div style="text-align: center; margin-top: 30px;">
            <img src="<%= request.getContextPath() %>/assets/img/queue_illustration.png" alt="Queue Management Impact" style="width: 100%; max-width: 400px; filter: drop-shadow(0 10px 20px rgba(14,165,233,0.1));" onerror="this.style.display='none'">
        </div>
    </div>
</div>

<footer class="footer">
    <div class="brand" style="justify-content: center;">
        <div class="brand-icon">Q</div> QueueSmart
    </div>
    <p>© 2026 QueueSmart System. Developed for Advanced Programming Coursework.</p>
</footer>

</body>
</html>
