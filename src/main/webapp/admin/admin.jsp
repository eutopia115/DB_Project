<%@ page import="classes.SQLx" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../common/dbconn.jsp" %>
<%@ page import="java.time.LocalDate" %>
<html>

<title>마이 페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
<link href="../style/main.css" rel="stylesheet">
<style>


    body, html {
        margin: 0;
        padding: 0;
        font-family: 'Noto Sans KR', sans-serif; /* Noto Sans KR 글꼴 적용 */
        background-color: #fff;
        color: #333;
    }


    .card {
        background-color: #fff;
        border-radius: 15px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        margin-top: 20px;
        transition: transform 0.3s ease-in-out;
    }

    .btn {
        background-color: #fff; /* 흰색 배경 */
        color: #333; /* 텍스트 색상을 어두운 색상으로 설정 */
        border: 1px solid #333; /* 테두리 색상을 어두운 색상으로 설정 */
        padding: 10px 20px;
        margin: 5px;
        border-radius: 5px;
        transition: background-color 0.3s ease-in-out, color 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
    }

    /* 클릭 또는 호버 시 배경색과 텍스트 색상 변경 */
    .btn:hover, .btn:focus {
        background-color: #ccc; /* 클릭 또는 호버 시 배경색을 어두운 회색으로 변경 */
        color: #333; /* 클릭 또는 호버 시 텍스트 색상을 어두운 색상으로 유지 */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 클릭 또는 호버 시 그림자 효과 추가 */
    }
</style>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Admin page</title>
    <%
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        String sqlIncome = SQLx.Selectx("SUM(PREPAID_MONEY)", "MEMBER");
        String sqlOutMatch = SQLx.Selectx("SUM(WAGE)", "MATCH","WHERE DATE_TIME LIKE '%"+month+"%'");
        String sqlOutTrain = SQLx.Selectx("SUM(WAGE)", "TRAINING", "WHERE DATE_TIME LIKE '%"+month+"%'");
        pst = conn.prepareStatement(sqlIncome);
        rs = pst.executeQuery();
        rs.next();
        Integer totalDeposit = rs.getInt(1);//총 예치금
        pst = conn.prepareStatement(sqlOutMatch);
        rs = pst.executeQuery();
        rs.next();
        Integer socialMatchPaymentExpectedAmount = rs.getInt(1);//소셜매치 지불예정금액
        pst = conn.prepareStatement(sqlOutTrain);
        rs = pst.executeQuery();
        rs.next();
        Integer expectedTrainingPaymentAmount = rs.getInt(1);//트레이닝 지불예정금액
    %>
</head>
<body>
<jsp:include page="menu.jsp"/>
<div class="container my-4">
    <div class="card">
        <div class="card-body">
            <p class="card-text">총 예치금: <%= totalDeposit %> 원</p>
            <p class="card-text"><%=month%>월 소셜매치 지불 예정 금액: <%= socialMatchPaymentExpectedAmount %> 원</p>
            <p class="card-text"><%=month%>월 트레이닝 지불 예정 금액: <%= expectedTrainingPaymentAmount %> 원</p>
        </div>
    </div>
</div>
<br>
<br>
</body>
</html>