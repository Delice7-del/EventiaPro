<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sign Up - EventiaPro</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body style="display: flex; align-items: center; justify-content: center; min-height: 100vh;">

            <div class="glass-card" style="width: 380px; padding: 2rem; margin: 2rem 0;">
                <div style="text-align: center; margin-bottom: 1.5rem;">
                    <h2 style="color: var(--primary-color); font-weight: 700;">EventiaPro</h2>
                    <p style="color: var(--text-secondary); margin-top: 5px;">Create your account</p>
                </div>

                <c:if test="${not empty error}">
                    <div
                        style="background: rgba(255, 71, 87, 0.1); color: var(--danger-color); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; text-align: center;">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/auth/signup" method="POST" autocomplete="off">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" required autocomplete="off"
                            placeholder="Choose a username">
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" required autocomplete="off"
                            placeholder="name@example.com">
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required autocomplete="new-password"
                            placeholder="Create password">
                    </div>

                    <div class="form-group">
                        <label>I want to...</label>
                        <select name="role">
                            <option value="USER">Join Events (Participant)</option>
                            <option value="ADMIN">Host Events (Organizer)</option>
                        </select>
                    </div>

                    <div class="form-group"
                        style="display: flex; align-items: start; gap: 0.8rem; margin-top: 1rem; padding: 0.8rem; background: rgba(255,255,255,0.03); border-radius: 8px; border: 1px solid var(--border-color);">
                        <input type="checkbox" name="twoFactorEnabled" id="twoFactorEnabled"
                            style="width: auto; margin-top: 3px;">
                        <div>
                            <label for="twoFactorEnabled" style="margin: 0; font-weight: 600; cursor: pointer;">Enable
                                Two-Factor Authentication</label>
                            <p style="font-size: 0.75rem; color: var(--text-secondary); margin: 0;">Highly recommended.
                                You'll receive a secure code via email for every login.</p>
                        </div>
                    </div>

                    <button type="submit" id="signupBtn" class="btn btn-primary btn-full" style="margin-top: 1rem;">
                        Sign Up
                    </button>
                </form>

                <script>
                    document.querySelector('form').addEventListener('submit', function (e) {
                        const btn = document.getElementById('signupBtn');
                        btn.disabled = true;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
                        btn.style.opacity = '0.7';
                        btn.style.cursor = 'not-allowed';
                    });
                </script>

                <div
                    style="text-align: center; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--border-color);">
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">
                        Already have an account?
                        <a href="${pageContext.request.contextPath}/auth/login"
                            style="color: var(--primary-color); font-weight: 600;">Log In</a>
                    </p>
                </div>
            </div>

        </body>

        </html>