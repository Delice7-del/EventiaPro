<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page isErrorPage="true" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Settings – EventiaPro</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                <script>
                    function showToast(message, type) {
                        console.log("Triggering toast:", message, type);
                        const container = document.getElementById('toast-container');
                        if (!container) {
                            console.error("Toast container not found!");
                            return;
                        }

                        const toast = document.createElement('div');
                        toast.className = 'toast ' + (type || 'success');

                        const icon = (type === 'error') ? 'fa-exclamation-circle' : 'fa-check-circle';
                        toast.innerHTML = '<i class="fas ' + icon + '"></i><span>' + message + '</span>';

                        container.appendChild(toast);

                        // Force a reflow to ensure the transition works
                        toast.offsetHeight;

                        // Show the toast
                        toast.classList.add('show');

                        // Remove after delay
                        setTimeout(() => {
                            toast.classList.remove('show');
                            setTimeout(() => {
                                if (toast.parentNode) toast.parentNode.removeChild(toast);
                            }, 500);
                        }, 4000);
                    }

                    function switchSettings(sectionId, btn) {
                        const sections = document.querySelectorAll('.settings-section');
                        sections.forEach(s => {
                            s.classList.remove('active');
                            s.style.display = 'none';
                        });

                        const targetSection = document.getElementById('set-' + sectionId);
                        if (targetSection) {
                            targetSection.classList.add('active');
                            targetSection.style.display = 'block';
                        }

                        const navItems = document.querySelectorAll('.nav-item-btn');
                        navItems.forEach(n => n.classList.remove('active'));
                        if (btn) {
                            btn.classList.add('active');
                        } else {
                            const fallbackBtn = document.querySelector('.nav-item-btn[onclick*="' + sectionId + '"]');
                            if (fallbackBtn) fallbackBtn.classList.add('active');
                        }
                    }

                    document.addEventListener('DOMContentLoaded', () => {
                        console.log("Settings page loaded. checking for status messages...");
                        const params = new URLSearchParams(window.location.search);
                        const success = params.get('success');
                        const error = params.get('error');
                        const section = params.get('section');

                        if (success) showToast(success, 'success');
                        if (error) showToast(error, 'error');

                        if (section) {
                            console.log("Restoring section:", section);
                            switchSettings(section, null);
                        }

                        // Clean URL without refresh
                        if (success || error || section) {
                            const newUrl = window.location.pathname;
                            window.history.replaceState({}, document.title, newUrl);
                        }
                    });
                </script>

                <style>
                    .settings-section {
                        display: none;
                    }

                    .settings-section.active {
                        display: block !important;
                    }

                    .settings-nav-card {
                        height: fit-content;
                    }

                    .nav-item-btn {
                        width: 100%;
                        padding: 1rem 1.2rem;
                        border: none;
                        background: rgba(255, 255, 255, 0.03);
                        color: var(--text-secondary);
                        cursor: pointer;
                        text-align: left;
                        border-radius: 8px;
                        transition: 0.3s;
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                        margin-bottom: 0.5rem;
                        font-family: inherit;
                        font-size: 0.95rem;
                    }

                    .nav-item-btn:hover {
                        background: rgba(255, 255, 255, 0.08);
                        color: var(--text-primary);
                    }

                    .nav-item-btn.active {
                        background: var(--primary-color);
                        color: white;
                        box-shadow: 0 4px 15px rgba(249, 115, 22, 0.4);
                    }

                    .form-select {
                        width: 100%;
                        padding: 0.8rem;
                        background: rgba(0, 0, 0, 0.05);
                        border: 1px solid var(--border-color);
                        border-radius: 8px;
                        color: var(--text-primary);
                        outline: none;
                    }

                    /* Toast Styles */
                    .toast-container {
                        position: fixed;
                        top: 2rem;
                        right: 2rem;
                        z-index: 9999;
                        display: flex;
                        flex-direction: column;
                        gap: 1rem;
                    }

                    .toast {
                        min-width: 300px;
                        padding: 1rem 1.5rem;
                        border-radius: 12px;
                        background: rgba(15, 23, 42, 0.9);
                        backdrop-filter: blur(10px);
                        border: 1px solid rgba(255, 255, 255, 0.1);
                        color: white;
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
                        transform: translateX(120%);
                        transition: transform 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
                    }

                    .toast.show {
                        transform: translateX(0);
                    }

                    .toast.success {
                        border-left: 4px solid var(--primary-color);
                    }

                    .toast.error {
                        border-left: 4px solid var(--danger-color);
                    }

                    .toast i {
                        font-size: 1.2rem;
                    }

                    .toast.success i {
                        color: var(--primary-color);
                    }

                    .toast.error i {
                        color: var(--danger-color);
                    }
                </style>
            </head>

            <body>
                <div id="toast-container" class="toast-container"></div>
                <div class="app-container">
                    <jsp:include page="sidebar.jsp">
                        <jsp:param name="activePage" value="settings" />
                    </jsp:include>

                    <main class="main-content">
                        <div class="page-header">
                            <div>
                                <h2>Settings</h2>
                                <p>Manage your account preferences and preferences</p>
                            </div>
                        </div>

                        <div class="settings-container" style="display: flex; gap: 2rem; margin-top: 2rem;">
                            <!-- SIDEBAR NAV -->
                            <div class="settings-nav-card glass-card" style="width: 280px; padding: 1.5rem;">
                                <button type="button" class="nav-item-btn active"
                                    onclick="switchSettings('profile', this)">
                                    <i class="far fa-user"></i> Edit Profile
                                </button>
                                <button type="button" class="nav-item-btn" onclick="switchSettings('security', this)">
                                    <i class="fas fa-shield-alt"></i> Security
                                </button>
                                <button type="button" class="nav-item-btn"
                                    onclick="switchSettings('notifications', this)">
                                    <i class="far fa-bell"></i> Notifications
                                </button>
                                <button type="button" class="nav-item-btn"
                                    onclick="switchSettings('preferences', this)">
                                    <i class="fas fa-sliders-h"></i> Preferences
                                </button>
                            </div>

                            <!-- CONTENT -->
                            <div class="settings-main" style="flex: 1;">
                                <!-- PROFILE -->
                                <div id="set-profile" class="settings-section active">
                                    <div class="glass-card" style="padding: 2.5rem;">
                                        <h3
                                            style="margin-bottom: 2rem; display: flex; align-items: center; gap: 0.8rem;">
                                            <i class="fas fa-user-circle" style="color: var(--primary-color);"></i> Edit
                                            Profile
                                        </h3>

                                        <form action="${pageContext.request.contextPath}/user/settings/update-profile"
                                            method="POST">
                                            <div class="form-group" style="margin-bottom: 1.5rem;">
                                                <label>Full Name</label>
                                                <input type="text" name="name" value="${sessionScope.user.username}"
                                                    placeholder="Your Full Name">
                                            </div>
                                            <div class="form-group" style="margin-bottom: 1.5rem;">
                                                <label>Email Address</label>
                                                <input type="email" name="email" value="${sessionScope.user.email}"
                                                    readonly style="cursor: not-allowed; opacity: 0.7;">
                                            </div>
                                            <div class="form-group" style="margin-bottom: 2.5rem;">
                                                <label>Profile Picture</label>
                                                <input type="file" name="profilePic" class="btn btn-outline"
                                                    style="width: 100%; text-align: left; background: transparent;">
                                            </div>
                                            <button type="submit" class="btn btn-primary">Save Changes</button>
                                        </form>
                                    </div>
                                </div>

                                <!-- SECURITY -->
                                <div id="set-security" class="settings-section">
                                    <div class="glass-card" style="padding: 2.5rem;">
                                        <h3
                                            style="margin-bottom: 2rem; display: flex; align-items: center; gap: 0.8rem;">
                                            <i class="fas fa-lock" style="color: var(--primary-color);"></i> Password &
                                            Security
                                        </h3>
                                        <form action="${pageContext.request.contextPath}/user/settings/update-password"
                                            method="POST">
                                            <div class="form-group" style="margin-bottom: 1.5rem;">
                                                <label>Current Password</label>
                                                <input type="password" name="currentPassword" placeholder="••••••••">
                                            </div>
                                            <div class="form-group" style="margin-bottom: 2rem;">
                                                <label>New Password</label>
                                                <input type="password" name="newPassword" placeholder="••••••••">
                                            </div>
                                            <button type="submit" class="btn btn-primary">Change Password</button>
                                        </form>

                                        <div
                                            style="margin-top: 3.5rem; padding-top: 2rem; border-top: 1px solid var(--border-color);">
                                            <h4
                                                style="margin-bottom: 1rem; display: flex; align-items: center; gap: 0.8rem;">
                                                <i class="fas fa-shield-alt" style="color: var(--primary-color);"></i>
                                                Two-Factor Authentication (2FA)
                                            </h4>
                                            <p
                                                style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.5rem;">
                                                Enhance your account security. When 2FA is enabled, you'll need to enter
                                                a code sent to
                                                <strong>${sessionScope.user.email}</strong> every time you log in.
                                            </p>

                                            <div
                                                style="display: flex; align-items: center; justify-content: space-between; padding: 1.2rem; background: rgba(255,255,255,0.03); border-radius: 12px; border: 1px solid var(--border-color);">
                                                <div>
                                                    <p style="font-weight: 600; margin: 0;">2FA Verification Status</p>
                                                    <p
                                                        style="font-size: 0.85rem; color: var(--text-secondary); margin: 0;">
                                                        Codes are delivered strictly via Email. No phone required.
                                                    </p>
                                                </div>
                                                <div style="display: flex; align-items: center; gap: 1rem;">
                                                    <span
                                                        class="badge ${sessionScope.user.isTwoFactorEnabled() ? 'badge-success' : 'badge-danger'}"
                                                        style="padding: 0.4rem 0.8rem; border-radius: 20px; font-size: 0.75rem; text-transform: uppercase; font-weight: 700;">
                                                        ${sessionScope.user.isTwoFactorEnabled() ? 'Protected' : 'Off'}
                                                    </span>
                                                    <button
                                                        onclick="window.location='${pageContext.request.contextPath}/user/settings/toggle-2fa'"
                                                        class="btn ${sessionScope.user.isTwoFactorEnabled() ? 'btn-outline' : 'btn-primary'}"
                                                        style="padding: 0.5rem 1rem; font-size: 0.9rem;">
                                                        ${sessionScope.user.isTwoFactorEnabled() ? 'Disable' : 'Enable'}
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- NOTIFICATIONS -->
                                <div id="set-notifications" class="settings-section">
                                    <div class="glass-card" style="padding: 2.5rem;">
                                        <h3
                                            style="margin-bottom: 2rem; display: flex; align-items: center; gap: 0.8rem;">
                                            <i class="fas fa-bell" style="color: var(--primary-color);"></i>
                                            Notification Preferences
                                        </h3>
                                        <form
                                            action="${pageContext.request.contextPath}/user/settings/update-notifications"
                                            method="POST">
                                            <div
                                                style="display: flex; flex-direction: column; gap: 1.2rem; margin-bottom: 2.5rem;">
                                                <label class="checkbox-label"
                                                    style="display: flex; align-items: center; gap: 1rem; cursor: pointer; padding: 1.2rem; background: rgba(255,255,255,0.03); border-radius: 12px; border: 1px solid var(--border-color);">
                                                    <input type="checkbox" name="eventReminders" checked
                                                        style="accent-color: var(--primary-color); width: 1.2rem; height: 1.2rem;">
                                                    <div>
                                                        <p style="font-weight: 500; margin: 0;">Event Reminders</p>
                                                        <p
                                                            style="font-size: 0.85rem; color: var(--text-secondary); margin: 0;">
                                                            Get notified about upcoming events you've joined.</p>
                                                    </div>
                                                </label>
                                                <label class="checkbox-label"
                                                    style="display: flex; align-items: center; gap: 1rem; cursor: pointer; padding: 1.2rem; background: rgba(255,255,255,0.03); border-radius: 12px; border: 1px solid var(--border-color);">
                                                    <input type="checkbox" name="updates" checked
                                                        style="accent-color: var(--primary-color); width: 1.2rem; height: 1.2rem;">
                                                    <div>
                                                        <p style="font-weight: 500; margin: 0;">News & Updates</p>
                                                        <p
                                                            style="font-size: 0.85rem; color: var(--text-secondary); margin: 0;">
                                                            Stay in the loop with platform improvements.</p>
                                                    </div>
                                                </label>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Save Preferences</button>
                                        </form>
                                    </div>
                                </div>

                                <!-- PREFERENCES -->
                                <div id="set-preferences" class="settings-section">
                                    <div class="glass-card" style="padding: 2.5rem;">
                                        <h3
                                            style="margin-bottom: 2rem; display: flex; align-items: center; gap: 0.8rem;">
                                            <i class="fas fa-cog" style="color: var(--primary-color);"></i> App
                                            Preferences
                                        </h3>
                                        <form
                                            action="${pageContext.request.contextPath}/user/settings/update-preferences"
                                            method="POST">
                                            <div
                                                style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 2.5rem;">
                                                <div class="form-group">
                                                    <label>Language</label>
                                                    <select name="language" class="form-select">
                                                        <option value="en">English</option>
                                                        <option value="fr">French</option>
                                                        <option value="rw">Kinyarwanda</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label>Theme Choice</label>
                                                    <select name="theme" class="form-select">
                                                        <option value="dark">Dark (Standard)</option>
                                                        <option value="light">Light</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group" style="margin-bottom: 2.5rem;">
                                                <label>Location Preference</label>
                                                <input type="text" name="location" placeholder="City, Country"
                                                    value="Kigali, Rwanda">
                                            </div>
                                            <button type="submit" class="btn btn-primary">Save Preferences</button>
                                        </form>

                                        <div
                                            style="margin-top: 3.5rem; padding-top: 2rem; border-top: 1px solid var(--border-color);">
                                            <h4 style="margin-bottom: 1.5rem; color: var(--danger-color);">Account
                                                Management</h4>
                                            <div style="display: flex; gap: 1rem;">
                                                <a href="${pageContext.request.contextPath}/logout"
                                                    class="btn btn-outline" style="flex: 1; text-align: center;">
                                                    <i class="fas fa-sign-out-alt"></i> Logout
                                                </a>
                                                <button class="btn btn-danger" style="flex: 1;"
                                                    onclick="if(confirm('Permanently delete your account?')) window.location='${pageContext.request.contextPath}/user/settings/delete-account'">
                                                    <i class="fas fa-trash-alt"></i> Delete Account
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </body>

            </html>