<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
    <title>QueueSmart - Smart Queue & Appointment System</title>
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
        
        /* Hero Section */
        .hero { display: flex; align-items: center; justify-content: space-between; padding: 80px 50px; max-width: 1200px; margin: 0 auto; gap: 50px; }
        .hero-text { flex: 1; }
        .hero-text h1 { font-size: 56px; font-weight: 900; line-height: 1.1; margin-bottom: 20px; color: var(--primary-dark); letter-spacing: -1px; }
        .hero-text p { font-size: 18px; color: var(--text-muted); margin-bottom: 40px; max-width: 520px; line-height: 1.7;}
        .hero-img { flex: 1; display: flex; justify-content: center; }
        .hero-img img { width: 100%; max-width: 500px; filter: drop-shadow(0 20px 40px rgba(14,165,233,0.15)); }

        /* Features Section */
        .section { padding: 80px 50px; max-width: 1200px; margin: 0 auto; text-align: center; }
        .section-title { font-size: 36px; font-weight: 900; color: var(--primary-dark); margin-bottom: 15px; letter-spacing: -0.5px;}
        .section-subtitle { font-size: 18px; color: var(--text-muted); margin-bottom: 50px; }
        
        .grid-3 { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; }
        .feature-card { background: var(--card); padding: 40px 30px; border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); transition: transform 0.3s; text-align: left; }
        .feature-card:hover { transform: translateY(-5px); box-shadow: 0 15px 40px rgba(14,165,233,0.1); }
        .feature-icon { font-size: 40px; margin-bottom: 20px; }
        .feature-card h3 { font-size: 20px; font-weight: 800; color: var(--text-main); margin-bottom: 10px; }
        .feature-card p { font-size: 15px; color: var(--text-muted); line-height: 1.6;}

        /* Timeline Section */
        .timeline { display: flex; flex-direction: column; gap: 20px; max-width: 800px; margin: 0 auto; text-align: left; }
        .timeline-step { display: flex; gap: 20px; align-items: flex-start; background: var(--card); padding: 30px; border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 5px 15px rgba(0,0,0,0.02); }
        .step-number { background: var(--primary-dark); color: white; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 900; flex-shrink: 0; }
        .step-content h3 { font-size: 20px; font-weight: 800; margin-bottom: 5px; color: var(--primary-dark); }
        .step-content p { color: var(--text-muted); line-height: 1.6;}

        /* Footer */
        .footer { background: var(--card); padding: 40px 50px; text-align: center; border-top: 1px solid var(--border); margin-top: 40px; }
        .footer p { color: var(--text-muted); font-weight: 600; margin-top: 10px;}
        
        @media (max-width: 900px) {
            .hero { flex-direction: column; text-align: center; padding: 40px 20px; }
            .hero-text p { margin: 0 auto 40px; }
            .navbar { padding: 15px 20px; flex-direction: column; gap: 15px; }
            .nav-links { gap: 15px; flex-wrap: wrap; justify-content: center; }
            .section { padding: 60px 20px; }
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

<div class="hero">
    <div class="hero-text">
        <h1>QueueSmart – Smart Queue & Appointment Management System</h1>
        <p>QueueSmart helps you avoid long physical queues by enabling remote queue joining, real-time tracking, and effortless appointment booking. Your time is priceless.</p>
        <% if (isLoggedIn) { %>
            <a href="<%= dashLink %>" class="btn btn-primary" style="font-size: 16px; padding: 14px 28px;">Access Dashboard</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/register" class="btn btn-primary" style="font-size: 16px; padding: 14px 28px;">Get Started Today</a>
        <% } %>
    </div>
    <div class="hero-img">
        <img src="<%= request.getContextPath() %>/assets/img/queue_illustration.png" alt="Queue Management Illustration" style="width: 100%; max-width: 500px; filter: drop-shadow(0 20px 40px rgba(14,165,233,0.15)); border-radius: 20px;">
    </div>
</div>

<div class="section">
    <h2 class="section-title">Key Features</h2>
    <p class="section-subtitle">A fully digital, multi-channel reception experience designed to save your time.</p>
    
    <div class="grid-3">
        <div class="feature-card">
            <div class="feature-icon">🎟️</div>
            <h3>Digital Ticket</h3>
            <p>Know waiting conditions in real time. Take a digital ticket from anywhere and arrive just when it's your turn.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">📅</div>
            <h3>Online Appointment Booking</h3>
            <p>Access availability 24/7. Your calendar is automatically synchronized so you never miss a schedule.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🎯</div>
            <h3>Real-Time Tracking</h3>
            <p>See exactly how many people are before you and get live updates directly on your dashboard.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">📱</div>
            <h3>Mobile Reception</h3>
            <p>Providers can interact with customers, update queue status, and call the next person instantly using any device.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔔</div>
            <h3>Notification System</h3>
            <p>Receive timely alerts and notifications about your queue status to ensure you never miss your turn.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔐</div>
            <h3>Role-Based Dashboards</h3>
            <p>Dedicated command centers for Customers, Providers, and Admins to ensure secure and tailored experiences.</p>
        </div>
    </div>
</div>

<div class="section" style="background: var(--card); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border);">
    <h2 class="section-title">How It Works</h2>
    <p class="section-subtitle">Experience a smooth, seamless visitor journey in just three simple steps.</p>
    
    <div class="timeline">
        <div class="timeline-step">
            <div class="step-number">1</div>
            <div class="step-content">
                <h3>User Registers or Logs In</h3>
                <p>Create a secure account in seconds. Access the platform as either a Customer seeking services or a Provider offering them.</p>
            </div>
        </div>
        <div class="timeline-step">
            <div class="step-number">2</div>
            <div class="step-content">
                <h3>Join a Queue or Book an Appointment</h3>
                <p>Browse available services, check current capacities, and seamlessly join the digital queue with a single click.</p>
            </div>
        </div>
        <div class="timeline-step">
            <div class="step-number">3</div>
            <div class="step-content">
                <h3>Track in Real-Time & Receive Notifications</h3>
                <p>Monitor your exact position in the line and get notified. Arrive just in time for your appointment without ever standing in a physical queue.</p>
            </div>
        </div>
    </div>
</div>

<div class="section">
    <h2 class="section-title">Ready to optimize your time?</h2>
    <p class="section-subtitle">Join QueueSmart today for a stress-free, customized, and efficient queue experience.</p>
    <% if (!isLoggedIn) { %>
        <div style="display: flex; justify-content: center; gap: 20px;">
            <a href="<%= request.getContextPath() %>/register" class="btn btn-primary" style="font-size: 16px; padding: 14px 28px;">Join Queue Now</a>
            <a href="<%= request.getContextPath() %>/login" class="btn btn-outline" style="font-size: 16px; padding: 14px 28px;">Login Now</a>
        </div>
    <% } %>
</div>

<footer class="footer">
    <div class="brand" style="justify-content: center;">
        <div class="brand-icon">Q</div> QueueSmart
    </div>
    <p>© 2026 QueueSmart System. Developed for Advanced Programming Coursework.</p>
</footer>

</body>
</html>