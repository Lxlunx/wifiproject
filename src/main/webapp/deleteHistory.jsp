<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String id = request.getParameter("id");
    if (id != null) {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            Class.forName("org.sqlite.JDBC");
            String DATABASE_URL = "jdbc:sqlite:C:/Users/munso/IdeaProjects/wifi_project/identifier.sqlite";
            connection = DriverManager.getConnection(DATABASE_URL);

            String query = "DELETE FROM history WHERE ID = ?";
            statement = connection.prepareStatement(query);
            statement.setString(1, id);
            statement.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
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
    }
    response.sendRedirect("history.jsp");
%>
