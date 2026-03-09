<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${not empty event ? 'Edit' : 'Create'} Event - EventiaPro</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        </head>

        <body>
            <div class="app-container">
                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="logo">
                        <i class="fas fa-layer-group"></i> EventiaPro
                    </div>

                    <ul class="sidebar-menu">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-th-large"></i>
                                Dashboard</a></li>
                        <li><a href="#" class="active"><i class="fas fa-plus-circle"></i> ${not empty event ? 'Edit
                                Event' : 'Create Event'}</a></li>
                        <li><a href="#"><i class="fas fa-chart-line"></i> Analytics</a></li>
                        <li><a href="#"><i class="fas fa-users"></i> Users</a></li>
                        <li class="sidebar-logout"><a href="${pageContext.request.contextPath}/auth/logout"
                                class="danger"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </aside>

                <!-- Main Content -->
                <main class="main-content">
                    <div class="event-details-container">
                        <div class="back-btn">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline"><i
                                    class="fas fa-arrow-left"></i> Back</a>
                        </div>

                        <div class="glass-card animate-fade-in">
                            <h2>${not empty event ? 'Modify Event' : 'Host New Event'}</h2>
                            <form
                                action="${pageContext.request.contextPath}/admin/event/${not empty event ? 'update/'.concat(event.id) : 'save'}"
                                method="POST">

                                <div class="form-group">
                                    <label>Event Title</label>
                                    <input type="text" name="title" value="${event.title}" required
                                        placeholder="e.g. Java Advanced Workshop">
                                </div>

                                <div class="form-group">
                                    <label>Description</label>
                                    <textarea name="description" rows="5" required
                                        placeholder="Describe what the event is about...">${event.description}</textarea>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                                    <div class="form-group">
                                        <label>Date</label>
                                        <input type="date" name="date" value="${event.eventDate}" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Time</label>
                                        <input type="time" name="time" value="${event.eventTime}" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Venue</label>
                                    <select name="venueId" required>
                                        <option value="" disabled selected>Select a venue</option>
                                        <c:forEach var="v" items="${venues}">
                                            <option value="${v.id}" ${event.venue.id==v.id ? 'selected' : '' }>${v.name}
                                                (${v.location}) - Cap: ${v.capacity}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                                    <div class="form-group">
                                        <label>Category</label>
                                        <select name="categoryId" required>
                                            <option value="" disabled selected>Select category</option>
                                            <c:forEach var="c" items="${categories}">
                                                <option value="${c.id}" ${event.category.id==c.id ? 'selected' : '' }>
                                                    ${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Capacity</label>
                                        <input type="number" name="capacity" value="${event.capacity}" required
                                            placeholder="Max attendees">
                                    </div>
                                    <div class="form-group">
                                        <label>Ticket Price ($)</label>
                                        <input type="number" step="0.01" name="ticketPrice" value="${event.ticketPrice}"
                                            required placeholder="0.00">
                                    </div>
                                </div>

                                <div class="admin-actions" style="margin-top: 2rem;">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        ${not empty event ? 'Save Changes' : 'Publish Event'}
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                                        class="btn btn-outline btn-lg">
                                        Cancel
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>
        </body>

        </html>