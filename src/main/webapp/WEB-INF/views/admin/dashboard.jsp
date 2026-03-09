<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page isErrorPage="true" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin Dashboard - EventiaPro</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    .sidebar {
                        z-index: 100 !important;
                    }

                    .stat-card.primary {
                        border-left: 4px solid var(--primary-color);
                    }

                    .stat-card.success {
                        border-left: 4px solid var(--success-color);
                    }

                    .stat-card.warning {
                        border-left: 4px solid #f59e0b;
                    }

                    .stat-card.info {
                        border-left: 4px solid #3b82f6;
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
                        <jsp:param name="activePage" value="dashboard" />
                    </jsp:include>

                    <main class="main-content">
                        <div class="page-header"
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 3rem;">
                            <div>
                                <h2 style="margin-bottom: 0.5rem;">Admin Overview</h2>
                                <p>Welcome back, ${sessionScope.user.username}</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/event/new" class="btn btn-primary"
                                style="padding: 0.8rem 1.5rem;">
                                <i class="fas fa-plus" style="margin-right: 0.5rem;"></i> Create Event
                            </a>
                        </div>

                        <!-- KPI Cards -->
                        <div class="stats-grid">
                            <div class="stat-card primary glass-card">
                                <div class="stat-title">Active Events</div>
                                <div class="stat-value">${activeEventsCount}</div>
                                <div style="font-size: 0.8rem; color: var(--secondary-color);">Out of ${events.size()}
                                    total</div>
                            </div>
                            <div class="stat-card success glass-card">
                                <div class="stat-title">Total Users</div>
                                <div class="stat-value">${userCount}</div>
                                <div style="font-size: 0.8rem; color: var(--success-color);"><i
                                        class="fas fa-users"></i> Platform size</div>
                            </div>
                            <div class="stat-card warning glass-card">
                                <div class="stat-title">Registrations</div>
                                <div class="stat-value">${totalRegistrations}</div>
                                <div style="font-size: 0.8rem; color: #f59e0b;"><i class="fas fa-ticket-alt"></i>
                                    Tickets confirmed</div>
                            </div>
                            <div class="stat-card info glass-card">
                                <div class="stat-title">Revenue</div>
                                <div class="stat-value">$${String.format("%.2f", totalRevenue)}</div>
                                <div style="font-size: 0.8rem; color: #3b82f6;"><i class="fas fa-dollar-sign"></i> Gross
                                    sales</div>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-top: 3.5rem;">
                            <div class="glass-card" style="padding: 1.5rem;">
                                <h3 style="margin-bottom: 1.5rem;">Registration Trends</h3>
                                <canvas id="trendsChart" style="max-height: 250px;"></canvas>
                            </div>
                            <div class="glass-card" style="padding: 1.5rem;">
                                <h3 style="margin-bottom: 1.5rem;">Category Distribution</h3>
                                <canvas id="categoryChart" style="max-height: 250px;"></canvas>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; margin-top: 3.5rem;">
                            <div class="glass-card">
                                <h3>New Users</h3>
                                <div class="table-container" style="border: none; box-shadow: none; padding: 0;">
                                    <table style="margin-top: 1rem;">
                                        <thead>
                                            <tr>
                                                <th>Username</th>
                                                <th>Email</th>
                                                <th>Joined</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="u" items="${recentUsers}">
                                                <tr>
                                                    <td>
                                                        <div style="font-weight: 500;">${u.username}</div>
                                                    </td>
                                                    <td>${u.email}</td>
                                                    <td>${u.createdAt}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="glass-card">
                                <h3>Platform Quick Actions</h3>
                                <div style="display: flex; flex-direction: column; gap: 1rem; margin-top: 1rem;">
                                    <a href="${pageContext.request.contextPath}/admin/event/new" class="btn btn-primary"
                                        style="justify-content: flex-start;">
                                        <i class="fas fa-plus" style="width: 25px;"></i> Create New Event
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline"
                                        style="justify-content: flex-start;">
                                        <i class="fas fa-user-check" style="width: 25px;"></i> User Directory
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/messages" class="btn btn-outline"
                                        style="justify-content: flex-start;">
                                        <i class="fas fa-bullhorn" style="width: 25px;"></i> Broadcast Alert
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/analytics" class="btn btn-outline"
                                        style="justify-content: flex-start;">
                                        <i class="fas fa-file-export" style="width: 25px;"></i> Detailed Reports
                                    </a>
                                </div>
                            </div>
                        </div>

                        <script>
                            function showToast(message, type = 'success') {
                                console.log(`TOAST LOG: [${type}] ${message}`);
                                const container = document.getElementById('toast-container');
                                if (!container) {
                                    alert(`[${type}] ${message}`);
                                    return;
                                }
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

                            // Trends Chart (Real Data)
                            new Chart(document.getElementById('trendsChart'), {
                                type: 'line',
                                data: {
                                    labels: [
                                        <c:forEach var="label" items="${growthLabels}" varStatus="loop">
                                            '${label}'${!loop.last ? ',' : ''}
                                        </c:forEach>
                                    ],
                                    datasets: [{
                                        label: 'Registrations',
                                        data: [
                                            <c:forEach var="val" items="${growthData}" varStatus="loop">
                                                ${val}${!loop.last ? ',' : ''}
                                            </c:forEach>
                                        ],
                                        borderColor: '#f97316',
                                        tension: 0.4,
                                        fill: true,
                                        backgroundColor: 'rgba(249, 115, 22, 0.1)'
                                    }]
                                },
                                options: {
                                    plugins: { legend: { display: false } },
                                    scales: { y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.05)' } }, x: { grid: { display: false } } }
                                }
                            });

                            // Category Chart (Real Data)
                            new Chart(document.getElementById('categoryChart'), {
                                type: 'doughnut',
                                data: {
                                    labels: [
                                        <c:forEach var="entry" items="${categoryStats}" varStatus="loop">
                                            '${entry.key}'${!loop.last ? ',' : ''}
                                        </c:forEach>
                                    ],
                                    datasets: [{
                                        data: [
                                            <c:forEach var="entry" items="${categoryStats}" varStatus="loop">
                                                ${entry.value}${!loop.last ? ',' : ''}
                                            </c:forEach>
                                        ],
                                        backgroundColor: ['#f97316', '#3b82f6', '#22c55e', '#a855f7', '#ec4899', '#eab308']
                                    }]
                                },
                                options: {
                                    plugins: { legend: { position: 'right', labels: { color: '#94a3b8' } } },
                                    cutout: '70%'
                                }
                            });
                        </script>
                    </main>
                </div>
            </body>

            </html>