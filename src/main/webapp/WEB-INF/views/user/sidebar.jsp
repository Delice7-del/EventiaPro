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

        <script>
            (function () {
                const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
                const socket = new WebSocket(protocol + '//' + window.location.host + '${pageContext.request.contextPath}/notifications');

                socket.onmessage = function (event) {
                    const data = JSON.parse(event.data);
                    showNotification(data.message, data.type);
                };

                function showNotification(message, type) {
                    const toast = document.createElement('div');
                    toast.className = 'ws-notification ' + type.toLowerCase();
                    toast.innerHTML = `
                        <div style="display: flex; align-items: center; gap: 12px; min-width: 300px;">
                            <div style="background: \${type === 'EVENT' ? '#3b82f6' : (type === 'DELETE' ? '#ef4444' : '#f59e0b')}; padding: 10px; border-radius: 8px;">
                                <i class="fas \${type === 'EVENT' ? 'fa-calendar-plus' : (type === 'DELETE' ? 'fa-calendar-times' : 'fa-bullhorn')}" style="color: white;"></i>
                            </div>
                            <div style="flex: 1;">
                                <div style="font-weight: 600; font-size: 0.9rem; color: white;">\${type}</div>
                                <div style="font-size: 0.85rem; color: #cbd5e1;">\${message}</div>
                            </div>
                        </div>
                    `;
                    document.body.appendChild(toast);

                    Object.assign(toast.style, {
                        position: 'fixed',
                        bottom: '20px',
                        right: '20px',
                        backgroundColor: '#1e293b',
                        borderRadius: '12px',
                        padding: '12px',
                        boxShadow: '0 10px 25px rgba(0,0,0,0.4)',
                        zIndex: '9999',
                        border: '1px solid rgba(255,255,255,0.1)',
                        transition: 'all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275)'
                    });

                    // Animation
                    toast.style.transform = 'translateX(120%)';
                    setTimeout(() => toast.style.transform = 'translateX(0)', 100);

                    setTimeout(() => {
                        toast.style.transform = 'translateX(120%)';
                        setTimeout(() => toast.remove(), 400);
                    }, 6000);
                }
            })();
        </script>