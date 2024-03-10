package com.example.wifi_project;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class OpenApi {
    public OpenApi() {
    }

    public static String get(int startPage, int endPage) {
        String request = null;

        try {
            String url = String.format("http://openapi.seoul.go.kr:8088/4c6b446b4f63686139324c466b5977/json/TbPublicWifiInfo/%s/%s/", startPage, endPage);
            URL url1 = new URL(url);
            HttpURLConnection conn = (HttpURLConnection)url1.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-type", "application/json");
            System.out.println("Response code: " + conn.getResponseCode());
            BufferedReader rd;
            if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            }

            StringBuilder sb = new StringBuilder();

            String line;
            while((line = rd.readLine()) != null) {
                sb.append(line);
            }

            rd.close();
            conn.disconnect();
            request = sb.toString();
        } catch (Exception var9) {
            System.out.println("openApi error" + var9.getMessage());
        }

        return request;
    }
}