<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../common/dbconn.jsp" %>
<%@ page import="classes.SessionConst" %>
<%@ page import="classes.SQLx" %>

<html>
<head>
    <title>모든 팀 정보</title>
</head>
<body>
<h1>모든 팀 정보</h1>
<table border="1">
    <tr>
        <th>팀 ID</th>
        <th>팀 이름</th>
    </tr>
    <%
        String userId = (String) session.getAttribute(SessionConst.USER);
        String query = SQLx.Selectx("T.TEAM_ID, T.TEAM_NAME", "TEAM_MEM TM INNER JOIN TEAM T ON TM.TEAM_ID = T.TEAM_ID", "TM.MEM_ID = '" + userId + "'", "");
        PreparedStatement pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String teamId = rs.getString("TEAM_ID");
            String teamName = rs.getString("TEAM_NAME");
    %>
    <tr>
        <td><%= teamId %></td>
        <td><%= teamName %></td>
    </tr>
    <%
        }
        rs.close();
        pstmt.close();
    %>
</table>
<a href="team.jsp">팀 목록으로 돌아가기</a>
</body>
</html>
