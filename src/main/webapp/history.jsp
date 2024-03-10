<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
    <style>
        #wifiTable {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #wifiTable td, #wifiTable th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #wifiTable tr:nth-child(even){background-color: #f2f2f2;}

        #wifiTable tr:hover {background-color: #ddd;}

        #wifiTable th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
            background-color: #04AA6D;
            color: white;
        }
    </style>
</head>
<body>
<h1><%= "와이파이 정보 구하기" %>
</h1>
<a href="index.jsp">홈 |</a>
<a href="history.jsp">위치 히스토리 목록 |</a>
<a href="api.jsp">Open API 와이파이 정보 가져오기</a></br>

<table id="wifiTable">
    <tr>
        <th>ID</th>
        <th>X좌표</th>
        <th>Y좌표</th>
        <th>조회일자</th>
        <th>비고</th>
    </tr>
    <%
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("org.sqlite.JDBC");
            String DATABASE_URL = "jdbc:sqlite:C:/Users/munso/IdeaProjects/wifi_project/identifier.sqlite";
            connection = DriverManager.getConnection(DATABASE_URL);
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT * FROM history");

            while (resultSet.next()) {
    %>
    <tr>
        <td><%= resultSet.getString("ID") %></td>
        <td><%= resultSet.getString("LAT") %></td>
        <td><%= resultSet.getString("LAN") %></td>
        <td><%= resultSet.getString("time") %></td>
        <td>
            <form action="deleteHistory.jsp" method="post">
                <input type="hidden" name="id" value="<%= resultSet.getString("ID") %>">
                <button type="submit">삭제</button>
            </form>
        </td>
    </tr>
    <%
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
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
</table>
</body>
</html>
