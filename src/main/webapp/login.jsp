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
            <style>
                body {
                    margin: 0;
                    padding: 40px 0;
                    background: #1e293b;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    min-height: 100vh;
                    color: #333;
                    font-family: 'Poppins', sans-serif;
                    box-sizing: border-box;
                }

                .auth-master-wrapper {
                    width: 1000px;
                    max-width: 95%;
                    min-height: 600px;
                    /* Dynamic height */
                    height: auto;
                    background: rgba(30, 41, 59, 0.7);
                    /* Applied transparency */
                    backdrop-filter: blur(10px);
                    /* Added blur for premium feel */
                    border-radius: 12px;
                    overflow: hidden;
                    display: flex;
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
                    margin: 40px 20px;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                }

                /* Left Hero Panel */
                .hero-panel {
                    flex: 1;
                    background: var(--primary-color);
                    position: relative;
                    clip-path: polygon(0 0, 100% 0, 85% 100%, 0% 100%);
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    padding: 3rem;
                    color: white;
                    text-align: center;
                    z-index: 2;
                }

                .hero-panel h1 {
                    font-size: 2.2rem;
                    margin-bottom: 3rem;
                    align-self: flex-start;
                    position: absolute;
                    top: 2rem;
                    left: 2rem;
                    font-weight: 700;
                    color: white;
                }

                .hero-panel h2 {
                    font-size: 2.2rem;
                    margin-bottom: 1rem;
                    font-weight: 700;
                }

                .hero-panel p {
                    opacity: 0.9;
                    margin-bottom: 2rem;
                    line-height: 1.6;
                    max-width: 320px;
                    font-size: 1.1rem;
                }

                /* Right Form Panel */
                .form-panel {
                    flex: 1.2;
                    padding: 4rem 4rem 3rem 4rem;
                    /* Balanced padding */
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    background: transparent;
                    /* Made transparent */
                    position: relative;
                    color: #f8fafc;
                    /* Changed to light color */
                }

                .form-panel h3 {
                    font-size: 1.8rem;
                    font-weight: 700;
                    margin-bottom: 0.5rem;
                    color: #f8fafc;
                    /* Changed to light color */
                    text-align: center;
                }

                .form-panel .sub-text {
                    color: #94a3b8;
                    /* Adjusted sub-text color */
                    font-size: 0.95rem;
                    text-align: center;
                    margin-bottom: 2.5rem;
                }

                .form-group {
                    margin-bottom: 1.2rem;
                }

                .form-group label {
                    color: #cbd5e1;
                    /* Adjusted label color */
                    font-weight: 600;
                    font-size: 0.9rem;
                    margin-bottom: 0.5rem;
                    display: block;
                }

                .form-group input {
                    width: 100%;
                    padding: 0.9rem 1.2rem;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    /* Subtle border */
                    border-radius: 8px;
                    font-size: 1rem;
                    transition: all 0.2s;
                    color: #f8fafc;
                    /* Light text color */
                    background: rgba(255, 255, 255, 0.05);
                    /* Transparent background */
                }

                .form-group input:focus {
                    border-color: var(--primary-color);
                    outline: none;
                    background: rgba(255, 255, 255, 0.1);
                    box-shadow: 0 0 0 4px rgba(249, 115, 22, 0.15);
                }

                .social-btns {
                    display: flex;
                    justify-content: center;
                    gap: 1.5rem;
                    margin-top: 2rem;
                }

                .social-icon {
                    width: 50px;
                    height: 50px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border: 1px solid #e2e8f0;
                    /* Reverted border */
                    border-radius: 10px;
                    color: #64748b;
                    /* Reverted icon color */
                    transition: all 0.2s;
                    cursor: pointer;
                    font-size: 1.2rem;
                    background: transparent;
                }

                .social-icon:hover {
                    background: #f1f5f9;
                    color: var(--primary-color);
                    border-color: var(--primary-color);
                    transform: translateY(-3px);
                }

                .btn-auth {
                    background: var(--primary-color);
                    color: white;
                    border: none;
                    padding: 1.1rem;
                    border-radius: 8px;
                    font-weight: 700;
                    width: 100%;
                    margin-top: 1.5rem;
                    cursor: pointer;
                    transition: all 0.3s;
                    font-size: 1rem;
                    letter-spacing: 0.5px;
                }

                .btn-auth:hover {
                    background: var(--primary-hover);
                    transform: translateY(-2px);
                    box-shadow: 0 10px 20px rgba(249, 115, 22, 0.2);
                }

                .btn-outline-white {
                    border: 2.5px solid white;
                    color: white;
                    background: transparent;
                    padding: 0.9rem 3rem;
                    border-radius: 10px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: all 0.3s;
                    font-size: 1rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }

                .btn-outline-white:hover {
                    background: white;
                    color: var(--primary-color);
                    transform: scale(1.05);
                }

                @media (max-width: 768px) {
                    .auth-master-wrapper {
                        flex-direction: column;
                        height: auto;
                        width: 450px;
                    }

                    .hero-panel {
                        clip-path: none;
                        padding: 2.5rem 1.5rem;
                    }

                    .hero-panel h1 {
                        position: static;
                        margin-bottom: 1.5rem;
                    }

                    .form-panel {
                        padding: 3rem 2rem;
                    }
                }
            </style>
        </head>

        <body>

            <div class="auth-master-wrapper">
                <!-- Left Panel -->
                <div class="hero-panel">
                    <h1>EventiaPro</h1>
                    <h2>New to us?</h2>
                    <p>Sign up now to start discovering and organizing the best events in town.</p>
                    <a href="${pageContext.request.contextPath}/auth/signup" class="btn-outline-white"
                        style="text-decoration: none;">SIGN UP</a>
                </div>

                <!-- Right Panel -->
                <div class="form-panel">
                    <h3>Welcome Back</h3>
                    <p class="sub-text">Please enter your details to sign in and manage your events.</p>

                    <c:if test="${not empty param.success}">
                        <div
                            style="background: #ecfdf5; color: #059669; padding: 0.9rem; border-radius: 8px; margin-bottom: 2rem; text-align: center; border: 1px solid #10b981; font-size: 0.95rem; font-weight: 500;">
                            <i class="fas fa-check-circle"></i> ${param.success}
                        </div>
                    </c:if>

                    <c:if test="${not empty error or not empty param.error}">
                        <div
                            style="background: #fef2f2; color: #dc2626; padding: 0.9rem; border-radius: 8px; margin-bottom: 2rem; text-align: center; border: 1px solid #f87171; font-size: 0.95rem; font-weight: 500;">
                            <i class="fas fa-exclamation-circle"></i> ${not empty error ? error : param.error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth/login-submit" method="POST"
                        autocomplete="off">
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" name="username" required placeholder="Enter your username">
                        </div>
                        <div class="form-group">
                            <label>Password</label>
                            <input type="password" name="password" required placeholder="Enter password">
                        </div>

                        <div class="form-group"
                            style="display: flex; flex-direction: column; align-items: flex-start; margin-top: 1rem;">
                            <div class="g-recaptcha" data-sitekey="6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"
                                style="transform: scale(0.9); transform-origin: left;"></div>
                        </div>

                        <script src="https://www.google.com/recaptcha/api.js" async defer></script>

                        <button type="submit" id="submitBtn" class="btn-auth">
                            LOG IN
                        </button>
                    </form>

                    <div style="text-align: center; margin-top: 2rem; position: relative;">
                        <span
                            style="background: #1e293b; padding: 0 15px; color: #94a3b8; font-size: 0.85rem; z-index: 2; position: relative;">Or
                            sign in using</span>
                        <div
                            style="position: absolute; top: 50%; left: 0; right: 0; height: 1px; background: rgba(255, 255, 255, 0.1); z-index: 1;">
                        </div>
                    </div>

                    <div class="social-btns">
                        <div class="social-icon" title="Google"><i class="fab fa-google" style="color: #ea4335;"></i>
                        </div>
                        <div class="social-icon" title="Facebook"><i class="fab fa-facebook-f"
                                style="color: #1877f2;"></i></div>
                        <div class="social-icon" title="Twitter"><i class="fab fa-twitter" style="color: #1da1f2;"></i>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                document.querySelector('form').addEventListener('submit', function (e) {
                    const btn = document.getElementById('submitBtn');
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> SIGNING IN...';
                });
            </script>
        </body>

        </html>