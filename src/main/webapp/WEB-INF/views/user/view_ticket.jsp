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
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 80vh;
                    padding: 2rem;
                }

                .ticket-card {
                    display: flex;
                    background: rgba(255, 255, 255, 0.05);
                    backdrop-filter: blur(20px);
                    border-radius: 20px;
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    overflow: hidden;
                    width: 100%;
                    max-width: 800px;
                    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
                }

                .ticket-main {
                    flex: 1;
                    padding: 3rem;
                    position: relative;
                }

                .ticket-stub {
                    width: 250px;
                    background: var(--primary-color);
                    padding: 3rem 2rem;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    text-align: center;
                    position: relative;
                    border-left: 2px dashed rgba(255, 255, 255, 0.3);
                }

                .ticket-stub::before,
                .ticket-stub::after {
                    content: '';
                    position: absolute;
                    left: -15px;
                    width: 30px;
                    height: 30px;
                    background: #111;
                    /* Matches body bg */
                    border-radius: 50%;
                }

                .ticket-stub::before {
                    top: -15px;
                }

                .ticket-stub::after {
                    bottom: -15px;
                }

                .qr-code {
                    background: white;
                    padding: 1rem;
                    border-radius: 10px;
                    margin-bottom: 2rem;
                    width: 150px;
                    height: 150px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: #111;
                    font-size: 5rem;
                }

                .ticket-event-title {
                    font-size: 2rem;
                    font-weight: 700;
                    margin-bottom: 1rem;
                    color: white;
                }

                .ticket-info-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 2rem;
                    margin-top: 2rem;
                }

                .info-item label {
                    display: block;
                    color: var(--text-secondary);
                    font-size: 0.85rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    margin-bottom: 0.5rem;
                }

                .info-item span {
                    font-size: 1.1rem;
                    font-weight: 500;
                }

                .back-link {
                    position: absolute;
                    top: 2rem;
                    left: 2rem;
                    color: var(--text-secondary);
                    text-decoration: none;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    transition: color 0.3s;
                }

                .back-link:hover {
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

                @media (max-width: 768px) {
                    .ticket-card {
                        flex-direction: column;
                    }

                    .ticket-stub {
                        width: 100%;
                        border-left: none;
                        border-top: 2px dashed rgba(255, 255, 255, 0.3);
                        padding: 2rem;
                    }

                    .ticket-stub::before,
                    .ticket-stub::after {
                        left: auto;
                        top: -15px;
                    }

                    .ticket-stub::before {
                        left: -15px;
                    }

                    .ticket-stub::after {
                        right: -15px;
                    }
                }
            </style>
        </head>

        <body>
            <div id="toast-container" class="toast-container"></div>
            <div class="app-container">
                <main class="main-content" style="margin-left: 0; width: 100%;">
                    <a href="${pageContext.request.contextPath}/user/registrations" class="back-link">
                        <i class="fas fa-arrow-left"></i> Back to Registrations
                    </a>

                    <div class="ticket-container">
                        <div class="ticket-card animate-fade-in">
                            <div class="ticket-main">
                                <div class="status-badge"
                                    style="background: rgba(249, 115, 22, 0.2); color: var(--primary-color); margin-bottom: 1rem;">
                                    ADMIT ONE
                                </div>
                                <h1 class="ticket-event-title">${registration.event.title}</h1>
                                <p class="muted">${registration.event.description}</p>

                                <div class="ticket-info-grid">
                                    <div class="info-item">
                                        <label>Date</label>
                                        <span>${registration.event.eventDate}</span>
                                    </div>
                                    <div class="info-item">
                                        <label>Time</label>
                                        <span>${registration.event.eventTime}</span>
                                    </div>
                                    <div class="info-item">
                                        <label>Location</label>
                                        <span>${registration.event.venue.name}</span>
                                    </div>
                                    <div class="info-item">
                                        <label>Attendee</label>
                                        <span>${sessionScope.user.username}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="ticket-stub">
                                <div class="qr-code">
                                    <img src="https://quickchart.io/qr?text=REG-${registration.id != 0 ? registration.id : '501'}&size=120"
                                        alt="QR Code" style="width: 100%; height: 100%;">
                                </div>
                                <div style="color: white; margin-bottom: 2rem;">
                                    <p style="font-size: 0.8rem; opacity: 0.8; margin-bottom: 0.5rem;">Ticket ID</p>
                                    <h3 style="font-family: monospace;">#REG-${registration.id != 0 ? registration.id :
                                        '501'}</h3>
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 0.5rem; width: 100%;">
                                    <button class="btn btn-outline"
                                        style="background: white; color: var(--primary-color); border: none; width: 100%;"
                                        onclick="window.print()">
                                        <i class="fas fa-print"></i> Print
                                    </button>
                                    <a href="${pageContext.request.contextPath}/user/event/download-ticket/${registration.id != 0 ? registration.id : '501'}"
                                        class="btn btn-outline"
                                        style="background: rgba(255,255,255,0.1); color: white; border: 1px solid rgba(255,255,255,0.3); width: 100%;">
                                        <i class="fas fa-download"></i> Download
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </body>

        </html>