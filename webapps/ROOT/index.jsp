<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource, java.security.MessageDigest" %>
<%@ page session="true" %>
<html>
<head>
    <title>User Login</title>
    <link rel="stylesheet" type="text/css" href="styles.css"> <!-- styles.css 링크 -->
</head>
<body>
    <div class="form-container">
        <%
            String userEmail = (String) session.getAttribute("userEmail"); // 세션에서 사용자 이메일 가져오기
        %>

        <% if (userEmail == null) { %>
            <!-- 로그인 폼 -->
            <h3>Login</h3>
            <form action="index.jsp" method="post">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required><br>

                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required><br>

                <button type="submit" name="login">Login</button>
            </form>

            <br>
            <a href="signUp.jsp"><button>Sign Up</button></a> <!-- 회원가입 페이지 이동 버튼 -->
        <% } else { %>
            <!-- 로그인 성공 시 메시지 -->
            <%
                String userName = (String) session.getAttribute("userName"); // 세션에서 사용자 이름 가져오기
            %>
            <h2>Welcome, <%= userName %>!</h2>

            <!-- 회원탈퇴 버튼 -->
            <form action="deleteUser.jsp" method="post">
                <input type="hidden" name="email" value="<%= userEmail %>">
                <button type="submit" name="delete">Delete Account</button>
            </form>

            <!-- 로그아웃 버튼 -->
            <form action="logout.jsp" method="post">
                <button type="submit" class="btn logout-btn">Logout</button>
            </form>
        <% } %>

        <%
            if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("login") != null) {
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
                ResultSet rs = null;
                try {
                    // MySQL 연결
                    Context initContext = new InitialContext();
                    Context envContext  = (Context)initContext.lookup("java:/comp/env");
                    DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
                    conn = ds.getConnection();

                    // 로그인 검증
                    String loginSql = "SELECT name FROM users WHERE email = ? AND password = ?";
                    stmt = conn.prepareStatement(loginSql);
                    stmt.setString(1, email);
                    stmt.setString(2, hashedPassword);
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        String userName = rs.getString("name");
                        session.setAttribute("userName", userName);
                        session.setAttribute("userEmail", email);
                        response.sendRedirect("index.jsp"); // 로그인 후 새로고침하여 환영 메시지 표시
                    } else {
                        out.println("<p> Invalid email or password.</p>");
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
