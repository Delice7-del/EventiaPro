<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Verify OTP - EventiaPro</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body style="display: flex; align-items: center; justify-content: center; min-height: 100vh;">

            <div class="glass-card" style="width: 420px; padding: 3.5rem 3rem; text-align: center; margin-top: 100px;"> <!-- Increased top margin to balance space -->
                <div style="margin-bottom: 2rem;">
                    <div
                        style="width: 80px; height: 80px; background: rgba(30, 144, 255, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem;">
                        <i class="fas fa-shield-alt" style="font-size: 2.5rem; color: var(--primary-color);"></i>
                    </div>
                    <h2 style="color: var(--primary-color); font-weight: 700; margin-bottom: 0.5rem;">Two-Factor
                        Authentication</h2>
                    <p style="color: var(--text-secondary); font-size: 0.95rem;">
                        We've sent a 6-digit code **strictly to your registered email**. Please enter it below to
                        continue.
                    </p>
                </div>

                <c:if test="${not empty error}">
                    <div
                        style="background: rgba(255, 71, 87, 0.1); color: var(--danger-color); padding: 0.8rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.9rem;">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>


                <form action="${pageContext.request.contextPath}/auth/verify-otp" method="POST" style="margin-top: 2rem;">
                    <div class="form-group" style="text-align: left; margin-bottom: 2rem;">
                        <label for="otp" style="display: block; margin-bottom: 1rem; font-weight: 600; color: var(--text-primary);">Enter Code Below</label>
                        <input type="text" id="otp" name="otp" required placeholder="000000" maxlength="6"
                            style="text-align: center; letter-spacing: 0.8rem; font-size: 1.5rem; font-weight: 800; padding: 1.2rem; border-radius: 12px; border: 2px solid var(--border-color);">
                    </div>

                    <button type="submit" class="btn btn-primary btn-full" style="padding: 1.2rem; font-size: 1.1rem; border-radius: 12px;">
                        Confirm & Access Account
                    </button>
                </form>

                <div style="margin-top: 3rem; padding-top: 2rem; border-top: 1px solid var(--border-color);">
                    <p style="color: var(--text-secondary); font-size: 0.95rem;">
                        Didn't receive the code?
                        <a href="${pageContext.request.contextPath}/auth/login"
                            style="color: var(--primary-color); font-weight: 600; margin-left: 0.5rem; text-decoration: underline;">Go Back</a>
                    </p>
                </div>
            </div>

        </body>

        </html>