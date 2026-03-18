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
                    width: 1100px;
                    max-width: 95%;
                    min-height: 700px;
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
                    flex: 1.4;
                    padding: 4rem 5rem 3rem 5rem;
                    /* Balanced padding */
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    background: transparent;
                    /* Made transparent */
                    position: relative;
                    overflow-y: auto;
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
                    margin-bottom: 2rem;
                }

                .form-row {
                    display: flex;
                    gap: 1rem;
                    margin-bottom: 1rem;
                }

                .form-row .form-group {
                    flex: 1;
                    margin-bottom: 0;
                }

                .form-group {
                    margin-bottom: 1rem;
                }

                .form-group label {
                    color: #cbd5e1;
                    /* Adjusted label color */
                    font-weight: 600;
                    font-size: 0.85rem;
                    margin-bottom: 0.4rem;
                    display: block;
                }

                .form-group input,
                .form-group select {
                    width: 100%;
                    padding: 0.85rem 1rem;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    /* Subtle border */
                    border-radius: 8px;
                    font-size: 0.95rem;
                    transition: all 0.2s;
                    color: #f8fafc;
                    /* Light text color */
                    background: rgba(255, 255, 255, 0.05);
                    /* Transparent background */
                }

                .form-group input:focus,
                .form-group select:focus {
                    border-color: var(--primary-color);
                    outline: none;
                    background: rgba(255, 255, 255, 0.1);
                    box-shadow: 0 0 0 4px rgba(249, 115, 22, 0.15);
                }

                .social-btns {
                    display: flex;
                    justify-content: center;
                    gap: 1.2rem;
                    margin-top: 1.5rem;
                }

                .social-icon {
                    width: 45px;
                    height: 45px;
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
                    font-size: 1.1rem;
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
                    padding: 1rem;
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

                .form-group i {
                    color: #94A3B8;
                }

                .form-group i:hover {
                    color: var(--primary-color);
                }

                .btn-outline-white {
                    border: 2.5px solid white;
                    color: white;
                    background: transparent;
                    padding: 0.8rem 2.8rem;
                    border-radius: 10px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: all 0.3s;
                    font-size: 0.95rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }

                .btn-outline-white:hover {
                    background: white;
                    color: var(--primary-color);
                    transform: scale(1.05);
                }

                @media (max-width: 992px) {
                    .auth-master-wrapper {
                        width: 500px;
                        flex-direction: column;
                        height: auto;
                        margin: 2rem 0;
                    }

                    .hero-panel {
                        clip-path: none;
                        padding: 3rem 1.5rem;
                    }

                    .hero-panel h1 {
                        position: static;
                        margin-bottom: 1.5rem;
                    }

                    .form-panel {
                        padding: 3rem 2rem;
                    }
                }

                .role-tile:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                    border-color: var(--primary-color) !important;
                }
                
                .role-tile i, .role-tile h4 {
                    transition: all 0.3s;
                }
            </style>
        </head>

        <body>

            <div class="auth-master-wrapper">
                <!-- Left Panel -->
                <div class="hero-panel">
                    <h1>EventiaPro</h1>
                    <h2>Already Signed up?</h2>
                    <p>Log in to your account so you can continue building and managing your event profile.</p>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn-outline-white"
                        style="text-decoration: none;">LOG IN</a>
                </div>

                <!-- Right Panel -->
                <div class="form-panel">
                    <h3>Sign Up for an Account</h3>
                    <p class="sub-text">Let's get you all set up so you can start creating your first event experience.
                    </p>
                    

                    <c:if test="${not empty error}">
                        <div
                            style="background: #fef2f2; color: #dc2626; padding: 0.8rem; border-radius: 8px; margin-bottom: 1.5rem; text-align: center; border: 1px solid #f87171; font-size: 0.9rem; font-weight: 500;">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth/signup" method="POST" autocomplete="off">
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" name="username" required placeholder="Choose a unique username">
                        </div>

                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" required placeholder="Enter your email address">
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <div style="position: relative;">
                                <input type="password" id="password" name="password" required
                                    placeholder="Enter a strong password">
                                <i class="far fa-eye-slash"
                                    style="position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); color: #94a3b8; cursor: pointer;"
                                    onclick="togglePass()"></i>
                            </div>
                        </div>

                        <div class="form-group" style="margin-top: 2rem; margin-bottom: 2rem;">
                            <label style="margin-bottom: 1.2rem; display: block; color: #f8fafc; font-weight: 600; font-size: 1.1rem;">Select Your Role</label>
                            <div class="role-selection" style="display: flex; flex-direction: column; gap: 1rem; width: 100%;">
                                <!-- User Tile -->
                                <div class="role-tile" onclick="selectRole('USER', this)" id="user-tile" style="padding: 1.5rem; border: 2px solid var(--primary-color); border-radius: 12px; cursor: pointer; background: rgba(249, 115, 22, 0.15); transition: all 0.3s; display: flex; align-items: center; gap: 1.5rem;">
                                    <div style="width: 50px; height: 50px; background: rgba(249, 115, 22, 0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-user" style="font-size: 1.5rem; color: var(--primary-color);"></i>
                                    </div>
                                    <div style="flex: 1;">
                                        <h4 style="margin: 0; color: #ffffff; font-size: 1.1rem; font-weight: 700;">Join as Attendee (User)</h4>
                                        <p style="margin: 4px 0 0 0; font-size: 0.85rem; color: #cbd5e1;">Discover upcoming events and book tickets easily.</p>
                                    </div>
                                    <i class="fas fa-check-circle" id="user-check" style="font-size: 1.2rem; color: var(--primary-color);"></i>
                                </div>
                                
                                <!-- Admin Tile -->
                                <div class="role-tile" onclick="selectRole('ADMIN', this)" id="admin-tile" style="padding: 1.5rem; border: 2px solid rgba(255,255,255,0.2); border-radius: 12px; cursor: pointer; transition: all 0.3s; display: flex; align-items: center; gap: 1.5rem; background: rgba(255, 255, 255, 0.05);">
                                    <div style="width: 50px; height: 50px; background: rgba(255, 255, 255, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-user-shield" style="font-size: 1.5rem; color: #cbd5e1;"></i>
                                    </div>
                                    <div style="flex: 1;">
                                        <h4 style="margin: 0; color: #cbd5e1; font-size: 1.1rem; font-weight: 600;">Join as Organizer (Admin)</h4>
                                        <p style="margin: 4px 0 0 0; font-size: 0.85rem; color: #94a3b8;">Create events, manage tickets, and track registrations.</p>
                                    </div>
                                    <i class="fas fa-check-circle" id="admin-check" style="font-size: 1.2rem; color: transparent;"></i>
                                </div>
                            </div>
                            <input type="hidden" name="role" id="roleInput" value="USER">
                        </div>

                        <div class="form-group"
                            style="display: flex; align-items: center; gap: 0.8rem; margin-top: 1rem; padding: 0.8rem; background: rgba(255, 255, 255, 0.03); border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.1);">
                            <input type="checkbox" name="twoFactorEnabled" id="twoFactorEnabled"
                                style="width: auto; cursor: pointer;">
                            <label for="twoFactorEnabled"
                                style="margin: 0; font-size: 0.85rem; cursor: pointer; color: #cbd5e1;">Enable
                                Two-Factor Authentication</label>
                        </div>

                        <button type="submit" id="signupBtn" class="btn-auth">
                            SIGN UP
                        </button>
                    </form>

                    <div style="text-align: center; margin-top: 1.5rem; position: relative;">
                        <span
                            style="background: #1e293b; padding: 0 12px; color: #94a3b8; font-size: 0.8rem; z-index: 2; position: relative;">Or
                            sign up using</span>
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
                function selectRole(role, element) {
                    // Update hidden input
                    document.getElementById('roleInput').value = role;
                    
                    // Reset all tiles
                    document.querySelectorAll('.role-tile').forEach(tile => {
                        tile.style.borderColor = 'rgba(255,255,255,0.2)';
                        tile.style.background = 'rgba(255, 255, 255, 0.05)';
                        tile.style.borderWidth = '2px';
                        tile.querySelector('h4').style.color = '#cbd5e1';
                        tile.querySelector('h4').style.fontWeight = '600';
                        tile.querySelector('i').style.color = '#cbd5e1';
                        tile.querySelector('p').style.color = '#94a3b8';
                        // Reset check icon
                        const checkIcon = tile.querySelector('.fa-check-circle');
                        if (checkIcon) checkIcon.style.color = 'transparent';
                    });
                    
                    // Highlight selected tile
                    element.style.borderColor = 'var(--primary-color)';
                    element.style.background = 'rgba(249, 115, 22, 0.15)';
                    element.querySelector('h4').style.color = '#ffffff';
                    element.querySelector('h4').style.fontWeight = '700';
                    element.querySelector('i').style.color = 'var(--primary-color)';
                    element.querySelector('p').style.color = '#cbd5e1';
                    // Show check icon
                    const checkIcon = element.querySelector('.fa-check-circle');
                    if (checkIcon) checkIcon.style.color = 'var(--primary-color)';
                }

                // Handle pre-selected role from URL
                window.onload = function() {
                    const urlParams = new URLSearchParams(window.location.search);
                    const role = urlParams.get('role');
                    if (role === 'ADMIN') {
                        selectRole('ADMIN', document.getElementById('admin-tile'));
                    }
                };

                function togglePass() {
                    const pass = document.getElementById('password');
                    const icon = event.target;
                    if (pass.type === 'password') {
                        pass.type = 'text';
                        icon.classList.replace('fa-eye-slash', 'fa-eye');
                    } else {
                        pass.type = 'password';
                        icon.classList.replace('fa-eye', 'fa-eye-slash');
                    }
                }

                document.querySelector('form').addEventListener('submit', function (e) {
                    const btn = document.getElementById('signupBtn');
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> CREATING ACCOUNT...';
                });
            </script>
        </body>

        </html>