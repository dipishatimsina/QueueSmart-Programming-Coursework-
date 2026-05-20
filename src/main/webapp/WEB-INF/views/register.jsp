<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>QueueSmart — Register</title>
  <style>
    :root {
      --primary: #0ea5e9;
      --primary-dark: #0284c7;
      --bg: #f4f9fc;
      --card: #ffffff;
      --text-main: #0c1a2e;
      --text-muted: #64748b;
      --border: #e2e8f0;
      --border-focus: #bae6fd;
    }
    [data-theme="dark"] {
      --bg: #0f172a;
      --card: #1e293b;
      --text-main: #f8fafc;
      --text-muted: #94a3b8;
      --border: #334155;
      --border-focus: #0ea5e9;
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
    .auth-card { background: var(--card); border-radius: 24px; overflow-y: auto; overflow-x: hidden; width: 100%; max-width: 440px; max-height: 80vh; box-shadow: 0 20px 60px rgba(0,0,0,0.05); border: 1px solid var(--border);}
    .card-header { background: transparent; padding: 40px 40px 10px; color: var(--text-main); font-size: 28px; font-weight: 800; text-align: left; }
    .card-body { padding: 20px 40px 40px; }

    .alert { padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; font-weight: 600; text-align: left; }
    .alert.error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

    .section-title { font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 15px; }
    
    /* Role Selector */
    .role-grid { display: flex; gap: 15px; margin-bottom: 25px; }
    .role-box { flex: 1; border: 1px solid var(--border); border-radius: 10px; padding: 15px 10px; text-align: center; cursor: pointer; transition: 0.2s; position: relative; }
    .role-box:hover { border-color: var(--border-focus); background: rgba(14,165,233,0.02); }
    .role-box.selected { border: 2px solid var(--primary); background: rgba(14,165,233,0.05); }
    
    .role-icon { font-size: 24px; margin-bottom: 5px; display: block; filter: grayscale(100%); opacity: 0.6; }
    .role-box.selected .role-icon { filter: grayscale(0%); opacity: 1; }
    
    .role-name { font-size: 14px; font-weight: 600; color: var(--text-main); }
    
    /* Hide actual radio buttons */
    .role-radio { display: none; }

    /* Form Fields */
    .fg { margin-bottom: 20px; position: relative;}
    .fg input { width: 100%; padding: 14px 15px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px; background: transparent; color: var(--text-main); outline: none;}
    .fg input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(14,165,233,0.1); }
    
    /* Password Strength */
    .strength-meter { height: 4px; background: var(--border); border-radius: 2px; margin-top: 8px; overflow: hidden; display: flex;}
    .strength-bar { height: 100%; width: 0; transition: width 0.3s, background-color 0.3s; }
    .strength-text { font-size: 11px; margin-top: 4px; font-weight: 600; text-align: right; color: var(--text-muted); }
    
    .btn-main { background: var(--primary); color: #fff; width: 100%; padding: 14px; border: none; border-radius: 8px; font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.2s; margin-top: 5px;}
    .btn-main:hover { background: var(--primary-dark); }

    .footer-link { text-align: center; font-size: 14px; color: var(--text-muted); margin-top: 25px;}
    .footer-link a { color: var(--primary); text-decoration: none; font-weight: 700;}
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
        <div class="card-header" id="t-signup-title">Sign Up</div>
        <div class="card-body">
            
            <c:if test="${not empty errorMsg}">
                <div class="alert error">${errorMsg}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                
                <div class="section-title" id="t-role-label">SELECT YOUR ROLE</div>
                
                <div class="role-grid">
                    <label class="role-box ${empty role or role == 'CUSTOMER' ? 'selected' : ''}" id="box-CUSTOMER">
                        <input type="radio" name="role" value="CUSTOMER" class="role-radio" ${empty role or role == 'CUSTOMER' ? 'checked' : ''} onchange="updateRoleUI()">
                        <span class="role-icon">👤</span>
                        <span class="role-name" id="t-role-c">Customer</span>
                    </label>
                    <label class="role-box ${role == 'PROVIDER' ? 'selected' : ''}" id="box-PROVIDER">
                        <input type="radio" name="role" value="PROVIDER" class="role-radio" ${role == 'PROVIDER' ? 'checked' : ''} onchange="updateRoleUI()">
                        <span class="role-icon">🔧</span>
                        <span class="role-name" id="t-role-p">Provider</span>
                    </label>
                    <!-- Admin role intentionally omitted as requested -->
                </div>
                
                <div class="fg">
                    <input type="text" name="fullName" id="rName" placeholder="Full Name" value="<c:out value='${fullName}'/>" required>
                </div>

                <div class="fg">
                    <input type="email" name="email" id="rEmail" placeholder="Email" value="<c:out value='${email}'/>" required>
                </div>

                <div class="fg">
                    <input type="text" name="phone" id="rPhone" placeholder="Phone Number" value="<c:out value='${phone}'/>" required>
                </div>

                <div class="fg">
                    <input type="password" name="password" id="rPass" placeholder="Password" required oninput="checkStrength()">
                    <div class="strength-meter"><div class="strength-bar" id="strengthBar"></div></div>
                    <div class="strength-text" id="strengthText"></div>
                </div>
                
                <div class="fg">
                    <input type="password" name="confirmPassword" id="rConf" placeholder="Confirm Password" required>
                </div>
                
                <button type="submit" class="btn-main"><span id="t-signup-btn">Sign Up</span></button>
            </form>

            <div class="footer-link">
                <span id="t-haveacc">Already have an account?</span> <a href="${pageContext.request.contextPath}/login" id="t-gologin">Login</a>
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
      'signup-title': 'Sign Up',
      'role-label':   'SELECT YOUR ROLE',
      'role-c':       'Customer',
      'role-p':       'Provider',
      'signup-btn':   'Sign Up',
      'haveacc':      'Already have an account?',
      'gologin':      ' Login',
      'ph-name':      'Full Name',
      'ph-remail':    'Email',
      'ph-rphone':    'Phone Number',
      'ph-rpass':     'Password',
      'ph-rconf':     'Confirm Password'
    },
    np: {
      'brand':        'क्यूस्मार्ट',
      'darkmode':     'डार्क मोड',
      'lightmode':    'लाइट मोड',
      'hero1':        'स्मार्ट कतार र अपोइन्टमेन्ट प्रणाली',
      'hero2':        'सेवा बुक गर्नुहोस्, पालो कुर्नु पर्दैन, वास्तविक समयमा आफ्नो पालो ट्र्याक गर्नुहोस्',
      'signup-title': 'साइन अप',
      'role-label':   'आफ्नो भूमिका छान्नुस्',
      'role-c':       'ग्राहक',
      'role-p':       'प्रदायक',
      'signup-btn':   'साइन अप गर्नुस्',
      'haveacc':      'पहिले नै खाता छ?',
      'gologin':      ' लगइन',
      'ph-name':      'पूरा नाम',
      'ph-remail':    'इमेल',
      'ph-rphone':    'फोन नम्बर',
      'ph-rpass':     'पासवर्ड',
      'ph-rconf':     'पासवर्ड पुष्टि गर्नुस्'
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
      't-signup-title': 'signup-title',
      't-role-label':   'role-label',
      't-role-c':       'role-c',
      't-role-p':       'role-p',
      't-signup-btn':   'signup-btn',
      't-haveacc':      'haveacc',
      't-gologin':      'gologin'
    };
    
    Object.entries(map).forEach(([id, key]) => {
      const el = document.getElementById(id);
      if (el) el.innerHTML = t(key);
    });

    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const tBtn = document.getElementById('t-darkmode');
    if (tBtn) tBtn.innerHTML = t(isDark ? 'lightmode' : 'darkmode');

    const elNames = ['rName', 'rEmail', 'rPhone', 'rPass', 'rConf'];
    const pKeys = ['ph-name', 'ph-remail', 'ph-rphone', 'ph-rpass', 'ph-rconf'];
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
    
    function updateRoleUI() {
        document.querySelectorAll('.role-box').forEach(box => box.classList.remove('selected'));
        const selectedRadio = document.querySelector('input[name="role"]:checked');
        if (selectedRadio) {
            document.getElementById('box-' + selectedRadio.value).classList.add('selected');
        }
    }
    
    function checkStrength() {
        const pw = document.getElementById('rPass').value;
        const bar = document.getElementById('strengthBar');
        const text = document.getElementById('strengthText');
        
        if (pw.length === 0) {
            bar.style.width = '0%';
            text.innerHTML = '';
            return;
        }
        
        let strength = 0;
        if (pw.length >= 8) strength += 25;
        if (/[A-Z]/.test(pw)) strength += 25;
        if (/[a-z]/.test(pw)) strength += 25;
        if (/[0-9!@#\$%\^&\*]/.test(pw)) strength += 25;
        
        bar.style.width = strength + '%';
        
        if (strength <= 25) {
            bar.style.backgroundColor = '#ef4444';
            text.innerHTML = '<span style="color:#ef4444">Weak</span>';
        } else if (strength <= 50) {
            bar.style.backgroundColor = '#f59e0b';
            text.innerHTML = '<span style="color:#f59e0b">Fair</span>';
        } else if (strength <= 75) {
            bar.style.backgroundColor = '#3b82f6';
            text.innerHTML = '<span style="color:#3b82f6">Good</span>';
        } else {
            bar.style.backgroundColor = '#10b981';
            text.innerHTML = '<span style="color:#10b981">Strong</span>';
        }
    }
</script>

</body>
</html>