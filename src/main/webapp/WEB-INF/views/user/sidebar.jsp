<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <aside class="sidebar">
            <div class="logo">
                <i class="fas fa-layer-group"></i> EventiaPro
            </div>

            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/user/discover"
                        class="nav-link ${activePage == 'discover' ? 'active' : ''}">
                        <i class="fas fa-compass"></i> Discover
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/user/registrations"
                        class="nav-link ${activePage == 'registrations' ? 'active' : ''}">
                        <i class="fas fa-ticket-alt"></i> My Registrations
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/user/saved"
                        class="nav-link ${activePage == 'saved' ? 'active' : ''}">
                        <i class="fas fa-heart"></i> Saved
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/user/settings"
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

            <!-- User Mini Profile -->
            <div
                style="position: absolute; bottom: 2rem; display: flex; align-items: center; gap: 0.8rem; padding-top: 1rem; border-top: 1px solid rgba(255,255,255,0.1); width: calc(100% - 3rem);">
                <div
                    style="width: 40px; height: 40px; border-radius: 50%; background: var(--primary-color); display: flex; align-items: center; justify-content: center; font-weight: bold; color: white;">
                    ${not empty sessionScope.user ? sessionScope.user.username.charAt(0) : 'U'}
                </div>
                <div style="font-size: 0.9rem;">
                    <div style="color: var(--text-primary); font-weight: 600; color: white;">${not empty
                        sessionScope.user ? sessionScope.user.username : 'Guest'}</div>
                    <div style="color: var(--text-secondary); font-size: 0.75rem;">${not empty sessionScope.user ?
                        sessionScope.user.email : ''}</div>
                </div>
            </div>
        </aside>