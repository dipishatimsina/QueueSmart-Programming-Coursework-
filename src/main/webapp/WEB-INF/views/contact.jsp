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
    <title>Contact Us - QueueSmart</title>
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
        
        /* Contact Section */
        .contact-container { display: flex; max-width: 1000px; margin: -40px auto 60px; background: var(--card); border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 20px 40px rgba(0,0,0,0.05); overflow: hidden; position: relative; z-index: 10; }
        
        .contact-info { flex: 1; background: var(--primary-dark); color: white; padding: 50px 40px; position: relative; overflow: hidden;}
        .contact-info::before { content: ''; position: absolute; top: -50px; right: -50px; width: 200px; height: 200px; background: rgba(255,255,255,0.1); border-radius: 50%; }
        .contact-info h2 { font-size: 28px; font-weight: 800; margin-bottom: 10px; position: relative; z-index: 2;}
        .contact-info p { opacity: 0.9; margin-bottom: 40px; position: relative; z-index: 2;}
        
        .info-item { display: flex; align-items: center; gap: 15px; margin-bottom: 25px; position: relative; z-index: 2;}
        .info-icon { width: 40px; height: 40px; background: rgba(255,255,255,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .info-text h4 { font-size: 16px; font-weight: 700; margin-bottom: 2px; }
        .info-text p { margin-bottom: 0; font-size: 14px; opacity: 0.8; }

        .contact-form { flex: 1.5; padding: 50px 40px; background: var(--card); }
        .contact-form h2 { font-size: 24px; font-weight: 800; color: var(--text-main); margin-bottom: 20px; }
        
        .alert { padding: 15px; border-radius: 8px; margin-bottom: 25px; font-size: 14px; font-weight: 600; text-align: left; }
        .alert.error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .alert.success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; font-weight: 600; color: var(--text-main); margin-bottom: 8px; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px 15px; border: 1px solid var(--border); border-radius: 8px; font-size: 15px; background: var(--bg); color: var(--text-main); outline: none; transition: 0.2s;}
        .form-group input:focus, .form-group textarea:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(14,165,233,0.1); background: var(--card); }
        .form-group textarea { resize: vertical; min-height: 120px; }
        
        .btn-submit { background: var(--primary); color: #fff; width: 100%; padding: 14px; border: none; border-radius: 8px; font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.3s; margin-top: 10px;}
        .btn-submit:hover { background: var(--primary-dark); transform: translateY(-2px); box-shadow: 0 8px 20px rgba(14,165,233,0.3); }

        /* Footer */
        .footer { background: var(--card); padding: 40px 50px; text-align: center; border-top: 1px solid var(--border); margin-top: 40px; }
        .footer p { color: var(--text-muted); font-weight: 600; margin-top: 10px;}
        
        @media (max-width: 900px) {
            .navbar { padding: 15px 20px; flex-direction: column; gap: 15px; }
            .nav-links { gap: 15px; flex-wrap: wrap; justify-content: center; }
            .page-header { padding: 50px 20px 80px; }
            .contact-container { flex-direction: column; margin: -40px 20px 40px; }
            .contact-info { padding: 40px 30px; }
            .contact-form { padding: 40px 30px; }
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
    <h1>Contact Support</h1>
    <p>Have a question or need assistance? Reach out to our system administrators, and we'll ensure your experience remains seamless.</p>
</div>

<div class="contact-container">
    <div class="contact-info">
        <h2>Get in Touch</h2>
        <p>Fill out the form to communicate with the QueueSmart support team.</p>
        
        <div class="info-item">
            <div class="info-icon">📧</div>
            <div class="info-text">
                <h4>Email Us</h4>
                <p>support@queuesmart.com</p>
            </div>
        </div>
        <div class="info-item">
            <div class="info-icon">📞</div>
            <div class="info-text">
                <h4>Call Us</h4>
                <p>+1 (800) 123-4567</p>
            </div>
        </div>
        <div class="info-item">
            <div class="info-icon">📍</div>
            <div class="info-text">
                <h4>Office Location</h4>
                <p>Advanced Programming Lab,<br>University Campus</p>
            </div>
        </div>
        
        <div style="margin-top: 40px; text-align: center;">
            <img src="<%= request.getContextPath() %>/assets/img/queue_illustration.png" alt="Queue Management Support" style="width: 100%; max-width: 200px; filter: drop-shadow(0 10px 20px rgba(0,0,0,0.2));" onerror="this.style.display='none'">
        </div>
    </div>
    
    <div class="contact-form">
        <h2>Send a Message</h2>
        
        <c:if test="${not empty successMsg}">
            <div class="alert success">${successMsg}</div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert error">${errorMsg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/contact" method="POST">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" placeholder="John Doe" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="john@example.com" required>
            </div>
            
            <div class="form-group">
                <label for="subject">Subject</label>
                <input type="text" id="subject" name="subject" placeholder="How can we help?" required>
            </div>
            
            <div class="form-group">
                <label for="message">Message</label>
                <textarea id="message" name="message" placeholder="Type your message here..." required></textarea>
            </div>
            
            <button type="submit" class="btn-submit">Send Message</button>
        </form>
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
