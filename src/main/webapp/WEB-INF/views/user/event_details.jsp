<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${event.title} - EventiaPro</title>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <!-- optional but recommended -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/events.css">

            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <script>
                function openRegModal(eventId, eventTitle) {
                    document.getElementById('modal-event-id').value = eventId;
                    document.getElementById('modal-event-title').innerText = eventTitle;
                    document.getElementById('reg-modal').style.display = 'flex';
                    setTimeout(() => document.getElementById('reg-modal').classList.add('show'), 10);
                }

                function closeRegModal() {
                    document.getElementById('reg-modal').classList.remove('show');
                    setTimeout(() => document.getElementById('reg-modal').style.display = 'none', 300);
                }

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
                    const error = params.get('error');
                    if (success) showToast(success, 'success');
                    if (error) showToast(error, 'error');
                    if (success || error) {
                        window.history.replaceState({}, document.title, window.location.pathname);
                    }

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
            </style>
        </head>

        <body>
            <div class="app-container">

                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="logo">
                        <i class="fas fa-layer-group"></i> EventiaPro
                    </div>

                    <ul class="sidebar-menu">
                        <li>
                            <a href="${pageContext.request.contextPath}/user/dashboard">
                                <i class="fas fa-compass"></i> Discover
                            </a>
                        </li>
                        <li>
                            <a href="#" class="active">
                                <i class="fas fa-info-circle"></i> Event Details
                            </a>
                        </li>
                        <li>
                            <a href="#"><i class="fas fa-ticket-alt"></i> My Registrations</a>
                        </li>
                        <li class="sidebar-logout">
                            <a href="${pageContext.request.contextPath}/auth/logout" class="danger">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </aside>

                <!-- Main Content -->
                <main class="main-content">

                    <div class="event-details-container">

                        <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-outline back-btn">
                            <i class="fas fa-arrow-left"></i> Back to Events
                        </a>

                        <div class="glass-card event-details-card animate-fade-in"
                            style="padding: 1.5rem; max-width: 800px; margin: 3rem auto 0 auto;">

                            <!-- Header Banner -->
                            <div class="event-banner">
                                <span class="status-badge event-category-badge">
                                    ${event.category.name}
                                </span>
                            </div>

                            <!-- Content -->
                            <div class="event-details-body">

                                <h1 class="event-details-title">${event.title}</h1>

                                <!-- Meta Info -->
                                <div class="event-meta-grid">

                                    <div class="event-meta-box">
                                        <span class="event-meta-label">
                                            <i class="far fa-calendar"></i> Date & Time
                                        </span>
                                        <strong style="font-size: 1.1rem;">${event.eventDate}</strong>
                                        <span class="highlight" style="font-size: 0.9rem; color: var(--primary-color);">
                                            ${not empty event.eventTime ? event.eventTime : '8:00 PM'} (e.g. 8:00 PM)
                                        </span>
                                    </div>

                                    <div class="event-meta-box">
                                        <span class="event-meta-label">
                                            <i class="fas fa-map-marker-alt"></i> Location
                                        </span>
                                        <strong style="font-size: 1.1rem;">${event.venue.name}</strong>
                                        <span class="muted" style="font-size: 0.9rem; opacity: 0.8;">
                                            ${not empty event.venue.location ? event.venue.location : 'Convention
                                            Center, Hall A'}
                                        </span>
                                    </div>

                                    <div class="event-meta-box">
                                        <span class="event-meta-label">
                                            <i class="fas fa-chair"></i> Availability
                                        </span>
                                        <strong style="font-size: 1.1rem;">${event.capacity} Total Seats</strong>
                                        <span class="success" style="font-size: 0.9rem; color: var(--success-color);">
                                            <i class="fas fa-user-check"></i> ${event.capacity - 5} Seats Open
                                            (Registration Active)
                                        </span>
                                    </div>

                                </div>

                                <!-- Description -->
                                <h3 class="section-subtitle">About this Event</h3>
                                <p class="event-description">
                                    ${event.description}
                                </p>

                                <!-- Error -->
                                <c:if test="${not empty param.error}">
                                    <div class="alert alert-danger">
                                        <i class="fas fa-exclamation-circle"></i>
                                        ${param.error}
                                    </div>
                                </c:if>

                                <!-- Registration -->
                                <c:choose>
                                    <c:when test="${isRegistered}">
                                        <div class="alert alert-success registered-box">
                                            <i class="fas fa-check-circle"></i>
                                            You are registered for this event!
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div style="margin-top: 2rem; display: flex; justify-content: center;">
                                            <button type="button"
                                                onclick="openRegModal('${event.id}', '${event.title}')"
                                                class="btn btn-primary btn-lg btn-short">
                                                Register Now
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>
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

                    <h3 style="margin-bottom: 1rem; color: var(--primary-color);">Confirm Registration</h3>
                    <p style="margin-bottom: 2rem; color: var(--text-secondary); font-size: 0.95rem;">
                        Event: <br><strong id="modal-event-title" style="color: var(--text-primary);"></strong>
                    </p>

                    <form id="reg-form" action="${pageContext.request.contextPath}/user/event/register/" method="POST"
                        onsubmit="this.action += document.getElementById('modal-event-id').value;">
                        <input type="hidden" id="modal-event-id" name="eventId">

                        <div class="form-group" style="margin-bottom: 1.5rem;">
                            <label>Attendee Full Name</label>
                            <input type="text" name="attendeeName" value="${sessionScope.user.username}" required
                                placeholder="Enter name">
                        </div>

                        <div class="form-group" style="margin-bottom: 2rem;">
                            <label>Attendee Email</label>
                            <input type="email" name="attendeeEmail" value="${sessionScope.user.email}" required
                                placeholder="Enter email">
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem;">
                            Submit Registration
                        </button>
                    </form>
                </div>
            </div>

            <div id="toast-container" class="toast-container"></div>
        </body>

        </html>