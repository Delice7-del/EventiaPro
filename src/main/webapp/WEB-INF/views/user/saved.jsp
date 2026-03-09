<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page isErrorPage="true" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Saved Events – EventiaPro</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <script>
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

                    function openRegModal(btn) {
                        const eventId = btn.getAttribute('data-id');
                        const eventTitle = btn.getAttribute('data-title');
                        document.getElementById('modal-event-id').value = eventId;
                        document.getElementById('modal-event-title').innerText = eventTitle;
                        document.getElementById('reg-modal').style.display = 'flex';
                        setTimeout(() => document.getElementById('reg-modal').classList.add('show'), 10);
                    }

                    function closeRegModal() {
                        const modal = document.getElementById('reg-modal');
                        modal.classList.remove('show');
                        setTimeout(() => modal.style.display = 'none', 300);
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

                        // Close modal on outside click
                        window.onclick = (event) => {
                            const modal = document.getElementById('reg-modal');
                            if (event.target == modal) closeRegModal();
                        }
                    };
                </script>
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

                    /* Modal Styles */
                    .modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.7);
                        backdrop-filter: blur(5px);
                        z-index: 10000;
                        display: none;
                        align-items: center;
                        justify-content: center;
                        opacity: 0;
                        transition: opacity 0.3s ease;
                    }

                    .modal-overlay.show {
                        opacity: 1;
                    }

                    .modal-content {
                        width: 450px;
                        transform: scale(0.8);
                        transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                    }

                    .modal-overlay.show .modal-content {
                        transform: scale(1);
                    }

                    .btn-short {
                        padding: 0.5rem 1rem !important;
                        font-size: 0.85rem !important;
                    }
                </style>

            <body>
                <div id="toast-container" class="toast-container"></div>
                <div class="app-container">

                    <jsp:include page="sidebar.jsp">
                        <jsp:param name="activePage" value="saved" />
                    </jsp:include>

                    <main class="main-content">
                        <div class="page-header">
                            <div>
                                <h2>Saved Events</h2>
                                <p>Events you've bookmarked for later</p>
                            </div>
                        </div>

                        <div class="saved-grid" style="margin-top: 2rem;">
                            <c:forEach var="event" items="${savedEvents}">
                                <div class="glass-card"
                                    style="padding: 1.25rem; position: relative; border-radius: 12px; transition: transform 0.3s ease; display: flex; flex-direction: column; min-height: 200px;">

                                    <div
                                        style="position: absolute; top: 1rem; right: 1rem; display: flex; gap: 0.5rem;">
                                        <!-- Share Button Circle -->
                                        <button onclick="shareEvent(this)" data-id="${event.id}"
                                            data-title="<c:out value='${event.title}'/>"
                                            style="width: 32px; height: 32px; border-radius: 50%; border: none; background: rgba(255,255,255,0.9); color: var(--text-primary); cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease;">
                                            <i class="fas fa-share-alt"></i>
                                        </button>

                                        <!-- Heart Button Circle (Unsave) -->
                                        <form action="${pageContext.request.contextPath}/user/unsave-event"
                                            method="POST">
                                            <input type="hidden" name="eventId" value="${event.id}">
                                            <button type="submit" class="heart-btn saved"
                                                style="width: 32px; height: 32px; border-radius: 50%; border: none; background: rgba(255,255,255,0.9); color: var(--danger-color); cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease;">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </form>
                                    </div>

                                    <h4 style="margin-top: 0.5rem; margin-bottom: 0.5rem; padding-right: 4rem;">
                                        ${event.title}</h4>
                                    <div style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1rem;">
                                        <i class="far fa-calendar-alt"></i> ${event.eventDate}
                                    </div>
                                    <div style="margin-bottom: 1rem;">
                                        <span class="status-badge" style="font-size: 0.7rem;">${event.ticketPrice > 0 ?
                                            '$' : ''}${event.ticketPrice > 0 ? event.ticketPrice : 'Free'}</span>
                                    </div>

                                    <div
                                        style="margin-top: 1.5rem; display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
                                        <button onclick="openRegModal(this)" data-id="${event.id}"
                                            data-title="<c:out value='${event.title}'/>" class="btn btn-primary btn-sm"
                                            style="padding: 0.6rem 1.2rem; font-size: 0.85rem; border-radius: 8px;">Register</button>

                                        <a href="${pageContext.request.contextPath}/user/settings?section=notifications"
                                            data-title="<c:out value='${event.title}'/>"
                                            onclick="showToast('Linking to reminders for: ' + this.getAttribute('data-title'))"
                                            class="btn btn-outline"
                                            style="width: 38px; height: 38px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 8px;"
                                            title="Get Reminders">
                                            <i class="fas fa-bell"></i>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty savedEvents}">
                                <div class="empty-state" style="grid-column: 1 / -1;">
                                    <i class="far fa-heart"></i>
                                    <p>No saved events.</p>
                                    <a href="${pageContext.request.contextPath}/user/discover"
                                        class="btn btn-primary">Explore</a>
                                </div>
                            </c:if>
                        </div>
                    </main>
                </div>

                <!-- Registration Modal -->
                <div id="reg-modal" class="modal-overlay">
                    <div class="glass-card modal-content" style="padding: 2.5rem; position: relative;">
                        <button type="button" onclick="closeRegModal()"
                            style="position: absolute; top: 1.5rem; right: 1.5rem; background: none; border: none; color: var(--text-secondary); cursor: pointer; font-size: 1.2rem;">
                            <i class="fas fa-times"></i>
                        </button>

                        <h3 style="margin-bottom: 1rem; color: var(--primary-color);">Event Registration</h3>
                        <p style="margin-bottom: 2rem; color: var(--text-secondary); font-size: 0.95rem;">
                            Registering for: <br><strong id="modal-event-title"
                                style="color: var(--text-primary);"></strong>
                        </p>

                        <form id="reg-form" action="${pageContext.request.contextPath}/user/event/register/"
                            method="POST" onsubmit="this.action += document.getElementById('modal-event-id').value;">
                            <input type="hidden" id="modal-event-id" name="eventId">

                            <div class="form-group" style="margin-bottom: 1.5rem;">
                                <label>Your Full Name</label>
                                <input type="text" name="attendeeName" value="${sessionScope.user.username}" required
                                    placeholder="Enter attendee name">
                            </div>

                            <div class="form-group" style="margin-bottom: 2rem;">
                                <label>Confirmation Email</label>
                                <input type="email" name="attendeeEmail" value="${sessionScope.user.email}" required
                                    placeholder="Enter attendee email">
                            </div>

                            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem;">
                                Confirm Registration
                            </button>
                        </form>
                    </div>
                </div>
            </body>

            </html>