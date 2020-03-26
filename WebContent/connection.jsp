<!-- 커넥션 풀: 데이터베이스에 접근할 때 간편하고 안정적으로 접근 가능하게 함, 데이터베이스에 접근한 사용자의 수를 효율적으로 관리할수 있음 -->
<!-- 커넥션 풀 테스트: 모든 리소스를 서버로 반환시킴 -->
<html> 
 	<head> 
 		<%@ page import="java.sql.*, javax.sql.*, java.io.*,
 			javax.naming.InitialContext, javax.naming.Context" %>
 	</head> 
 	<body>
 		<%
 			InitialContext initCtx = new InitialContext();
 		
 			/* initCtx 컨텍스트를 중심으로 리소스를 찾을 수 있도록 만듬 */
 			Context envContext = (Context) initCtx.lookup("java:/comp/env");
 			
 			/* 소스발견시 프로젝트에 접근하게 만듬 */
 			DataSource ds = (DataSource) envContext.lookup("jdbc/UserChat");
 			
 			/* 커넥션객체를 이용해서 mysql 데이터베이스에 접근하게 만듬 */
 			Connection conn = ds.getConnection();
 			
 			/* sql문장을 데이터베이스에 입력한다음에 결과 반환하게 만듬 */
 			Statement stmt = conn.createStatement();
 			
 			/* mysql 버전을 rset에 넣어줌 */
 			ResultSet rset = stmt.executeQuery("SELECT VERSION();");
 			
 			/* 결과가 존재한다면 출력할 수 있도록 만듬 */
 			while(rset.next()) {
 				out.println("MySQL Version: " + rset.getString("version()"));
 			}
 			rset.close();
 			stmt.close();
 			conn.close();
 			initCtx.close();
 		%>
	</body> 
</html> 