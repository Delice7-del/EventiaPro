<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Discover – EventiaPro</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <script>
                function openRegModal(btn) {
                    const eventId = btn.getAttribute('data-id');
                    const eventTitle = btn.getAttribute('data-title');
                    const form = document.getElementById('reg-form');
                    const baseUrl = '${pageContext.request.contextPath}/user/event/register/';

                    document.getElementById('modal-event-id').value = eventId;
                    document.getElementById('modal-event-title').innerText = eventTitle;
                    form.action = baseUrl + eventId;

                    document.getElementById('reg-modal').style.display = 'flex';
                    setTimeout(() => document.getElementById('reg-modal').classList.add('show'), 10);
                }

                function closeRegModal() {
                    document.getElementById('reg-modal').classList.remove('show');
                    setTimeout(() => document.getElementById('reg-modal').style.display = 'none', 300);
                }

                function shareEvent(btn) {
                    const id = btn.getAttribute('data-id');
                    const title = btn.getAttribute('data-title');
                    const url = window.location.origin + '${pageContext.request.contextPath}/user/event/details/' + id;
                    
                    if (navigator.clipboard) {
                        navigator.clipboard.writeText(url).then(() => {
                            showToast('Link copied: ' + title);
                        });
                    } else {
                        showToast('Sharing: ' + title);
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

                const showToast = (message, type = 'success') => {
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
                    const params = new URLSearchParams(window.location.search);
                    const success = params.get('success');
                    const error = params.get('error');

                    // Helper to decode with support for spaces as '+'
                    const decodeMsg = (msg) => {
                        if (!msg) return "";
                        try {
                            return decodeURIComponent(msg.replace(/\+/g, ' '));
                        } catch (e) {
                            return msg;
                        }
                    };

                    if (success && success.trim() !== "") showToast(decodeMsg(success), 'success');
                    if (error && error.trim() !== "") showToast(decodeMsg(error), 'error');

                    if (success || error) {
                        window.history.replaceState({}, document.title, window.location.pathname);
                    }

                    // WebSocket Client Implementation
                    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
                    const wsUrl = protocol + '//' + window.location.host + '${pageContext.request.contextPath}/notifications';
                    const socket = new WebSocket(wsUrl);

                    socket.onmessage = (event) => {
                        try {
                            const data = JSON.parse(event.data);
                            const typeMap = {
                                'EVENT': 'success',
                                'ANNOUNCEMENT': 'info',
                                'DELETE': 'error'
                            };
                            showToast(data.message, typeMap[data.type] || 'success');
                        } catch (e) {
                            // Fallback if message is not JSON
                            showToast(event.data);
                        }
                    };

                    socket.onopen = () => console.log('WebSocket connected');
                    socket.onclose = () => console.log('WebSocket disconnected');
                    socket.onerror = (error) => console.error('WebSocket error:', error);

                    // Close modal on outside click
                    window.onclick = (event) => {
                        const modal = document.getElementById('reg-modal');
                        if (event.target == modal) closeRegModal();
                    }
                };
            </script>
            <style>
                /* Toast Styles */
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

                .heart-btn {
                    color: var(--text-secondary);
                }

                .heart-btn.saved {
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
            </style>
        </head>

        <body>
            <div id="toast-container" class="toast-container"></div>
            <div class="app-container">

                <jsp:include page="sidebar.jsp">
                    <jsp:param name="activePage" value="discover" />
                </jsp:include>

                <main class="main-content">
                    <div class="page-header" style="margin-bottom: 2.5rem;">
                        <div>
                            <h2>Discover Events</h2>
                            <p>Explore upcoming experiences</p>
                        </div>
                    </div>

                    <!-- Announcements Section -->
                    <c:if test="${not empty announcements}">
                        <div class="announcements-section" style="margin-bottom: 2.5rem;">
                            <h3 style="margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem;">
                                <i class="fas fa-bullhorn" style="color: var(--primary-color);"></i> Platform Announcements
                            </h3>
                            <div style="display: flex; flex-direction: column; gap: 1rem;">
                                <c:forEach var="a" items="${announcements}">
                                    <div class="glass-card announcement-item priority-${a.priority}">
                                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem;">
                                            <h4 style="margin: 0; color: var(--text-primary);">${a.title}</h4>
                                            <span style="font-size: 0.8rem; color: var(--text-secondary);">
                                                <fmt:parseDate value="${a.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate" type="both" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM dd, HH:mm" />
                                            </span>
                                        </div>
                                        <p style="margin: 0; color: var(--text-secondary); line-height: 1.5;">${a.message}</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Search & Filter -->
                    <div class="glass-card search-card" style="margin-bottom: 2rem;">
                        <form action="${pageContext.request.contextPath}/user/discover" method="GET">
                            <div class="search-grid"
                                style="display: grid; grid-template-columns: 2fr 1fr auto; gap: 1rem; align-items: end;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label><i class="fas fa-search"></i> Search</label>
                                    <input type="text" name="search" value="${param.search}"
                                        placeholder="Search events...">
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label><i class="fas fa-filter"></i> Category</label>
                                    <select name="categoryId">
                                        <option value="">All</option>
                                        <c:forEach var="c" items="${categories}">
                                            <option value="${c.id}" ${param.categoryId==c.id ? 'selected' : '' }>
                                                ${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary"
                                    style="height: 48px; width: 48px; display: flex; align-items: center; justify-content: center;">
                                    <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="category-chips">
                        <c:set var="searchQuery"
                            value="${not empty param.search ? '&search='.concat(param.search) : ''}" />
                        <a href="${pageContext.request.contextPath}/user/discover${not empty param.search ? '?search='.concat(param.search) : ''}"
                            class="chip ${empty param.categoryId ? 'active' : ''}">All</a>
                        <c:forEach var="c" items="${categories}">
                            <a href="${pageContext.request.contextPath}/user/discover?categoryId=${c.id}${searchQuery}"
                                class="chip ${param.categoryId == c.id ? 'active' : ''}">
                                ${c.name}
                            </a>
                        </c:forEach>
                    </div>

                    <!-- Events Grid -->
                    <div class="event-grid"
                        style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem;">
                        <c:forEach var="event" items="${events}">
                            <div class="glass-card event-card"
                                style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
                                <div style="height: 180px; position: relative; background-color: var(--bg-card);">
                                    <c:set var="target" value="${fn:toLowerCase(event.title)} ${fn:toLowerCase(event.category.name)}" />
                                    <c:choose>
                                        <c:when test="${fn:contains(target, 'tech') || fn:contains(target, 'ai') || fn:contains(target, 'code') || fn:contains(target, 'software') || fn:contains(target, 'data') || fn:contains(target, 'web')}">
                                            <c:set var="imgUrl" value="https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&q=80&w=800" />
                                        </c:when>
                                        <c:when test="${fn:contains(target, 'design') || fn:contains(target, 'ux') || fn:contains(target, 'ui') || fn:contains(target, 'art') || fn:contains(target, 'creative') || fn:contains(target, 'prototype')}">
                                            <c:set var="imgUrl" value="https://images.unsplash.com/photo-1558655146-d09347e92766?auto=format&fit=crop&q=80&w=800" />
                                        </c:when>
                                        <c:when test="${fn:contains(target, 'music') || fn:contains(target, 'concert') || fn:contains(target, 'band') || fn:contains(target, 'party') || fn:contains(target, 'dance') || fn:contains(target, 'show') || fn:contains(target, 'gig')}">
                                            <c:set var="imgUrl" value="https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&q=80&w=800" />
                                        </c:when>
                                        <c:when test="${fn:contains(target, 'food') || fn:contains(target, 'drink') || fn:contains(target, 'festival') || fn:contains(target, 'dinner') || fn:contains(target, 'lunch') || fn:contains(target, 'gourmet') || fn:contains(target, 'cooking')}">
                                            <c:set var="imgUrl" value="https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&q=80&w=800" />
                                        </c:when>
                                        <c:when test="${fn:contains(target, 'sport') || fn:contains(target, 'fitness') || fn:contains(target, 'yoga') || fn:contains(target, 'match') || fn:contains(target, 'game') || fn:contains(target, 'tournament')}">
                                            <c:set var="imgUrl" value="https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&q=80&w=800" />
                                        </c:when>
                                        <c:when test="${fn:contains(target, 'business') || fn:contains(target, 'seminar') || fn:contains(target, 'marketing') || fn:contains(target, 'startup') || fn:contains(target, 'entrepreneur') || fn:contains(target, 'network') || fn:contains(target, 'conference')}">
                                            <c:set var="imgUrl" value="https://images.unsplash.com/photo-1556761175-5973dc0f32b7?auto=format&fit=crop&q=80&w=800" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="imgUrl" value="https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&q=80&w=800" />
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${imgUrl}" alt="Event Image" style="width: 100%; height: 100%; object-fit: cover;">
                                    <span class="status-badge"
                                        style="position: absolute; top: 1rem; left: 1rem; background: rgba(255,255,255,0.9); color: var(--primary-color); font-weight: 600; padding: 0.3rem 0.8rem; border-radius: 5px; font-size: 0.8rem;">
                                        ${event.category.name}
                                    </span>

                                    <div
                                        style="position: absolute; top: 1rem; right: 1rem; display: flex; gap: 0.5rem;">
                                        <!-- Share Button -->
                                        <button onclick="shareEvent(this)" data-id="${event.id}"
                                                data-title="<c:out value="${event.title}" />"
                                                class="btn btn-outline btn-sm action-btn" title="Copy Event Link">
                                            <i class="fas fa-link"></i>
                                        </button>

                                        <!-- Save/Heart Button -->
                                        <c:set var="isSaved" value="false" />
                                        <c:forEach var="savedId" items="${savedEventIds}">
                                            <c:if test="${savedId == event.id}">
                                                <c:set var="isSaved" value="true" />
                                            </c:if>
                                        </c:forEach>

                                        <form
                                            action="${pageContext.request.contextPath}/user/${isSaved ? 'unsave-event' : 'save-event'}"
                                            method="POST" data-title="<c:out value=" ${event.title}" />"
                                        onsubmit="showToast((this.getAttribute('data-is-saved') === 'true' ? 'Removing'
                                        : 'Saving') + ': ' + this.getAttribute('data-title'))"
                                        data-is-saved="${isSaved}">
                                        <input type="hidden" name="eventId" value="${event.id}">
                                        <button type="submit" class="heart-btn ${isSaved ? 'saved' : ''}"
                                            style="width: 32px; height: 32px; border-radius: 50%; border: none; background: rgba(255,255,255,0.9); cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease;">
                                            <i class="${isSaved ? 'fas' : 'far'} fa-heart"></i>
                                        </button>
                                        </form>
                                    </div>
                                </div>
                                <div style="padding: 1.5rem; flex: 1; display: flex; flex-direction: column;">
                                    <h4 style="margin-bottom: 0.5rem; font-size: 1.2rem;">${event.title}</h4>
                                    <div style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1rem;">
                                        <i class="far fa-calendar-alt"></i> ${event.eventDate} &bull;
                                        ${event.eventTime}
                                    </div>
                                    <div
                                        style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.5rem;">
                                        <i class="fas fa-map-marker-alt"></i> ${event.venue.name}
                                    </div>
                                    <div
                                        style="margin-top: auto; display: flex; justify-content: space-between; align-items: center;">
                                        <span style="font-weight: 700; color: var(--success-color); font-size: 1.1rem;">
                                            ${event.ticketPrice > 0 ? '$' : ''}${event.ticketPrice > 0 ?
                                            event.ticketPrice : 'Free'}
                                        </span>
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="${pageContext.request.contextPath}/user/event/details/${event.id}"
                                                class="btn btn-outline btn-sm" style="flex: 1; text-align: center; white-space: nowrap; padding: 0.5rem 1rem;">View Details</a>
                                            <button type="button" onclick="openRegModal(this)" data-id="${event.id}"
                                                data-title="<c:out value="${event.title}" />" class="btn btn-primary btn-sm" style="flex: 1; text-align: center; white-space: nowrap; padding: 0.5rem 1rem;">Register</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty events}">
                            <div class="empty-state" style="grid-column: 1 / -1;">
                                <i class="far fa-calendar-times"></i>
                                <p>No events found. Try adjusting filters.</p>
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

                    <form id="reg-form" action="${pageContext.request.contextPath}/user/event/register/" method="POST">
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