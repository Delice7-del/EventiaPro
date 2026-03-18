<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Ticket - EventiaPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .ticket-container {
            max-width: 500px;
            margin: 4rem auto;
            perspective: 1000px;
        }
        .ticket {
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }
        .ticket-header {
            background: var(--primary-color);
            padding: 2rem;
            text-align: center;
            color: white;
        }
        .ticket-body {
            padding: 2rem;
            color: white;
        }
        .ticket-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding-bottom: 0.5rem;
        }
        .info-label {
            color: var(--text-secondary);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .qr-section {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            text-align: center;
            margin-top: 2rem;
        }
        .qr-placeholder {
            width: 150px;
            height: 150px;
            background: #eee;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
            font-size: 3rem;
        }
    </style>
</head>
<body style="background: #0f172a;">
    <div class="ticket-container">
        <div class="ticket animate-fade-in">
            <div class="ticket-header">
                <i class="fas fa-layer-group fa-2x mb-3"></i>
                <h2 style="margin: 0;">EVENT TICKET</h2>
                <div style="font-size: 0.9rem; opacity: 0.8;">#REG-${registration.id}</div>
            </div>
            <div class="ticket-body">
                <h3 style="margin-top: 0; color: var(--primary-color);">${registration.event.title}</h3>
                
                <div class="ticket-info">
                    <div>
                        <div class="info-label">DATE</div>
                        <div>${registration.event.eventDate}</div>
                    </div>
                    <div style="text-align: right;">
                        <div class="info-label">TIME</div>
                        <div>${registration.event.eventTime}</div>
                    </div>
                </div>

                <div class="ticket-info">
                    <div>
                        <div class="info-label">VENUE</div>
                        <div>${registration.event.venue.name}</div>
                    </div>
                    <div style="text-align: right;">
                        <div class="info-label">ATTENDEE</div>
                        <div>${sessionScope.user.username}</div>
                    </div>
                </div>

                <div class="qr-section">
                    <div class="qr-placeholder">
                        <i class="fas fa-qrcode"></i>
                    </div>
                    <div style="color: #333; margin-top: 1rem; font-weight: 600; font-size: 0.8rem;">
                        Scan at entry
                    </div>
                </div>
                
                <div style="margin-top: 2rem; text-align: center;">
                    <button onclick="window.print()" class="btn btn-primary" style="width: 100%;">
                        <i class="fas fa-print"></i> Print Ticket
                    </button>
                    <a href="${pageContext.request.contextPath}/user/registrations" class="btn btn-outline" style="width: 100%; margin-top: 1rem;">
                        Back to My Registrations
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
