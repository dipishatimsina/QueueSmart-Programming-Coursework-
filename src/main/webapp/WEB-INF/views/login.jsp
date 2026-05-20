<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>QueueSmart — Login</title>
  <style>
    :root {
      --primary: #0ea5e9;
      --primary-dark: #0284c7;
      --bg: #f4f9fc;
      --card: #ffffff;
      --text-main: #0c1a2e;
      --text-muted: #64748b;
      --border: #e2e8f0;
    }
    [data-theme="dark"] {
      --bg: #0f172a;
      --card: #1e293b;
      --text-main: #f8fafc;
      --text-muted: #94a3b8;
      --border: #334155;
      --left-bg1: #0f172a;
      --left-bg2: #1e293b;
    }
    * { box-sizing:border-box; margin:0; padding:0; font-family: 'Segoe UI', system-ui, sans-serif; }
    body { background: var(--bg); color: var(--text-main); min-height: 100vh; overflow: hidden; }
    
    .split-layout { display: flex; height: 100vh; width: 100%; }
    
    /* LEFT SIDE */
    .left-side {
        flex: 1.2;
        background: linear-gradient(135deg, var(--left-bg1, #f4f9fc), var(--left-bg2, #e0f2fe));
        color: var(--text-main);
        padding: 50px 60px;
        display: flex;
        flex-direction: column;
        position: relative;
        overflow: hidden;
    }
    .left-side::before { content: ''; position: absolute; top: -150px; right: -150px; width: 600px; height: 600px; background: rgba(14, 165, 233, 0.05); border-radius: 50%; z-index: 1; }
    .left-side::after { content: ''; position: absolute; bottom: -200px; left: -100px; width: 800px; height: 800px; background: rgba(14, 165, 233, 0.05); border-radius: 50%; z-index: 1; }
    
    .brand-logo { font-size: 24px; font-weight: 800; display: flex; align-items: center; gap: 12px; z-index: 10; margin-bottom: 60px; text-decoration: none; color: var(--primary-dark);}
    .brand-logo .logo-icon { background: var(--primary); color: white; width: 40px; height: 40px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: 900;}

    .hero-text { z-index: 10; }
    .hero-text h1 { font-size: 60px; font-weight: 900; line-height: 1.1; margin-bottom: 20px; letter-spacing: -1px; color: var(--primary-dark); }
    .hero-text p { font-size: 18px; max-width: 500px; line-height: 1.6; color: var(--text-muted); }
    
    .hero-image {
        z-index: 10;
        width: 100%;
        max-width: 500px;
        margin: auto auto 0;
        align-self: center;
        filter: drop-shadow(0 20px 40px rgba(14,165,233,0.15));
        mix-blend-mode: darken; /* Makes the white background transparent */
    }

    /* RIGHT SIDE */
    .right-side {
        flex: 1;
        background: var(--bg);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 40px;
        position: relative;
    }
    
    .top-nav {
        position: absolute;
        top: 30px;
        right: 40px;
        display: flex;
        gap: 15px;
        z-index: 10;
    }
    
    .toggle-group { display: flex; background: var(--border); border-radius: 8px; overflow: hidden;}
    .toggle-btn { padding: 8px 12px; font-size: 12px; font-weight: 700; border: none; cursor: pointer; color: var(--text-muted); background: transparent;}
    .toggle-btn.active { background: #14b8a6; color: #fff; }
    .theme-toggle { padding: 8px 15px; font-size: 13px; font-weight: 600; background: var(--card); border: 1px solid var(--border); border-radius: 8px; cursor: pointer; color: var(--text-muted); display:flex; align-items:center; gap:5px;}

    /* Card */
    .auth-card { background: var(--card); border-radius: 24px; overflow: hidden; width: 100%; max-width: 440px; box-shadow: 0 20px 60px rgba(0,0,0,0.05); border: 1px solid var(--border);}
    .card-header { background: transparent; padding: 40px 40px 10px; color: var(--text-main); font-size: 28px; font-weight: 800; text-align: left; }
    .card-body { padding: 20px 40px 40px; }

    .alert { padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; font-weight: 600; text-align: left; }
    .alert.error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
    .alert.success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }

    .fg { margin-bottom: 20px; position: relative;}
    .fg input { width: 100%; padding: 14px 15px; border: 1px solid var(--border); border-radius: 12px; font-size: 15px; background: transparent; color: var(--text-main); outline: none;}
    .fg input:focus { border-color: #14b8a6; box-shadow: 0 0 0 4px rgba(20,184,166,0.1); }
    
    .form-options { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; font-size: 14px;}
    .remember { display: flex; align-items: center; gap: 8px; color: var(--text-muted); font-weight: 500;}
    .forgot-link { color: #14b8a6; text-decoration: none; font-weight: 700;}

    .btn-main { background: var(--primary); color: #fff; width: 100%; padding: 16px; border: none; border-radius: 12px; font-size: 16px; font-weight: 800; cursor: pointer; transition: 0.3s; box-shadow: 0 8px 20px rgba(14,165,233,0.3);}
    .btn-main:hover { background: var(--primary-dark); transform: translateY(-2px); box-shadow: 0 12px 25px rgba(14,165,233,0.4);}

    .divider { display: flex; align-items: center; text-align: center; margin: 30px 0; color: var(--text-muted); font-size: 14px; font-weight: 600;}
    .divider::before, .divider::after { content: ''; flex: 1; border-bottom: 1px solid var(--border); }
    .divider:not(:empty)::before { margin-right: 15px; }
    .divider:not(:empty)::after { margin-left: 15px; }

    .social-btns { display: flex; gap: 15px; margin-bottom: 30px;}
    .social-btn { flex: 1; padding: 14px; border: 1px solid var(--border); border-radius: 12px; background: transparent; color: var(--text-main); font-size: 15px; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px;}
    .social-btn:hover { background: rgba(0,0,0,0.02); }

    .footer-link { text-align: center; font-size: 15px; color: var(--text-muted); font-weight: 500;}
    .footer-link a { color: #14b8a6; text-decoration: none; font-weight: 800;}
    
    @media (max-width: 900px) {
        .split-layout { flex-direction: column; overflow-y: auto; }
        .left-side { flex: none; padding: 40px; border-radius: 0 0 30px 30px; }
        .hero-text h1 { font-size: 40px; }
        .hero-image { display: none; }
        .right-side { padding: 40px 20px; }
        .top-nav { top: 20px; right: 20px; }
    }
  </style>
</head>
<body>

<div class="split-layout">
    <div class="left-side">
        <a href="${pageContext.request.contextPath}/" class="brand-logo">
            <div class="logo-icon">Q</div>
            <span id="t-brand">QueueSmart</span>
        </a>
        
        <div class="hero-text">
            <h1 id="t-hero1">Smart Queue &<br>Appointment System</h1>
            <p id="t-hero2">Book services, skip the wait, track your queue in real time.</p>
        </div>
        
        <!-- Replace this src with your exact image path if needed -->
        <img src="${pageContext.request.contextPath}/assets/img/queue_illustration.png" alt="Queue System" class="hero-image" onerror="this.style.display='none'">
    </div>

    <div class="right-side">
        <div class="top-nav">
            <div class="toggle-group">
                <button class="toggle-btn active" id="btnEN" onclick="setLang('en')">EN</button>
                <button class="toggle-btn" id="btnNP" onclick="setLang('np')">NP</button>
            </div>
            <button class="theme-toggle" onclick="toggleTheme()" id="themeBtn">
                <span id="tIcon">🌙</span> <span id="t-darkmode">Dark Mode</span>
            </button>
        </div>

        <div class="auth-card">
            <div class="card-header" id="t-login-title">Login</div>
        <div class="card-body">
            
            <c:if test="${param.error == 'session_expired'}">
                <div class="alert error">Your session has expired. Please log in again.</div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert error">${errorMsg}</div>
            </c:if>
            <c:if test="${param.success == 'registered'}">
                <div class="alert success">Registration successful! Please login.</div>
            </c:if>
            <c:if test="${not empty successMsg}">
                <div class="alert success">${successMsg}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                
                <div class="fg">
                    <input type="email" name="email" id="lEmail" placeholder="Email" value="${not empty rememberedEmail ? rememberedEmail : ''}" required>
                </div>
                <div class="fg">
                    <input type="password" name="password" id="lPass" placeholder="Password" required>
                </div>
                
                <div class="form-options">
                    <label class="remember">
                        <input type="checkbox" name="rememberMe" value="true" ${not empty rememberedEmail ? 'checked' : ''}><span id="t-remember"> Remember me</span>
                    </label>
                    <a href="${pageContext.request.contextPath}/forgotPassword" class="forgot-link" id="t-forgot">Forgot Password?</a>
                </div>
                
                <button type="submit" class="btn-main"><span id="t-login-btn">Login</span></button>
            </form>

            <div class="divider" id="t-or">or</div>

            <div class="social-btns">
                <a href="${pageContext.request.contextPath}/oauth/google" class="social-btn" style="text-decoration:none;">
                    <span style="color:#4285F4; font-weight:900; font-size:16px;">G</span> <span id="t-google">Google</span>
                </a>
                <button class="social-btn" style="color:#1877F2;">
                    <span style="font-weight:900; font-size:16px;">f</span> <span id="t-fb">Facebook</span>
                </button>
            </div>

            <div class="footer-link">
                <span id="t-noacc">Don't have an account?</span> <a href="${pageContext.request.contextPath}/register" id="t-gosignup">Sign Up</a>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
  const T = {
    en: {
      'brand':        'QueueSmart',
      'darkmode':     'Dark Mode',
      'lightmode':    'Light Mode',
      'hero1':        'Smart Queue & Appointment System',
      'hero2':        'Book services, skip the wait, track your queue in real time',
      'login-title':  'Login',
      'login-btn':    'Login',
      'remember':     ' Remember me',
      'forgot':       'Forgot Password?',
      'or':           'or',
      'google':       'Google',
      'fb':           'Facebook',
      'noacc':        "Don't have an account?",
      'gosignup':     ' Sign Up',
      'ph-email':     'Email',
      'ph-pass':      'Password'
    },
    np: {
      'brand':        'क्यूस्मार्ट',
      'darkmode':     'डार्क मोड',
      'lightmode':    'लाइट मोड',
      'hero1':        'स्मार्ट कतार र अपोइन्टमेन्ट प्रणाली',
      'hero2':        'सेवा बुक गर्नुहोस्, पालो कुर्नु पर्दैन, वास्तविक समयमा आफ्नो पालो ट्र्याक गर्नुहोस्',
      'login-title':  'लगइन',
      'login-btn':    'लगइन गर्नुस्',
      'remember':     ' मलाई सम्झनुहोस्',
      'forgot':       'पासवर्ड बिर्सनुभयो?',
      'or':           'वा',
      'google':       'गूगल',
      'fb':           'फेसबुक',
      'noacc':        'खाता छैन?',
      'gosignup':     ' साइन अप',
      'ph-email':     'इमेल',
      'ph-pass':      'पासवर्ड'
    }
  };

  let lang = localStorage.getItem('qs_lang') || 'en';
  function t(key) { return T[lang][key] || T['en'][key] || ''; }

  function applyLang(l) {
    lang = l;
    localStorage.setItem('qs_lang', l);

    const btnEN = document.getElementById('btnEN');
    const btnNP = document.getElementById('btnNP');
    if (btnEN) btnEN.classList.toggle('active', l === 'en');
    if (btnNP) btnNP.classList.toggle('active', l === 'np');

    const map = {
      't-brand':        'brand',
      't-hero1':        'hero1',
      't-hero2':        'hero2',
      't-login-title':  'login-title',
      't-login-btn':    'login-btn',
      't-remember':     'remember',
      't-forgot':       'forgot',
      't-or':           'or',
      't-google':       'google',
      't-fb':           'fb',
      't-noacc':        'noacc',
      't-gosignup':     'gosignup'
    };
    
    Object.entries(map).forEach(([id, key]) => {
      const el = document.getElementById(id);
      if (el) el.innerHTML = t(key);
    });

    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const tBtn = document.getElementById('t-darkmode');
    if (tBtn) tBtn.innerHTML = t(isDark ? 'lightmode' : 'darkmode');

    const elNames = ['lEmail', 'lPass'];
    const pKeys = ['ph-email', 'ph-pass'];
    for(let i=0; i<elNames.length; i++) {
        const el = document.getElementById(elNames[i]);
        if (el) el.placeholder = t(pKeys[i]);
    }
  }

  function setLang(l) { applyLang(l); }
  document.addEventListener('DOMContentLoaded', () => { applyLang(lang); });
</script>

<script>
    const th = localStorage.getItem('qs_theme') || 'light';
    document.documentElement.setAttribute('data-theme', th);
    document.getElementById('tIcon').innerHTML = th === 'dark' ? '☀️' : '🌙';
    document.getElementById('t-darkmode').innerHTML = t(th === 'dark' ? 'lightmode' : 'darkmode');
    
    function toggleTheme(){
        const cur = document.documentElement.getAttribute('data-theme');
        const next = cur === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', next);
        localStorage.setItem('qs_theme', next);
        document.getElementById('tIcon').innerHTML = next === 'dark' ? '☀️' : '🌙';
        document.getElementById('t-darkmode').innerHTML = t(next === 'dark' ? 'lightmode' : 'darkmode');
    }
</script>

</body>
</html>
