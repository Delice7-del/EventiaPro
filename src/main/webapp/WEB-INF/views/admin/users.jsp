<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page isErrorPage="true" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>User Management – EventiaPro Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
                    .filter-select {
                        padding: 0.6rem 1rem;
                        border-radius: 8px;
                        border: 1px solid var(--border-color);
                        background: var(--bg-card);
                        color: white;
                        outline: none;
                    }

                    .action-menu {
                        position: relative;
                        display: inline-block;
                    }

                    .action-content {
                        display: none;
                        position: absolute;
                        right: 0;
                        background: #1e293b;
                        min-width: 160px;
                        box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.5);
                        z-index: 10;
                        border-radius: 8px;
                        border: 1px solid var(--border-color);
                        overflow: hidden;
                    }

                    .action-content a {
                        color: white;
                        padding: 12px 16px;
                        text-decoration: none;
                        display: block;
                        font-size: 0.9rem;
                        transition: background 0.2s;
                    }

                    .action-content a:hover {
                        background-color: #334155;
                    }

                    .action-menu:hover .action-content {
                        display: block;
                    }
                </style>
            </head>

            <body>
                <div id="toast-container" class="toast-container"></div>

                <!-- Flash Messages (Hidden) -->
                <input type="hidden" id="flash-success" value="<c:out value='${success}'/>">
                <input type="hidden" id="flash-error" value="<c:out value='${error}'/>">

                <div class="app-container">
                    <jsp:include page="sidebar.jsp">
                        <jsp:param name="activePage" value="users" />
                    </jsp:include>

                    <main class="main-content">
                        <div class="page-header" style="margin-bottom: 2.5rem;">
                            <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                                <div>
                                    <h2 style="margin-bottom: 0.5rem;">User Management</h2>
                                    <p>Manage access, roles, and platform users</p>
                                </div>
                                <form action="${pageContext.request.contextPath}/admin/users" method="GET"
                                    style="display: flex; gap: 1rem;">
                                    <select name="role" class="filter-select" onchange="this.form.submit()">
                                        <option value="All">All Roles</option>
                                        <option value="Admin" ${param.role=='Admin' ? 'selected' : '' }>Admin</option>
                                        <option value="Organizer" ${param.role=='Organizer' ? 'selected' : '' }>
                                            Organizer</option>
                                        <option value="User" ${param.role=='User' ? 'selected' : '' }>User</option>
                                    </select>
                                    <div style="position: relative;">
                                        <i class="fas fa-search"
                                            style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--text-secondary);"></i>
                                        <input type="text" name="search" placeholder="Search users..."
                                            value="${param.search}"
                                            style="padding: 0.8rem 1.2rem 0.8rem 2.8rem; border-radius: 20px; border: 1px solid var(--border-color); background: var(--bg-card); color: white; min-width: 300px;">
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="glass-card" style="padding: 0;">
                            <div class="table-container" style="border: none;">
                                <table style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th style="padding: 1.5rem; text-align: left;">User Info</th>
                                            <th style="padding: 1.5rem; text-align: left;">Account Role</th>
                                            <th style="padding: 1.5rem; text-align: left;">Joined Date</th>
                                            <th style="padding: 1.5rem; text-align: left;">Status</th>
                                            <th style="padding: 1.5rem; text-align: center;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="u" items="${users}">
                                            <tr style="border-top: 1px solid var(--border-color);">
                                                <td style="padding: 1.5rem;">
                                                    <div style="font-weight: 500; font-size: 1.1rem;">${u.username}
                                                    </div>
                                                    <div style="font-size: 0.85rem; color: var(--text-secondary);">
                                                        ${u.email}</div>
                                                </td>
                                                <td style="padding: 1.5rem;">
                                                    <span class="status-badge"
                                                        style="background: rgba(255,255,255,0.05); text-transform: none;">
                                                        ${u.role}
                                                    </span>
                                                </td>
                                                <td style="padding: 1.5rem; color: var(--text-secondary);">
                                                    ${u.createdAt}</td>
                                                <td style="padding: 1.5rem;">
                                                    <span class="status-badge"
                                                        style="background: rgba(34, 197, 94, 0.1); color: #22c55e;">Active</span>
                                                </td>
                                                <td style="padding: 1.5rem; text-align: center;">
                                                    <div class="action-menu">
                                                        <button class="btn btn-sm btn-outline"><i
                                                                class="fas fa-cog"></i> Manage</button>
                                                        <div class="action-content">
                                                            <a
                                                                href="${pageContext.request.contextPath}/admin/user/update-role?userId=${u.id}&role=Admin"><i
                                                                    class="fas fa-user-shield"></i> Make Admin</a>
                                                            <a
                                                                href="${pageContext.request.contextPath}/admin/user/update-role?userId=${u.id}&role=Organizer"><i
                                                                    class="fas fa-briefcase"></i> Make Organizer</a>
                                                            <a
                                                                href="${pageContext.request.contextPath}/admin/user/update-role?userId=${u.id}&role=User"><i
                                                                    class="fas fa-user"></i> Revoke Roles</a>
                                                            <a href="${pageContext.request.contextPath}/admin/user/delete?userId=${u.id}"
                                                                style="color: #ef4444;"
                                                                onclick="return confirm('Are you sure you want to delete this user?')">
                                                                <i class="fas fa-trash"></i> Delete Account
                                                            </a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <c:if test="${empty users}">
                            <div style="text-align: center; padding: 4rem;">
                                <i class="fas fa-users-slash fa-3x"
                                    style="color: var(--border-color); margin-bottom: 2rem;"></i>
                                <p style="color: var(--text-secondary);">No users found matching your criteria.</p>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline"
                                    style="margin-top: 1rem;">Clear Filters</a>
                            </div>
                        </c:if>
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
                        // 1. Check for Flash Attributes (Hidden inputs + c:out)
                        const flashSuccess = document.getElementById('flash-success').value;
                        const flashError = document.getElementById('flash-error').value;

                        if (flashSuccess && flashSuccess.trim() !== "") {
                            showToast(flashSuccess, 'success');
                        }
                        if (flashError && flashError.trim() !== "") {
                            showToast(flashError, 'error');
                        }

                        // 2. Backward compatibility for URL params
                        const params = new URLSearchParams(window.location.search);
                        const successParam = params.get('success');
                        const errorParam = params.get('error');

                        const decodeMsg = (msg) => {
                            if (!msg) return "";
                            try {
                                return decodeURIComponent(msg.replace(/\+/g, ' '));
                            } catch (e) {
                                return msg;
                            }
                        };

                        if (successParam && successParam.trim() !== "") showToast(decodeMsg(successParam), 'success');
                        if (errorParam && errorParam.trim() !== "") showToast(decodeMsg(errorParam), 'error');
                    };
                </script>
            </body>

            </html>