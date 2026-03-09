<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Participants – ${event.title}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- optional -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-th-large"></i> Control Center
                </a>
            </li>
            <li>
                <a href="#" class="active">
                    <i class="fas fa-users"></i> Participants
                </a>
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

        <!-- Header -->
        <div class="page-header">
            <div>
                <h2>Event Participants</h2>
                <p>
                    Event:
                    <span style="color: var(--primary-color); font-weight: 500;">
                        ${event.title}
                    </span>
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="btn btn-outline">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        </div>

        <!-- Participants Table -->
        <div class="glass-card" style="padding: 0;">

            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Participant</th>
                        <th>Email</th>
                        <th>Registered On</th>
                        <th>Status</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="reg" items="${participants}" varStatus="status">
                        <tr>
                            <td>${status.count}</td>

                            <td style="font-weight: 600;">
                                <i class="fas fa-user-circle"
                                   style="margin-right: 0.4rem; color: var(--primary-color);"></i>
                                    ${reg.user.username}
                            </td>

                            <td style="color: var(--text-secondary);">
                                    ${reg.user.email}
                            </td>

                            <td>
                                    ${reg.registrationDate}
                            </td>

                            <td>
                                <span class="status-badge">
                                    Confirmed
                                </span>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty participants}">
                        <tr>
                            <td colspan="5" class="empty-cell">
                                <i class="far fa-user-circle"></i>
                                <p>No participants registered yet.</p>
                            </td>
                        </tr>
                    </c:if>

                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>
</body>
</html>
