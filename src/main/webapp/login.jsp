<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - EventiaPro</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body style="display: flex; align-items: center; justify-content: center; min-height: 100vh;">

            <div class="glass-card" style="width: 380px; padding: 2rem; margin: 2rem 0;">
                <div style="text-align: center; margin-bottom: 1.5rem;">
                    <h2 style="color: var(--primary-color); font-weight: 700;">EventiaPro</h2>
                    <p style="color: var(--text-secondary); margin-top: 5px;">Sign in to your account</p>
                </div>

                <c:if test="${not empty param.success}">
                    <div
                        style="background: rgba(46, 213, 115, 0.15); color: var(--secondary-color); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; text-align: center;">
                        <i class="fas fa-check-circle"></i> ${param.success}
                    </div>
                </c:if>

                <c:if test="${not empty error or not empty param.error}">
                    <div
                        style="background: rgba(255, 71, 87, 0.1); color: var(--danger-color); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; text-align: center;">
                        <i class="fas fa-exclamation-circle"></i> ${not empty error ? error : param.error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/auth/login-submit" method="POST" autocomplete="off">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" required autocomplete="off"
                            placeholder="Enter username">
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required autocomplete="new-password"
                            placeholder="Enter password">
                    </div>

                    <div class="form-group" style="display: flex; flex-direction: column; align-items: center;">
                        <label style="align-self: flex-start; margin-bottom: 0.8rem;">Security Verification</label>
                        <!-- Google reCAPTCHA Widget -->
                        <div class="g-recaptcha" data-sitekey="6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"
                            style="transform: scale(0.9); transform-origin: 0 0; margin-bottom: 1rem; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                        </div>
                        <p
                            style="font-size: 0.75rem; color: var(--text-secondary); text-align: center; margin-top: -5px;">
                            <i class="fas fa-shield-alt"></i> Protected by Google reCAPTCHA
                        </p>
                    </div>

                    <!-- reCAPTCHA Script -->
                    <script src="https://www.google.com/recaptcha/api.js" async defer></script>

                    <button type="submit" id="submitBtn" class="btn btn-primary btn-full" style="margin-top: 1rem;">
                        Sign In
                    </button>
                </form>

                <script>
                    document.querySelector('form').addEventListener('submit', function (e) {
                        const btn = document.getElementById('submitBtn');
                        btn.disabled = true;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing In...';
                        btn.style.opacity = '0.7';
                        btn.style.cursor = 'not-allowed';
                    });
                </script>

                <div
                    style="text-align: center; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--border-color);">
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">
                        New here?
                        <a href="${pageContext.request.contextPath}/auth/signup"
                            style="color: var(--primary-color); font-weight: 600;">Create Account</a>
                    </p>
                </div>
            </div>

        </body>

        </html>