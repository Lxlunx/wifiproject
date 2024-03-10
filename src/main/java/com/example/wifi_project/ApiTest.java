package com.example.wifi_project;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;


public class ApiTest {
    private static final String DATABASE_URL = "jdbc:sqlite:C:/Users/munso/IdeaProjects/wifi_project/identifier.sqlite";
    private static final int PAGE_SIZE = 1000;

    public static void main(String[] args) {
        int startPage = 1;
        int endPage = 1000;

        // 시작 페이지부터 데이터를 가져와서 데이터가 없을 때까지 반복
        while (true) {
            // Open API 호출하여 데이터 가져오기
            String wifiData = OpenApi.get(startPage, endPage);

            if (!wifiData.isEmpty() && wifiData.contains("TbPublicWifiInfo")) {
                // SQLite 데이터베이스에 데이터 삽입
                insertDataIntoSQLite(wifiData);
                startPage += 1000;
                endPage += 1000;
            } else {
                System.out.println(startPage);
                break; // 데이터가 없으면 반복 종료
            }
        }
    }

    public static void insertDataIntoSQLite(String wifiData) {
        try {
            Connection connection = DriverManager.getConnection(DATABASE_URL);
            String query = "INSERT INTO information (X_SWIFI_MGR_NO, X_SWIFI_WRDOFC, X_SWIFI_MAIN_NM, X_SWIFI_ADRES1, X_SWIFI_ADRES2, X_SWIFI_INSTL_FLOOR, X_SWIFI_INSTL_TY, X_SWIFI_INSTL_MBY, X_SWIFI_SVC_SE, X_SWIFI_CMCWR, X_SWIFI_CNSTC_YEAR, X_SWIFI_INOUT_DOOR, X_SWIFI_REMARS3, LAT, LNT, WORK_DTTM) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(query);

            // Gson 라이브러리를 사용하여 JSON 문자열을 파싱
            JsonParser parser = new JsonParser();
            JsonElement element = parser.parse(wifiData);
            JsonObject jsonObject = element.getAsJsonObject();
            JsonObject wifiInfo = jsonObject.getAsJsonObject("TbPublicWifiInfo");
            JsonArray wifiArray = wifiInfo.getAsJsonArray("row");

            // JSON 배열에서 각 객체를 추출하여 데이터베이스에 삽입
            for (JsonElement jsonElement : wifiArray) {
                JsonObject wifiObject = jsonElement.getAsJsonObject();
                String X_SWIFI_MGR_NO = wifiObject.get("X_SWIFI_MGR_NO").getAsString();
                String X_SWIFI_WRDOFC = wifiObject.get("X_SWIFI_WRDOFC").getAsString();
                String X_SWIFI_MAIN_NM = wifiObject.get("X_SWIFI_MAIN_NM").getAsString();
                String X_SWIFI_ADRES1 = wifiObject.get("X_SWIFI_ADRES1").getAsString();
                String X_SWIFI_ADRES2 = wifiObject.get("X_SWIFI_ADRES2").getAsString();
                String X_SWIFI_INSTL_FLOOR = wifiObject.get("X_SWIFI_INSTL_FLOOR").getAsString();
                String X_SWIFI_INSTL_TY = wifiObject.get("X_SWIFI_INSTL_TY").getAsString();
                String X_SWIFI_INSTL_MBY = wifiObject.get("X_SWIFI_INSTL_MBY").getAsString();
                String X_SWIFI_SVC_SE = wifiObject.get("X_SWIFI_SVC_SE").getAsString();
                String X_SWIFI_CMCWR = wifiObject.get("X_SWIFI_CMCWR").getAsString();
                String X_SWIFI_CNSTC_YEAR = wifiObject.get("X_SWIFI_CNSTC_YEAR").getAsString();
                String X_SWIFI_REMARS3 = wifiObject.get("X_SWIFI_REMARS3").getAsString();
                String X_SWIFI_INOUT_DOOR = wifiObject.get("X_SWIFI_INOUT_DOOR").getAsString();
                String LAT = wifiObject.get("LAT").getAsString();
                String LNT = wifiObject.get("LNT").getAsString();
                String WORK_DTTM = wifiObject.get("WORK_DTTM").getAsString();

                statement.setString(1, X_SWIFI_MGR_NO);
                statement.setString(2, X_SWIFI_WRDOFC);
                statement.setString(3, X_SWIFI_MAIN_NM);
                statement.setString(4, X_SWIFI_ADRES1);
                statement.setString(5, X_SWIFI_ADRES2);
                statement.setString(6, X_SWIFI_INSTL_FLOOR);
                statement.setString(7, X_SWIFI_INSTL_TY);
                statement.setString(8, X_SWIFI_INSTL_MBY);
                statement.setString(9, X_SWIFI_SVC_SE);
                statement.setString(10, X_SWIFI_CMCWR);
                statement.setString(11, X_SWIFI_CNSTC_YEAR);
                statement.setString(12, X_SWIFI_INOUT_DOOR);
                statement.setString(13, X_SWIFI_REMARS3);
                statement.setString(14, LAT);
                statement.setString(15, LNT);
                statement.setString(16, WORK_DTTM);

                statement.executeUpdate();
            }

            statement.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
