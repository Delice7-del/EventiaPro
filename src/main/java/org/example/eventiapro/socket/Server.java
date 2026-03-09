package org.example.eventiapro.socket;

import java.io.*;
import java.net.*;


public class Server {
    public static void main(String[] args) {
        try (ServerSocket serverSocket = new ServerSocket(2345)) {
            System.out.println("Server is listing on port 2345 ....");
            Socket socket = serverSocket.accept();
            System.out.println("Client Connected.");
            BufferedReader input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            PrintWriter output = new PrintWriter(socket.getOutputStream(), true);
            String message = input.readLine();
            System.out.println("Received: " + message);
            output.println("Hello from Server!");
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


}