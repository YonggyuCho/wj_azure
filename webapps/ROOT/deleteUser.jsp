<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource" %>
<%@ page session="true" %>
<html>
<head>
    <title>Delete User</title>
</head>
<body>
    <%
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail != null && request.getParameter("delete") != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            try {
                // MySQL 연결
                Context initContext = new InitialContext();
                Context envContext  = (Context)initContext.lookup("java:/comp/env");
                DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
                conn = ds.getConnection();

                // 삭제 처리
                String deleteSql = "DELETE FROM users WHERE email = ?";
                stmt = conn.prepareStatement(deleteSql);
                stmt.setString(1, userEmail);
                stmt.executeUpdate();

                session.invalidate(); // 세션 초기화
                response.sendRedirect("index.jsp");
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
    %>
</body>
</html>
