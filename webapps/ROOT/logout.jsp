<%@ page session="true" %>
<%
    session.invalidate(); // 세션 초기화
    response.sendRedirect("index.jsp"); // 로그인 페이지로 이동
%>
