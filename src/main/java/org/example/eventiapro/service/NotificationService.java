package org.example.eventiapro.service;

import org.example.eventiapro.websocket.NotificationWebSocket;
import com.google.gson.JsonObject;

public class NotificationService {
    public void notifyNewEvent(String title) {
        JsonObject json = new JsonObject();
        json.addProperty("type", "EVENT");
        json.addProperty("message", "New event created: " + title);
        NotificationWebSocket.broadcast(json.toString());
    }

    public void notifyNewAnnouncement(String title) {
        JsonObject json = new JsonObject();
        json.addProperty("type", "ANNOUNCEMENT");
        json.addProperty("message", "New announcement: " + title);
        NotificationWebSocket.broadcast(json.toString());
    }

    public void notifyEventDeleted(String title) {
        JsonObject json = new JsonObject();
        json.addProperty("type", "DELETE");
        json.addProperty("message", "Event cancelled: " + title);
        NotificationWebSocket.broadcast(json.toString());
    }
}
