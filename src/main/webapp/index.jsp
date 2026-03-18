<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventiaPro - Elevate Your Events</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Custom Landing Page Styles */
        body {
            scroll-behavior: smooth;
        }

        /* Hero Enhancements */
        .hero {
            position: relative;
            overflow: hidden;
            background-color: transparent;
        }

        .highlight {
            color: var(--primary-color);
            display: inline-block;
        }

        /* Section Spacing */
        .landing-section {
            padding: 5rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-title {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 3rem;
        }

        /* How it Works */
        .steps-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            position: relative;
        }

        .step-card {
            text-align: center;
            padding: 2rem;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }
        
        .step-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.05);
            border-color: var(--primary-color);
        }

        .step-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }

        /* Features Grid */
        .feature-grid-expanded {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .feature-item {
            display: flex;
            gap: 1.5rem;
            align-items: flex-start;
        }

        .feature-item .icon-wrapper {
            background: rgba(249, 115, 22, 0.1);
            padding: 1rem;
            border-radius: 10px;
            color: var(--primary-color);
            font-size: 1.5rem;
        }

        /* CTA Section */
        .cta-section {
            background-color: rgba(255, 255, 255, 0.02);
            border-radius: 20px;
            text-align: center;
            padding: 4rem 2rem;
            margin: 4rem auto;
            max-width: 1000px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .event-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    </style>
</head>

<body>
<!-- Navigation -->
<nav class="glass-card" style="display: flex; justify-content: space-between; align-items: center; padding: 1rem 2rem; margin-bottom: 0; border-radius: 0; border-top: none; border-left: none; border-right: none;">
    <div class="logo" style="font-size: 1.8rem; font-weight: 700;">
        <i class="fas fa-layer-group"></i> <span class="highlight">EventiaPro</span>
    </div>
    <div class="nav-links" style="display: flex; gap: 1.5rem; align-items: center;">
        <a href="#how-it-works" class="nav-link" style="color: var(--text-secondary); transition: color 0.3s;">How it Works</a>
        <a href="#features" class="nav-link" style="color: var(--text-secondary); transition: color 0.3s;">Features</a>
        
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary btn-sm">Admin Dashboard</a>
                </c:if>
                <c:if test="${sessionScope.user.role == 'USER'}">
                    <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-primary btn-sm">Dashboard</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline btn-sm">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/auth/login" style="color: var(--text-light); font-weight: 500;">Login</a>
                <a href="${pageContext.request.contextPath}/auth/signup" class="btn btn-primary btn-sm">Join Now</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- Hero Section -->
<main>
    <section class="hero landing-section" style="text-align: center; padding-top: 8rem; padding-bottom: 6rem;">
        <h1 style="font-size: 4rem; font-weight: 800; line-height: 1.2; margin-bottom: 1.5rem; letter-spacing: -1px;">
            Centralized Event Management <br>
            <span class="highlight">Reimagined.</span>
        </h1>
        <p class="muted" style="font-size: 1.25rem; max-width: 700px; margin: 0 auto 3rem; color: var(--text-secondary); line-height: 1.6;">
            From corporate conferences to local workshops. Organize, manage, and scale your events with
            EventiaPro's automated and secure platform. Built for modern teams.
        </p>
        <div class="hero-actions" style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/auth/signup" class="btn btn-primary btn-lg" style="padding: 1rem 3rem; font-size: 1.1rem; border-radius: 50px;">Join as Attendee</a>
            <a href="${pageContext.request.contextPath}/auth/signup?role=ADMIN&v=2" class="btn btn-outline btn-lg" style="padding: 1rem 3rem; font-size: 1.1rem; border-radius: 50px; border-color: var(--primary-color); color: var(--primary-color);">Start Organizing</a>
        </div>
    </section>

    <!-- How It Works Section -->
    <section id="how-it-works" class="landing-section">
        <h2 class="section-title">How It <span class="highlight">Works</span></h2>
        <div class="steps-container">
            <div class="step-card">
                <i class="fas fa-calendar-plus step-icon"></i>
                <h3 style="margin-bottom: 1rem; font-size: 1.5rem;">1. Create Event</h3>
                <p style="color: var(--text-secondary); line-height: 1.6;">Admins set up event details, capacity, and ticketing options in minutes.</p>
            </div>
            <div class="step-card">
                <i class="fas fa-search-location step-icon" style="color: var(--secondary-color);"></i>
                <h3 style="margin-bottom: 1rem; font-size: 1.5rem;">2. Users Discover</h3>
                <p style="color: var(--text-secondary); line-height: 1.6;">Attendees browse the centralized dashboard to find and register for events.</p>
            </div>
            <div class="step-card">
                <i class="fas fa-qrcode step-icon" style="color: var(--success-color);"></i>
                <h3 style="margin-bottom: 1rem; font-size: 1.5rem;">3. Instant Tickets</h3>
                <p style="color: var(--text-secondary); line-height: 1.6;">Automatic PDF ticket generation with QR codes for seamless check-ins.</p>
            </div>
        </div>
    </section>

    <!-- Expanded Features Section -->
    <section id="features" class="landing-section">
        <h2 class="section-title">Everything You <span class="highlight">Need</span></h2>
        <div class="feature-grid-expanded glass-card" style="padding: 4rem 3rem;">
            
            <div class="feature-item">
                <div class="icon-wrapper"><i class="fas fa-shield-alt"></i></div>
                <div>
                    <h3 style="margin-bottom: 0.5rem; font-size: 1.25rem;">Secure Auth & Roles</h3>
                    <p style="color: var(--text-secondary); font-size: 0.95rem; line-height: 1.5;">Advanced role-based access control (RBAC) separating Admin organizers from User attendees.</p>
                </div>
            </div>

            <div class="feature-item">
                <div class="icon-wrapper" style="background: rgba(56, 189, 248, 0.1); color: var(--secondary-color);"><i class="fas fa-chart-line"></i></div>
                <div>
                    <h3 style="margin-bottom: 0.5rem; font-size: 1.25rem;">Real-time Analytics</h3>
                    <p style="color: var(--text-secondary); font-size: 0.95rem; line-height: 1.5;">Track registrations, capacity limits, and participant lists instantly from the admin panel.</p>
                </div>
            </div>

            <div class="feature-item">
                <div class="icon-wrapper" style="background: rgba(34, 197, 94, 0.1); color: var(--success-color);"><i class="fas fa-bell"></i></div>
                <div>
                    <h3 style="margin-bottom: 0.5rem; font-size: 1.25rem;">Live Notifications</h3>
                    <p style="color: var(--text-secondary); font-size: 0.95rem; line-height: 1.5;">WebSocket-powered real-time alerts ensure users never miss an important event update.</p>
                </div>
            </div>

            <div class="feature-item">
                <div class="icon-wrapper" style="background: rgba(245, 158, 11, 0.1); color: var(--warning-color);"><i class="fas fa-calendar-alt"></i></div>
                <div>
                    <h3 style="margin-bottom: 0.5rem; font-size: 1.25rem;">Calendar Integration</h3>
                    <p style="color: var(--text-secondary); font-size: 0.95rem; line-height: 1.5;">Export registered events directly to Google Calendar or Outlook (.ics format).</p>
                </div>
            </div>

        </div>
    </section>

    <!-- Upcoming Events (Static Placeholders) -->
    <section id="upcoming" class="landing-section" style="padding-top: 2rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 3rem;">
            <div>
                <h2 style="font-size: 2.5rem; font-weight: 700;">Upcoming <span class="highlight">Events</span></h2>
                <p style="color: var(--text-secondary); margin-top: 0.5rem;">A sneak peek at what's happening soon.</p>
            </div>
            <a href="${pageContext.request.contextPath}/auth/signup" class="btn btn-outline" style="border-radius: 50px;">View All Events <i class="fas fa-arrow-right"></i></a>
        </div>
        
        <div class="event-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">
            <!-- Placeholder Card 1 -->
            <div class="glass-card" style="padding: 0; overflow: hidden; position: relative;">
                <div style="height: 180px; background-color: var(--bg-card);">
                     <img src="https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80" alt="Tech Summit" class="event-image">
                </div>
                <div style="padding: 1.5rem;">
                    <div style="display: flex; gap: 0.5rem; margin-bottom: 1rem;">
                        <span class="chip" style="font-size: 0.75rem; padding: 0.3rem 0.8rem; border-color: var(--primary-color); color: var(--primary-color);">Technology</span>
                    </div>
                    <h3 style="margin-bottom: 0.5rem; font-size: 1.2rem;">Annual Tech Summit 2026</h3>
                    <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.5rem;"><i class="fas fa-calendar-alt"></i> October 15, 2026</p>
                    <a href="${pageContext.request.contextPath}/auth/signup" class="btn btn-outline btn-full" style="border-radius: 8px;">Register to Attend</a>
                </div>
            </div>
            
            <!-- Placeholder Card 2 -->
            <div class="glass-card" style="padding: 0; overflow: hidden; position: relative;">
                <div style="height: 180px; background-color: var(--bg-card);">
                     <img src="https://images.unsplash.com/photo-1552664730-d307ca884978?w=800&q=80" alt="Leadership Masterclass" class="event-image">
                </div>
                <div style="padding: 1.5rem;">
                    <div style="display: flex; gap: 0.5rem; margin-bottom: 1rem;">
                        <span class="chip" style="font-size: 0.75rem; padding: 0.3rem 0.8rem; border-color: var(--secondary-color); color: var(--secondary-color);">Workshop</span>
                    </div>
                    <h3 style="margin-bottom: 0.5rem; font-size: 1.2rem;">Leadership Masterclass</h3>
                    <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.5rem;"><i class="fas fa-calendar-alt"></i> November 02, 2026</p>
                    <a href="${pageContext.request.contextPath}/auth/signup" class="btn btn-outline btn-full" style="border-radius: 8px;">Register to Attend</a>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <h2 style="font-size: 2.5rem; font-weight: 700; margin-bottom: 1rem;">Ready to upgrade your events?</h2>
        <p style="color: var(--text-light); font-size: 1.1rem; margin-bottom: 2rem;">Join organizers worldwide who are scaling their events with EventiaPro.</p>
        <a href="${pageContext.request.contextPath}/auth/signup" class="btn btn-primary btn-lg" style="border-radius: 50px; padding: 1rem 4rem; font-size: 1.2rem; box-shadow: 0 10px 25px rgba(249, 115, 22, 0.4);">Join For Free Today</a>
    </section>

</main>

<!-- Footer -->
<footer style="text-align: center; padding: 3rem 2rem; border-top: 1px solid rgba(255,255,255,0.05);">
    <div style="display: flex; justify-content: center; gap: 1.5rem; margin-bottom: 1.5rem;">
        <a href="#" style="color: var(--text-secondary); font-size: 1.5rem; transition: color 0.3s;"><i class="fab fa-twitter"></i></a>
        <a href="#" style="color: var(--text-secondary); font-size: 1.5rem; transition: color 0.3s;"><i class="fab fa-github"></i></a>
        <a href="#" style="color: var(--text-secondary); font-size: 1.5rem; transition: color 0.3s;"><i class="fab fa-linkedin"></i></a>
    </div>
    <p class="muted" style="color: var(--text-secondary); font-size: 0.9rem;">&copy; 2026 EventiaPro EMS. Built with Advanced Java Servlet & JSP.</p>
</footer>

<script>
    // Simple smooth scroll for nav links
    document.querySelectorAll('.nav-link').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });
</script>
</body>

</html>

