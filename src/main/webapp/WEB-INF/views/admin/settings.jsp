<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page isErrorPage="true" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin Settings – EventiaPro</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
                    .settings-section {
                        display: none;
                    }

                    .settings-section.active {
                        display: block !important;
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
                                <h2>Admin Settings</h2>
                                <p>Configure platform-wide preferences and admin account</p>
                            </div>
                        </div>

                        <div class="settings-container" style="display: flex; gap: 2rem; margin-top: 2rem;">
                            <div class="settings-nav-card glass-card"
                                style="width: 280px; padding: 1.5rem; height: fit-content;">
                                <button type="button" class="nav-item-btn active"
                                    onclick="switchSettings('profile', this)">
                                    <i class="fas fa-user-shield"></i> Admin Profile
                                </button>
                                <button type="button" class="nav-item-btn" onclick="switchSettings('security', this)">
                                    <i class="fas fa-key"></i> Passwords
                                </button>
                                <button type="button" class="nav-item-btn"
                                    onclick="switchSettings('notifications', this)">
                                    <i class="fas fa-satellite-dish"></i> Alerts
                                </button>
                                <button type="button" class="nav-item-btn"
                                    onclick="switchSettings('preferences', this)">
                                    <i class="fas fa-cogs"></i> Preferences
                                </button>
                            </div>

                            <div class="settings-main" style="flex: 1;">
                                <div id="set-profile" class="settings-section active">
                                    <div class="glass-card" style="padding: 2.5rem;">
                                        <h3
                                            style="margin-bottom: 2rem; display: flex; align-items: center; gap: 0.8rem;">
                                            <i class="fas fa-id-badge" style="color: var(--primary-color);"></i>
                                            Administrative Details
                                        </h3>
                                        <form action="${pageContext.request.contextPath}/admin/settings/update-profile"
                                            method="POST">
                                            <div class="form-group"><label>Admin Name</label><input type="text"
                                                    name="name" value="${sessionScope.user.username}" required></div>
                                            <div class="form-group"><label>System Email</label><input type="email"
                                                    name="email" value="${sessionScope.user.email}" readonly
                                                    style="cursor: not-allowed; opacity: 0.7;"></div>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Save Admin Info</button>
                                    </form>
                                </div>
                            </div>

                            <div id="set-security" class="settings-section">
                                <div class="glass-card" style="padding: 2.5rem;">
                                    <h3 style="margin-bottom: 2rem; display: flex; align-items: center; gap: 0.8rem;">
                                        <i class="fas fa-user-lock" style="color: var(--primary-color);"></i> Access
                                        Security
                                    </h3>
                                    <form action="${pageContext.request.contextPath}/admin/settings/update-password"
                                        method="POST">
                                        <div class="form-group"><label>Current Password</label><input type="password"
                                                name="currentPassword" required></div>
                                        <div class="form-group"><label>New Secure Password</label><input type="password"
                                                name="newPassword" required></div>
                                        <button type="submit" class="btn btn-primary">Update Security</button>
                                    </form>
                                </div>
                            </div>

                            <div id="set-notifications" class="settings-section">
                                <div class="glass-card" style="padding: 2.5rem;">
                                    <h3 style="margin-bottom: 2rem; display: flex; align-items: center; gap: 0.8rem;">
                                        <i class="fas fa-exclamation-triangle" style="color: var(--primary-color);"></i>
                                        System Alerts
                                    </h3>
                                    <form
                                        action="${pageContext.request.contextPath}/admin/settings/update-notifications"
                                        method="POST">
                                        <label class="checkbox-label"
                                            style="display: flex; align-items: center; gap: 1rem; cursor: pointer; padding: 1.2rem; background: rgba(255,255,255,0.03); border-radius: 12px; border: 1px solid var(--border-color); margin-bottom: 1rem;">
                                            <input type="checkbox" name="systemErrors" checked
                                                style="width: 1.2rem; height: 1.2rem;">
                                            <div>
                                                <p style="font-weight: 500; margin: 0;">Critical System Errors</p>
                                            </div>
                                        </label>
                                        <button type="submit" class="btn btn-primary">Apply Settings</button>
                                    </form>
                                </div>
                            </div>

                            <div id="set-preferences" class="settings-section">
                                <div class="glass-card" style="padding: 2.5rem;">
                                    <h3 style="margin-bottom: 2rem; display: flex; align-items: center; gap: 0.8rem;">
                                        <i class="fas fa-toolbox" style="color: var(--primary-color);"></i> Platform
                                        Configuration
                                    </h3>
                                    <form action="${pageContext.request.contextPath}/admin/settings/update-preferences"
                                        method="POST">
                                        <div
                                            style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">
                                            <div class="form-group"><label>Language</label><select name="language"
                                                    class="form-select">
                                                    <option value="en">English</option>
                                                </select></div>
                                            <div class="form-group"><label>Theme</label><select name="theme"
                                                    class="form-select">
                                                    <option value="dark">Dark</option>
                                                </select></div>
                                        </div>
                                        <button type="submit" class="btn btn-primary">Save Preferences</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                </div>
                </main>
                </div>

                <script>
                    function showToast(message, type = 'success') {
                        const container = document.getElementById('toast-container');
                        const toast = document.createElement('div');
                        toast.className = `toast ${type}`;
                        const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
                        toast.innerHTML = `<i class="fas ${icon}"></i><span>${message}</span>`;
                        container.appendChild(toast);
                        setTimeout(() => toast.classList.add('show'), 100);
                        setTimeout(() => {
                            toast.classList.remove('show');
                            setTimeout(() => toast.remove(), 500);
                        }, 4000);
                    }

                    window.onload = () => {
                        const params = new URLSearchParams(window.location.search);
                        const success = params.get('success');
                        if (success) showToast(success, 'success');
                    };

                    function switchSettings(sectionId, btn) {
                        document.querySelectorAll('.settings-section').forEach(s => s.classList.remove('active'));
                        document.getElementById('set-' + sectionId).classList.add('active');
                        document.querySelectorAll('.nav-item-btn').forEach(n => n.classList.remove('active'));
                        if (btn) btn.classList.add('active');
                    }
                </script>
            </body>

            </html>