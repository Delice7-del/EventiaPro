<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page isErrorPage="true" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>My Registrations – EventiaPro</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <script>
                    function filterRegistrations(status, btn) {
                        // Update active tab
                        document.querySelectorAll('.chip').forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');

                        const cards = document.querySelectorAll('.reg-card');
                        const emptyState = document.getElementById('empty-state');
                        let visibleCount = 0;

                        cards.forEach(card => {
                            const cardStatus = card.getAttribute('data-status');
                            if (status === 'All' || cardStatus === status) {
                                card.style.display = 'flex';
                                visibleCount++;
                            } else {
                                card.style.display = 'none';
                            }
                        });

                        if (visibleCount === 0) {
                            emptyState.style.display = 'block';
                        } else {
                            emptyState.style.display = 'none';
                        }
                    }

                    function confirmCancel(btn) {
                        const regId = btn.getAttribute('data-reg-id');
                        const eventTitle = btn.getAttribute('data-title');
                        if (confirm('Are you sure you want to cancel the registration for "' + eventTitle + '"?')) {
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '${pageContext.request.contextPath}/user/registrations/cancel/' + regId;
                            document.body.appendChild(form);
                            form.submit();
                        }
                    }

                    function confirmDelete(btn) {
                        const regId = btn.getAttribute('data-reg-id');
                        const eventTitle = btn.getAttribute('data-title');
                        if (confirm('Are you sure you want to PERMANENTLY DELETE the registration for "' + eventTitle + '"? This action cannot be undone.')) {
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '${pageContext.request.contextPath}/user/registrations/delete/' + regId;
                            document.body.appendChild(form);
                            form.submit();
                        }
                    }

                    function shareEvent(btn) {
                        const eventId = btn.getAttribute('data-id');
                        const eventTitle = btn.getAttribute('data-title');
                        const url = window.location.origin + '${pageContext.request.contextPath}/user/event/details/' + eventId;

                        if (navigator.clipboard && window.isSecureContext) {
                            navigator.clipboard.writeText(url).then(() => {
                                showToast('Link copied: ' + eventTitle);
                            }).catch(err => {
                                fallbackCopyTextToClipboard(url, eventTitle);
                            });
                        } else {
                            fallbackCopyTextToClipboard(url, eventTitle);
                        }
                    }

                    function fallbackCopyTextToClipboard(text, eventTitle) {
                        const textArea = document.createElement("textarea");
                        textArea.value = text;
                        textArea.style.position = "fixed";
                        textArea.style.left = "-999999px";
                        textArea.style.top = "-999999px";
                        document.body.appendChild(textArea);
                        textArea.focus();
                        textArea.select();
                        try {
                            document.execCommand('copy');
                            showToast('Link copied: ' + eventTitle);
                        } catch (err) {
                            showToast('Unable to copy link', 'error');
                        }
                        document.body.removeChild(textArea);
                    }

                    function showToast(message, type = 'success') {
                        const container = document.getElementById('toast-container');
                        if (!container) return;
                        const toast = document.createElement('div');
                        toast.className = 'toast ' + type;
                        const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
                        toast.innerHTML = '<i class="fas ' + icon + '"></i><span>' + message + '</span>';
                        container.appendChild(toast);
                        setTimeout(() => toast.classList.add('show'), 10);
                        setTimeout(() => {
                            toast.classList.remove('show');
                            setTimeout(() => toast.remove(), 500);
                        }, 4000);
                    }

                    window.onload = () => {
                        const params = new URLSearchParams(window.location.search);
                        const success = params.get('success');
                        const error = params.get('error');
                        if (success) showToast(success, 'success');
                        if (error) showToast(error, 'error');
                        if (success || error) {
                            window.history.replaceState({}, document.title, window.location.pathname);
                        }
                    };
                </script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <style>
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

                    .toast.success i {
                        color: var(--primary-color);
                    }

                    .toast.error i {
                        color: var(--danger-color);
                    }

                    .status-Upcoming {
                        background: rgba(34, 197, 94, 0.15);
                        color: var(--success-color);
                    }

                    .status-Cancelled {
                        background: rgba(239, 68, 68, 0.15);
                        color: var(--danger-color);
                    }

                    .status-Attended {
                        background: rgba(59, 130, 246, 0.15);
                        color: var(--primary-color);
                    }
                </style>
            </head>

            <body>
                <div id="toast-container" class="toast-container"></div>
                <div class="app-container">

                    <jsp:include page="sidebar.jsp">
                        <jsp:param name="activePage" value="registrations" />
                    </jsp:include>

                    <main class="main-content">
                        <div class="page-header" style="margin-bottom: 3rem;">
                            <div>
                                <h2>My Registrations</h2>
                                <p>Track your upcoming and past events</p>
                            </div>
                        </div>

                        <div class="category-chips" style="margin-bottom: 2.5rem;">
                            <button class="chip active" onclick="filterRegistrations('All', this)">All</button>
                            <button class="chip" onclick="filterRegistrations('Upcoming', this)">Upcoming</button>
                            <button class="chip" onclick="filterRegistrations('Past', this)">Past</button>
                            <button class="chip" onclick="filterRegistrations('Cancelled', this)">Cancelled</button>
                        </div>

                        <div class="tab-content" style="display: flex; flex-direction: column; gap: 1.5rem;">
                            <c:forEach var="reg" items="${registrations}">
                                <div class="glass-card reg-card"
                                    data-status="${reg.status != null ? reg.status : 'Registered'}"
                                    style="display: flex; gap: 2rem; align-items: center; padding: 2rem; transition: all 0.3s ease;">
                                    <div
                                        style="width: 100px; height: 100px; background: rgba(255, 255, 255, 0.05); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: var(--primary-color);">
                                        <i class="fas fa-ticket-alt fa-3x"></i>
                                    </div>
                                    <div style="flex: 1;">
                                        <h3 style="margin-bottom: 0.5rem;">${reg.event.title}</h3>
                                        <div
                                            style="display: flex; gap: 1.5rem; margin-bottom: 0.5rem; font-size: 0.95rem; color: var(--text-secondary);">
                                            <span><i class="far fa-calendar-alt"></i> ${reg.event.eventDate}</span>
                                            <span><i class="far fa-clock"></i> ${reg.event.eventTime}</span>
                                        </div>
                                        <p
                                            style="font-size: 0.95rem; color: var(--text-secondary); margin-bottom: 1rem;">
                                            <i class="fas fa-map-marker-alt"></i> ${reg.event.venue.name}
                                        </p>

                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <span
                                                class="status-badge status-${reg.status != null ? reg.status : 'Upcoming'}"
                                                style="font-size: 0.85rem; padding: 0.4rem 1rem;">
                                                <i
                                                    class="fas ${reg.status == 'Upcoming' ? 'fa-clock' : reg.status == 'Cancelled' ? 'fa-times-circle' : 'fa-check-circle'}"></i>
                                                ${reg.status != null ? reg.status : 'Registered'}
                                            </span>

                                            <c:if test="${reg.status == 'Upcoming'}">
                                                <form
                                                    action="${pageContext.request.contextPath}/user/registrations/check-in/${reg.id != 0 ? reg.id : '501'}"
                                                    method="POST">
                                                    <button type="submit" class="btn btn-outline"
                                                        style="padding: 0.3rem 0.8rem; font-size: 0.8rem;">Simulate
                                                        Check-in</button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="${pageContext.request.contextPath}/user/event/ticket/${reg.id != 0 ? reg.id : '501'}"
                                                class="btn btn-primary" style="flex: 1; min-width: 120px;">
                                                <i class="fas fa-qrcode"></i> Ticket
                                            </a>
                                            <a href="${pageContext.request.contextPath}/user/event/download-ticket/${reg.id != 0 ? reg.id : '501'}"
                                                data-title="<c:out value='${reg.event.title}'/>"
                                                onclick="showToast('Downloading ticket for: ' + this.getAttribute('data-title'))"
                                                class="btn btn-outline" style="padding: 0.5rem;" title="Download PDF">
                                                <i class="fas fa-download"></i>
                                            </a>
                                        </div>

                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="${pageContext.request.contextPath}/user/event/calendar/${reg.id != 0 ? reg.id : '501'}"
                                                data-title="<c:out value='${reg.event.title}'/>"
                                                onclick="showToast('Exporting calendar for: ' + this.getAttribute('data-title'))"
                                                class="btn btn-outline" style="flex: 1; font-size: 0.85rem;">
                                                <i class="far fa-calendar-plus"></i> Calendar
                                            </a>
                                            <button onclick="shareEvent(this)" data-id="${reg.event.id}"
                                                data-title="<c:out value='${reg.event.title}'/>" class="btn btn-outline"
                                                style="padding: 0.5rem;">
                                                <i class="fas fa-share-alt"></i>
                                            </button>
                                        </div>

                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="${pageContext.request.contextPath}/user/event/details/${reg.event.id}"
                                                class="btn btn-outline" style="flex: 3; font-size: 0.85rem;">Details</a>

                                            <c:if test="${reg.status != 'Cancelled'}">
                                                <button onclick="confirmCancel(this)"
                                                    data-reg-id="${reg.id != 0 ? reg.id : '501'}"
                                                    data-title="<c:out value='${reg.event.title}'/>"
                                                    class="btn btn-outline"
                                                    style="flex: 1; color: var(--primary-color); border-color: rgba(249, 115, 22, 0.2);"
                                                    title="Cancel Registration">
                                                    <i class="fas fa-ban"></i>
                                                </button>
                                            </c:if>

                                            <button onclick="confirmDelete(this)"
                                                data-reg-id="${reg.id != 0 ? reg.id : '501'}"
                                                data-title="<c:out value='${reg.event.title}'/>" class="btn btn-outline"
                                                style="flex: 1; color: var(--danger-color); border-color: rgba(239, 68, 68, 0.2);"
                                                title="Permanently Delete">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <div id="empty-state" class="empty-state" <c:if test="${not empty registrations}">
                                style="display: none;"</c:if>>
                                <i class="fas fa-ticket-alt"></i>
                                <p>No registrations found in this category.</p>
                                <a href="${pageContext.request.contextPath}/user/discover"
                                    class="btn btn-primary">Browse Events</a>
                            </div>
                        </div>
                    </main>
                </div>
            </body>

            </html>