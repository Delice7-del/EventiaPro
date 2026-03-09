<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page isErrorPage="true" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Analytics – EventiaPro Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            </head>

            <body>
                <div id="toast-container" class="toast-container"></div>

                <div class="app-container">
                    <jsp:include page="sidebar.jsp">
                        <jsp:param name="activePage" value="analytics" />
                    </jsp:include>

                    <main class="main-content">
                        <div class="page-header" style="margin-bottom: 3rem;">
                            <div>
                                <h2 style="margin-bottom: 0.5rem;">Analytics & Insights</h2>
                                <p>Performance metrics and trends</p>
                            </div>
                        </div>

                        <!-- Analytics Charts -->
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 3.5rem;">
                            <div class="glass-card" style="padding: 1.5rem;">
                                <h3 style="margin-bottom: 1rem;">Platform Growth</h3>
                                <canvas id="growthChart" style="max-height: 250px;"></canvas>
                            </div>
                            <div class="glass-card" style="padding: 1.5rem;">
                                <h3 style="margin-bottom: 1rem;">Registration by Category</h3>
                                <canvas id="categoryChart" style="max-height: 250px;"></canvas>
                            </div>
                        </div>

                        <div class="glass-card">
                            <h3>Event Performance Deep-Dive</h3>
                            <div class="table-container" style="border: none;">
                                <table class="table" style="margin-top: 1rem;">
                                    <thead>
                                        <tr>
                                            <th>Event</th>
                                            <th>Date</th>
                                            <th>Registrations</th>
                                            <th>Gross Revenue</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="m" items="${eventMetrics}">
                                            <tr>
                                                <td style="padding: 1.5rem;">
                                                    <div style="font-weight: 600;">${m.title}</div>
                                                </td>
                                                <td style="padding: 1.5rem;">${m.date}</td>
                                                <td style="padding: 1.5rem;">${m.registrations}</td>
                                                <td style="padding: 1.5rem;">$${String.format("%.2f", m.revenue)}</td>
                                                <td style="padding: 1.5rem;">
                                                    <span class="status-badge"
                                                        style="background: rgba(34, 197, 94, 0.1);">
                                                        <i class="fas fa-trending-up" style="margin-right: 4px;"></i>
                                                        Active
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
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

                    // Growth Chart
                    new Chart(document.getElementById('growthChart'), {
                        type: 'line',
                        data: {
                            labels: [
                                <c:forEach var="label" items="${growthLabels}" varStatus="loop">
                                    '${label}'${!loop.last ? ',' : ''}
                                </c:forEach>
                            ],
                            datasets: [{
                                label: 'Users',
                                data: [
                                    <c:forEach var="val" items="${growthData}" varStatus="loop">
                                        ${val}${!loop.last ? ',' : ''}
                                    </c:forEach>
                                ],
                                borderColor: '#3b82f6',
                                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                                fill: true,
                                tension: 0.4
                            }]
                        },
                        options: {
                            plugins: { legend: { display: false } },
                            scales: { y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.05)' } } }
                        }
                    });

                    // Category Chart
                    new Chart(document.getElementById('categoryChart'), {
                        type: 'bar',
                        data: {
                            labels: [
                                <c:forEach var="entry" items="${categoryStats}" varStatus="loop">
                                    '${entry.key}'${!loop.last ? ',' : ''}
                                </c:forEach>
                            ],
                            datasets: [{
                                label: 'Registrations',
                                data: [
                                    <c:forEach var="entry" items="${categoryStats}" varStatus="loop">
                                        ${entry.value}${!loop.last ? ',' : ''}
                                    </c:forEach>
                                ],
                                backgroundColor: '#f97316'
                            }]
                        },
                        options: {
                            plugins: { legend: { display: false } },
                            scales: { y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.05)' } } }
                        }
                    });
                </script>
            </body>

            </html>