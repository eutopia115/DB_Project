<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="classes.SQLx" %>
<%@ page import="classes.SessionConst" %>
<%@ include file="../common/dbconn.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>매치 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #fff;
            color: #333;
        }

        .container {
            margin-top: 20px;
        }

        .card {
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            margin-top: 20px;
            transition: transform 0.3s ease-in-out;
        }

        .btn {
            background-color: #fff;
            color: #333;
            border: 1px solid #333;
            padding: 10px 20px;
            margin: 5px;
            border-radius: 5px;
            transition: background-color 0.3s ease-in-out, color 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }

        .btn:hover, .btn:focus {
            background-color: #ccc;
            color: #333;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th, .table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        .table th {
            background-color: #f2f2f2;
        }

        form {
            display: inline;
        }
        .table {
            border-collapse: collapse;
        }

        .table th, .table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        .table th {
            background-color: #f2f2f2;
        }

        /* 추가된 테이블 스타일 */
        .table-hover tbody tr:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="../index.jsp"><img src="../image/webLogo.png" style ="width: 200px"></a>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            </ul>
            <div class="d-flex" role="search">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 justify-content-end">
                    <%
                        String user = (String) session.getAttribute(SessionConst.USER);
                        if(user == null || user.equals("")){
                    %>
                    <script>
                        alert("세션이 만료되었습니다.");
                        window.location.href = "../common/login.jsp";
                    </script>
                    <%
                            return; // 페이지의 나머지 처리를 중단
                        }
                        if(user==null){

                    %>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="../common/login.jsp">login</a>
                    </li>
                    <%
                    }
                    else{
                        if(user.equals("SOCCERLINK")) {
                    %>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="../admin/admin.jsp">My page</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="../common/logOutProc.jsp">Log out</a>
                    </li>
                    <%
                    }
                    else{
                        String apx = "\'";
                        StringBuilder where = new StringBuilder();
                        where.append("ID_NUMBER = " + apx + user + apx);
                        String checkMember = SQLx.Selectx("ID_NUMBER", "MEMBER", where.toString(), "");
                        pst = conn.prepareStatement(checkMember);
                        rs = pst.executeQuery();
                        if (rs.next()) {
                    %>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="member.jsp">My page</a>
                    </li>

                    <%
                    }
                    else {
                        // manager table에 존재하는지 확인
                        String checkManager = SQLx.Selectx("ID_NUMBER", "MANAGER", where.toString(), "");
                        pst = conn.prepareStatement(checkManager);
                        rs = pst.executeQuery();
                        if (rs.next()) {
                    %>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="../mana/manager.jsp">My page</a>
                    </li>
                    <%
                            }
                        }
                    %>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="../common/logOutProc.jsp">Log out</a>
                    </li>
                    <%
                            }
                        }
                    %>
                </ul>
            </div>
        </div>
    </div>
</nav>
<hr>

<div class="container">
    <h1>매치 목록</h1>
    <a href="viewMyMatch.jsp" class="btn btn-primary">View My Match</a>
    <a href="deleteMyMatch.jsp" class="btn btn-danger">Delete My Match</a>
    <table class="table table-hover">
        <tr>
            <th>매치 ID</th>
            <th>날짜/시간</th>
            <th>장소 이름</th>
            <th>현재 인원/최대 인원</th>
            <th>평균 티어</th>
            <th>참가비</th>
            <th>신청</th>
        </tr>
        <%
            String query = "SELECT M.*, F.ADDRESS, (SELECT COUNT(*) FROM MATCH_APP_MEMBER WHERE MATCH_ID = M.MATCH_ID) AS CURRENT_NUM, MV.MATCH_TIER FROM MATCH M INNER JOIN FIELD F ON M.PLACE_ID = F.FIELD_ID LEFT JOIN MATCH_EVAL_VIEW MV ON M.MATCH_ID = MV.MATCH_ID";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet matchResultSet = pstmt.executeQuery();
            while (matchResultSet.next()) {
                String matchId = matchResultSet.getString(1);
                Date dateTime = matchResultSet.getDate(2);
                String placeName = matchResultSet.getString(10);
                int maxNum = matchResultSet.getInt(5);
                int currentNum = matchResultSet.getInt(11);
                double costPerOne = matchResultSet.getDouble(9);
                String matchTier = matchResultSet.getString(12); // Retrieves the match tier
                String formattedCost = String.format("%.0f", costPerOne);
                boolean isFull = currentNum >= maxNum;
        %>
        <tr>
            <td><%= matchId %></td>
            <td><%= dateTime.toString() %></td>
            <td><%= placeName %></td>
            <td><%= currentNum + "/" + maxNum %></td>
            <td><%= matchTier %></td>
            <td><%= formattedCost %>원</td>
            <td>
        <% if (!isFull) { %>
    <form action="matchApply.jsp" method="post">
        <input type="hidden" name="matchId" value="<%= matchId %>">
        <button type="submit" class="btn btn-sm btn-primary">신청하기</button>
    </form>
<% } else { %>
    인원이 꽉 찼습니다.
<% } %>
    </span>
            </td>

                </span>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <a href="member.jsp" class="btn btn-primary">뒤로 가기</a>
</div>
</body>
</html>
