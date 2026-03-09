package org.example.eventiapro.util;

import java.util.Random;

public class CaptchaUtil {

    public static String generateCaptcha() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
        StringBuilder captcha = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < 6; i++) {
            captcha.append(chars.charAt(random.nextInt(chars.length())));
        }

        return captcha.toString();
    }
}
