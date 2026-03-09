<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventiaPro - Elevate Your Events</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
<!-- Navigation -->
<nav class="glass-card" style="display: flex; justify-content: space-between; align-items: center; padding: 1rem 2rem;">
    <div class="logo" style="font-size: 1.8rem; font-weight: 700; color: var(--primary-color);">
        <i class="fas fa-layer-group"></i> EventiaPro
    </div>
    <div class="nav-links" style="display: flex; gap: 1rem; align-items: center;">
        <a href="${pageContext.request.contextPath}/index.jsp" class="highlight">Home</a>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="highlight">Admin Dashboard</a>
                </c:if>
                <c:if test="${sessionScope.user.role == 'USER'}">
                    <a href="${pageContext.request.contextPath}/user/dashboard" class="highlight">Dashboard</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/auth/login" class="highlight">Login</a>
                <a href="${pageContext.request.contextPath}/auth/signup" class="btn btn-primary">Join Now</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- Hero Section -->
<main class="container">
    <section class="hero animate-fade-in" style="text-align: center; padding: 6rem 2rem;">
        <h1 style="font-size: 3.5rem; font-weight: 700; line-height: 1.2; margin-bottom: 1.5rem;">
            Centralized Event Management <br>
            <span class="highlight">Reimagined.</span>
        </h1>
        <p class="muted" style="font-size: 1.2rem; max-width: 700px; margin: 0 auto 2.5rem;">
            From corporate conferences to local workshops. Organize, manage, and scale your events with
            EventiaPro's automated and secure platform.
        </p>
        <div class="hero-actions" style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/auth/signup" class="btn btn-primary btn-lg">Get Started Free</a>
            <a href="#features" class="btn btn-outline btn-lg">View Features</a>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="event-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; padding: 3rem 2rem;">
        <div class="glass-card">
            <h3 style="margin-bottom: 1rem; color: var(--primary-color);">Secure Auth</h3>
            <p class="muted">Advanced role-based access control for admins and participants.</p>
        </div>
        <div class="glass-card">
            <h3 style="margin-bottom: 1rem; color: var(--secondary-color);">Real-time Tracking</h3>
            <p class="muted">Track registrations and participant lists with ease from the admin panel.</p>
        </div>
        <div class="glass-card">
            <h3 style="margin-bottom: 1rem; color: var(--primary-hover);">Centralized UI</h3>
            <p class="muted">Beautiful, responsive interface designed for both desktop and mobile use.</p>
        </div>
    </section>
</main>

<!-- Footer -->
<footer class="glass-card" style="text-align: center; padding: 3rem 2rem; margin-top: 4rem;">
    <p class="muted">&copy; 2026 EventiaPro EMS. Built with Advanced Java (MVC).</p>
</footer>
</body>

</html>
