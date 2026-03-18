<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page isErrorPage="true" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Messages & Announcements – EventiaPro Admin</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <style>
                        .msg-sidebar-item {
                            padding: 1rem;
                            border-radius: 12px;
                            margin-bottom: 0.5rem;
                            cursor: pointer;
                            transition: all 0.2s;
                            border: 1px solid transparent;
                        }

                        .msg-sidebar-item:hover {
                            background: rgba(255, 255, 255, 0.05);
                            border-color: var(--border-color);
                        }

                        .msg-sidebar-item.active {
                            background: rgba(249, 115, 22, 0.1);
                            border-color: rgba(249, 115, 22, 0.3);
                            color: var(--primary-color);
                        }

                        .badge-count {
                            background: var(--primary-color);
                            color: white;
                            padding: 2px 8px;
                            border-radius: 10px;
                            font-size: 0.75rem;
                            float: right;
                        }

                        .form-group {
                            margin-bottom: 1.5rem;
                        }

                        .form-group label {
                            display: block;
                            margin-bottom: 0.5rem;
                            color: var(--text-secondary);
                        }

                        .form-control {
                            width: 100%;
                            padding: 0.8rem;
                            background: rgba(255, 255, 255, 0.05);
                            border: 1px solid var(--border-color);
                            border-radius: 8px;
                            color: white;
                        }

                        .status-badge {
                            padding: 4px 12px;
                            border-radius: 50px;
                            font-size: 0.8rem;
                            font-weight: 600;
                            display: inline-block;
                        }

                        .status-badge.high {
                            background: rgba(239, 68, 68, 0.1);
                            color: #ef4444;
                        }

                        .status-badge.medium {
                            background: rgba(245, 158, 11, 0.1);
                            color: #f59e0b;
                        }

                        .status-badge.low {
                            background: rgba(59, 130, 246, 0.1);
                            color: #3b82f6;
                        }
                    </style>
                </head>

                <body>
                    <div id="toast-container" class="toast-container"></div>

                    <div class="app-container">
                        <jsp:include page="sidebar.jsp">
                            <jsp:param name="activePage" value="messages" />
                        </jsp:include>

                        <main class="main-content" style="margin-bottom: 5rem;">
                            <div class="page-header" style="margin-bottom: 2rem;">
                                <h2>Communications Hub</h2>
                                <p>Manage support requests and platform-wide broadcasts</p>
                            </div>

                            <div
                                style="display: grid; grid-template-columns: 280px 1fr; gap: 2rem; height: calc(100vh - 200px);">
                                <!-- Sidebar -->
                                <div class="glass-card" style="padding: 1rem; display: flex; flex-direction: column;">
                                    <div style="flex-grow: 1;">
                                        <div class="msg-sidebar-item active" onclick="switchTab('inbox')">
                                            <i class="fas fa-inbox" style="margin-right: 10px;"></i> Support Inbox
                                            <span class="badge-count">3</span>
                                        </div>
                                        <div class="msg-sidebar-item" onclick="switchTab('broadcast')">
                                            <i class="fas fa-bullhorn" style="margin-right: 10px;"></i> Broadcast Alert
                                        </div>
                                        <div class="msg-sidebar-item" onclick="switchTab('history')">
                                            <i class="fas fa-history" style="margin-right: 10px;"></i> Sent History
                                        </div>
                                    </div>
                                    <div style="border-top: 1px solid var(--border-color); padding-top: 1rem;">
                                        <p style="font-size: 0.8rem; color: var(--text-secondary); text-align: center;">
                                            V
                                            1.1.0 - Admin Messenger</p>
                                    </div>
                                </div>

                                <!-- Content Area -->
                                <div id="inbox-view" class="glass-card"
                                    style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
                                    <div
                                        style="padding: 1.5rem; border-bottom: 1px solid var(--border-color); background: rgba(255,255,255,0.02);">
                                        <h3 style="margin: 0;">Support Requests</h3>
                                    </div>
                                    <div style="flex-grow: 1; overflow-y: auto;">
                                        <!-- Static Mock for now -->
                                        <div style="padding: 1.5rem; border-bottom: 1px solid var(--border-color); cursor: pointer;"
                                            class="msg-list-item">
                                            <div
                                                style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                                <strong style="color: var(--primary-color);">John Doe</strong>
                                                <span style="font-size: 0.8rem; color: var(--text-secondary);">2h
                                                    ago</span>
                                            </div>
                                            <div style="font-weight: 600; margin-bottom: 0.3rem;">Issue with event
                                                registration</div>
                                            <p
                                                style="font-size: 0.9rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">
                                                Hey admin, I'm trying to book ticket for the Tech Summit but the payment
                                                fails...</p>
                                        </div>
                                    </div>
                                </div>

                                <div id="broadcast-view" class="glass-card" style="padding: 2rem; display: none;">
                                    <h3 style="margin-bottom: 1.5rem;">Broadcast Platform Announcement</h3>
                                    <form action="${pageContext.request.contextPath}/admin/broadcast" method="POST">
                                        <div class="form-group">
                                            <label>Announcement Title</label>
                                            <input type="text" name="title" class="form-control"
                                                placeholder="e.g., Scheduled Maintenance" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Priority Level</label>
                                            <select name="priority" class="form-control">
                                                <option value="Low">Low (Info)</option>
                                                <option value="Medium">Medium (Attention)</option>
                                                <option value="High">High (Urgent)</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Message Content</label>
                                            <textarea name="message" class="form-control" rows="6"
                                                placeholder="Write your message here..." required></textarea>
                                        </div>
                                        <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                                            <button type="button" class="btn btn-outline"
                                                onclick="switchTab('inbox')">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Send to All Users</button>
                                        </div>
                                    </form>
                                </div>

                                <div id="history-view" class="glass-card"
                                    style="padding: 0; display: none; flex-direction: column;">
                                    <div
                                        style="padding: 1.5rem; border-bottom: 1px solid var(--border-color); background: rgba(255,255,255,0.02);">
                                        <h3 style="margin: 0;">Sent Broadcast History</h3>
                                    </div>
                                    <div style="flex-grow: 1; overflow-y: auto;">
                                        <c:forEach var="a" items="${announcements}">
                                            <div style="padding: 1.5rem; border-bottom: 1px solid var(--border-color);">
                                                <div
                                                    style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                                    <span class="status-badge ${a.priority.toLowerCase()}">
                                                        ${a.priority}
                                                    </span>
                                                    <span style="font-size: 0.8rem; color: var(--text-secondary);">
                                                        <fmt:formatDate value="${a.createdAt}"
                                                            pattern="MMM dd, yyyy HH:mm" />
                                                    </span>
                                                </div>
                                                <div style="font-weight: 600; margin-bottom: 0.3rem;">${a.title}</div>
                                                <p
                                                    style="font-size: 0.9rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">
                                                    ${a.message}</p>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${empty announcements}">
                                            <div
                                                style="padding: 3rem; text-align: center; color: var(--text-secondary);">
                                                No
                                                broadcast history found.</div>
                                        </c:if>
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

                        function switchTab(tab) {
                            document.getElementById('inbox-view').style.display = (tab === 'inbox' ? 'flex' : 'none');
                            document.getElementById('broadcast-view').style.display = (tab === 'broadcast' ? 'block' : 'none');
                            document.getElementById('history-view').style.display = (tab === 'history' ? 'flex' : 'none');

                            const items = document.querySelectorAll('.msg-sidebar-item');
                            items.forEach(item => {
                                item.classList.remove('active');
                                if ((tab === 'inbox' && item.innerText.includes('Inbox')) ||
                                    (tab === 'broadcast' && item.innerText.includes('Broadcast')) ||
                                    (tab === 'history' && item.innerText.includes('History'))) {
                                    item.classList.add('active');
                                }
                            });
                        }
                    </script>
                </body>

                </html>