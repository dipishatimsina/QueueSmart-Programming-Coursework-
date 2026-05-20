<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Leave Feedback - QueueSmart</title>
  <style>
    :root {
      --sky:#0ea5e9; --sky-dk:#0284c7; --bg:#f0f9ff; --card:#fff; 
      --text:#0c1a2e; --text2:#4b6280; --bdr:#bae6fd; --inp:#f8fbff;
    }
    body { font-family: 'Segoe UI', sans-serif; background: var(--bg); display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
    .card { background: var(--card); padding: 40px; border-radius: 16px; box-shadow: 0 8px 36px rgba(14,165,233,0.13); width: 100%; max-width: 400px; border: 1.5px solid var(--bdr); }
    h2 { color: var(--sky-dk); margin-top: 0; text-align: center; margin-bottom: 25px; }
    .inp-grp { margin-bottom: 20px; }
    label { display: block; color: var(--text); font-weight: 600; margin-bottom: 8px; font-size: 14px; }
    select, textarea { width: 100%; padding: 12px; border: 1.5px solid var(--bdr); border-radius: 8px; background: var(--inp); color: var(--text); font-size: 14px; box-sizing: border-box; }
    textarea { resize: vertical; min-height: 100px; }
    .btn { width: 100%; padding: 12px; background: var(--sky); color: #fff; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; transition: 0.2s; font-size: 16px; }
    .btn:hover { background: var(--sky-dk); }
    .err { color: #ef4444; background: #fee2e2; padding: 10px; border-radius: 8px; margin-bottom: 20px; text-align: center; font-size: 14px; }
    .back { display: block; text-align: center; margin-top: 15px; color: var(--text2); text-decoration: none; font-size: 14px; }
    .back:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <div class="card">
    <h2>Rate Your Experience</h2>
    
    <c:if test="${not empty errorMsg}">
      <div class="err">${errorMsg}</div>
      <a href="${pageContext.request.contextPath}/customer/dashboard" class="back">Back to Dashboard</a>
    </c:if>
    
    <c:if test="${empty errorMsg}">
      <form action="${pageContext.request.contextPath}/customer/feedback" method="POST">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="serviceId" value="${service.id}">
        <input type="hidden" name="providerId" value="${service.providerId}">
        
        <p style="text-align: center; color: var(--text2); margin-top: -15px; margin-bottom: 20px;">
          For service: <strong>${service.serviceName}</strong>
        </p>

        <div class="inp-grp">
          <label>Rating</label>
          <select name="rating" required>
            <option value="5">⭐⭐⭐⭐⭐ (5) - Excellent</option>
            <option value="4">⭐⭐⭐⭐ (4) - Good</option>
            <option value="3">⭐⭐⭐ (3) - Average</option>
            <option value="2">⭐⭐ (2) - Poor</option>
            <option value="1">⭐ (1) - Terrible</option>
          </select>
        </div>

        <div class="inp-grp">
          <label>Comments (Optional)</label>
          <textarea name="comments" placeholder="Tell us about your experience..."></textarea>
        </div>

        <button type="submit" class="btn">Submit Feedback</button>
      </form>
      <a href="${pageContext.request.contextPath}/customer/dashboard" class="back">Cancel</a>
    </c:if>
  </div>
</body>
</html>
