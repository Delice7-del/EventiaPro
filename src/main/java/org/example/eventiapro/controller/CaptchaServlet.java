package org.example.eventiapro.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.awt.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import org.example.eventiapro.util.CaptchaUtil;

@WebServlet("/auth/captcha")
public class CaptchaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String captcha = CaptchaUtil.generateCaptcha();
        request.getSession().setAttribute("captcha", captcha);

        int width = 160;
        int height = 50;

        BufferedImage bufferedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = bufferedImage.createGraphics();

        // Add some noise/style
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setColor(new Color(245, 245, 245));
        g2d.fillRect(0, 0, width, height);

        // Draw some random lines for better security
        g2d.setColor(new Color(200, 200, 200));
        for (int i = 0; i < 5; i++) {
            g2d.drawLine((int) (Math.random() * width), (int) (Math.random() * height),
                    (int) (Math.random() * width), (int) (Math.random() * height));
        }

        g2d.setColor(new Color(30, 144, 255)); // DodgerBlue
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 30));
        g2d.drawString(captcha, 25, 35);

        response.setContentType("image/png");
        ImageIO.write(bufferedImage, "png", response.getOutputStream());

        g2d.dispose();
    }
}
