<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <aside class="sidebar">
            <div class="logo">
                <i class="fas fa-layer-group"></i> EventiaPro <span
                    style="font-size: 0.6rem; background: var(--primary-color); padding: 2px 6px; border-radius: 4px; vertical-align: top;">ADMIN</span>
            </div>

            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                        class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
                        <i class="fas fa-th-large"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/analytics"
                        class="nav-link ${activePage == 'analytics' ? 'active' : ''}">
                        <i class="fas fa-chart-line"></i> Analytics
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users"
                        class="nav-link ${activePage == 'users' ? 'active' : ''}">
                        <i class="fas fa-users"></i> Users
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/messages"
                        class="nav-link ${activePage == 'messages' ? 'active' : ''}">
                        <i class="fas fa-envelope"></i> Messages
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/settings"
                        class="nav-link ${activePage == 'settings' ? 'active' : ''}">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                </li>
                <li style="margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/auth/logout" style="color: var(--danger-color);">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </aside>