<%@ page contentType="application/json; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.google.gson.JsonPrimitive" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="com.google.gson.JsonParser" %>

<%
    Class.forName("org.sqlite.JDBC");

    String lat = request.getParameter("lat");
    String lnt = request.getParameter("lnt");
    String timestamp = new Timestamp(System.currentTimeMillis()).toString();
    String DATABASE_URL = "jdbc:sqlite:C:/Users/munso/IdeaProjects/wifi_project/identifier.sqlite";

    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    try {
        connection = DriverManager.getConnection(DATABASE_URL);
        String query = "SELECT ROUND(ABS(LAT - ?) + ABS(LNT - ?), 4) AS distance, * FROM information ORDER BY distance LIMIT 20";
        statement = connection.prepareStatement(query);
        statement.setString(1, lat);
        statement.setString(2, lnt);
        resultSet = statement.executeQuery();

        query = "INSERT INTO history (ID, LAT, LAN, time) VALUES (?, ?, ?, ?)";
        statement = connection.prepareStatement(query);
        statement.setString(1, null); // ID 값은 자동으로 증가하도록 설정될 것입니다.
        statement.setString(2, lat);
        statement.setString(3, lnt);
        statement.setString(4, timestamp);
        statement.executeUpdate();

        // HTML 코드 시작
%>
<table>
<%
        while (resultSet.next()) {
%>
<tr>
<td><%= resultSet.getString("distance") %></td>
<td><%= resultSet.getString("X_SWIFI_MGR_NO") %></td>
<td><%= resultSet.getString("X_SWIFI_WRDOFC") %></td>
<td><%= resultSet.getString("X_SWIFI_MAIN_NM") %></td>
<td><%= resultSet.getString("X_SWIFI_ADRES1") %></td>
<td><%= resultSet.getString("X_SWIFI_ADRES2") %></td>
<td><%= resultSet.getString("X_SWIFI_INSTL_FLOOR") %></td>
<td><%= resultSet.getString("X_SWIFI_INSTL_TY") %></td>
<td><%= resultSet.getString("X_SWIFI_INSTL_MBY") %></td>
<td><%= resultSet.getString("X_SWIFI_SVC_SE") %></td>
<td><%= resultSet.getString("X_SWIFI_CMCWR") %></td>
<td><%= resultSet.getString("X_SWIFI_CNSTC_YEAR") %></td>
<td><%= resultSet.getString("X_SWIFI_INOUT_DOOR") %></td>
<td><%= resultSet.getString("X_SWIFI_REMARS3") %></td>
<td><%= resultSet.getString("LAT") %></td>
<td><%= resultSet.getString("LNT") %></td>
<td><%= resultSet.getString("WORK_DTTM") %></td>
</tr>
<%
        }
%>
</table>
<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        if (resultSet != null) {
            try {
                resultSet.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
