<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="classes.SessionConst" %>
<%@ page import="classes.SQLx" %>
<%@ include file="../common/dbconn.jsp" %>

<html>
<head>
    <title>금액 충전</title>
    <script type="text/javascript">
        // 충전 완료 후 팝업 메시지 및 페이지 리디렉션을 위한 함수
        function showChargeComplete() {
            alert("충전이 완료되었습니다.");
            window.location.href = "member.jsp";
        }
    </script>
</head>
<body>

<%
    String userId = (String) session.getAttribute(SessionConst.USER);
    if(request.getParameter("charge") != null) {
        int chargeAmount = Integer.parseInt(request.getParameter("chargeAmount"));
        String selectQuery = SQLx.Selectx("PREPAID_MONEY", "MEMBER", "ID_NUMBER = '" + userId + "'", "");
        try {
            PreparedStatement pstmt = conn.prepareStatement(selectQuery);
            rs = pstmt.executeQuery();
            int currentBalance = 0;
            if(rs.next()) {
                currentBalance = rs.getInt("PREPAID_MONEY");
            }
            int newBalance = currentBalance + chargeAmount;
            String[] updateKey = {userId};
            String updateQuery = SQLx.Updatex("MEMBER", "PREPAID_MONEY", Integer.toString(newBalance), updateKey);
            pstmt = conn.prepareStatement(updateQuery);
            int result = pstmt.executeUpdate();
            if (result > 0) {
                out.println("<script type='text/javascript'>showChargeComplete();</script>"); // 충전 완료 후 팝업 메시지 및 리디렉션
            } else {
                out.println("<p>충전에 실패하였습니다.</p>");
            }
        } catch (SQLException e) {
            out.println("<p>오류 발생: " + e.getMessage() + "</p>");
        }
    }
%>

<form action="cashCharge.jsp" method="post">
    <label for="chargeAmount">충전할 금액을 입력하세요:</label>
    <input type="number" name="chargeAmount" id="chargeAmount" required>
    <input type="submit" name="charge" value="충전">
</form>
<a href="member.jsp">팀 목록으로 돌아가기</a>
</body>
</html>