<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource, java.security.MessageDigest" %>
<html>
<head>
    <title>Sign Up</title>
    <link rel="stylesheet" type="text/css" href="signup.css"> 
</head>
<body>
    <div class="form-container">
        <h3>Sign Up</h3>
        <form action="signUp.jsp" method="post">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required><br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required><br>

            <button type="submit" name="signUp">Sign Up</button>
        </form>

        <%
            if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("signUp") != null) {
                String name = request.getParameter("name");  // 사용자 이름
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                // 비밀번호 해시화
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                md.update(password.getBytes());
                byte[] byteData = md.digest();
                StringBuilder sb = new StringBuilder();
                for (byte b : byteData) {
                    sb.append(String.format("%02x", b));
                }
                String hashedPassword = sb.toString();

                Connection conn = null;
                PreparedStatement stmt = null;
                try {
                    // MySQL 연결
                    Context initContext = new InitialContext();
                    Context envContext  = (Context)initContext.lookup("java:/comp/env");
                    DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
                    conn = ds.getConnection();

                    // 이메일 중복 검사
                    String checkSql = "SELECT COUNT(*) FROM users WHERE email = ?";
                    stmt = conn.prepareStatement(checkSql);
                    stmt.setString(1, email);
                    ResultSet rs = stmt.executeQuery();
                    rs.next();
                    if (rs.getInt(1) > 0) {
                        out.println("<p>Email already exists. Please use another email.</p>");
                    } else {
                        // 사용자 데이터 삽입
                        String insertSql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
                        stmt = conn.prepareStatement(insertSql);
                        stmt.setString(1, name);  // 이름도 DB에 추가
                        stmt.setString(2, email);
                        stmt.setString(3, hashedPassword);
                        stmt.executeUpdate();
                        out.println("<p>Sign Up successful! Redirecting to login page...</p>");
                        response.sendRedirect("index.jsp");
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p> Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
