<%@ page language="java" contentType = "text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html> 
<html>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
	%>
 	<head> 
 		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 		<meta name="viewport" content="width=device-width, initial-scale=1">
 		<link rel="stylesheet" href="css/bootstrap.css">
 		<link rel="stylesheet" href="css/custom.css?after">
 		<title> JSP 실시간 회원제 채팅</title>
 		<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
 		<script src="js/bootstrap.js"></script>
 		<script type="text/javascript">
 			function getUnread() {
 				$.ajax({
 					type: "POST",
 					url: "./chatUnread",
 					data: {
 						userID: encodeURIComponent('<%= userID %>'),
 					},
 					success: function(result) {
 						if (result >= 1) {
 							showUnread(result);
 						} else {
 							showUnread('');	
 						}
 					}	
 				});
 			}
 			/* 반복적으로 서버에게 일정한 주기마다 읽지 않는 메시지 개수 요청 함수 */
 			function getInfiniteUnread() {
 				setInterval(function() {
 					getUnread();
 				});
 			}
 			function showUnread(result) {
 				$('#unread').html(result);
 			}
 		</script>
 		<style type="text/css">
			.jumbotron {
				background-image: url('images/coding.jfif');
				background-size: cover;
				text-align: center; 
				text-shadow: red 0.2em 0.2em 0.2em;
				color: white;
			}
			.footer {
				position: absolute;
			    left: 0;
			    bottom: 0;
			    width: 100%;
				padding: 15px;
				background-color: #392f31;
				color: #ffffff;
				text-align: center; 
			}
		</style>
 	</head> 
 	<body> 
		
		<!-- 네비게이션  -->
		<nav class="navbar navbar-default">
			<div class="container-fluid">
				<div class="navbar-header">
					<a class="navbar-brand" href="index.jsp">JSP 웹사이트</a>
					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
						data-target="#collapsibleNavbar" aria-expanded="false">
						<span class="sr-only"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>	
				</div>
				<div class="collapse navbar-collapse" id="collapsibleNavbar">
					<ul class="nav navbar-nav">
						<li><a href="boardView.jsp">게시판</a>
						<li><a href="find.jsp">채팅창</a></li>
						<li><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
					</ul>
					<%
						if(userID == null) {
					%>
		   				<ul class="nav navbar-nav navbar-right">
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
									aria-haspapup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li><a href="login.jsp">로그인</a></li>
									<li><a href="join.jsp">회원가입</a></li>
								</ul>
							</li>
						</ul>	   					
	   				<%
						} else {
	   				%>
	   					<ul class="nav navbar-nav navbar-right">
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
									aria-haspapup="true" aria-expanded="false">회원관리<span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li><a href="update.jsp">회원정보수정</a></li>
									<li><a href="profileUpdate.jsp">프로필수정</a></li>
									<li><a href="logoutAction.jsp">로그아웃</a></li>
								</ul>
							</li>
						</ul>	   
	   				<%
						}
	   				%>
				</div>
			</div>
		</nav>
		<div class="container">
			<div class="jumbotron">
				<h1>안녕하세요.</h1>
				<p>jsp를 공부하기 위해 웹사이트를 만들었습니다.</p>
			</div>
		</div>
		<%
			String messageContent = null;
			if (session.getAttribute("messageContent") != null) {
				messageContent = (String) session.getAttribute("messageContent");
			}
			String messageType = null;
			if (session.getAttribute("messageType") != null) {
				messageType = (String) session.getAttribute("messageType");
			}
			if (messageContent != null) {
		%>
		<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="ture">
			<div class="vertical-alignment-helper">
				<div class="modal-dialog vertical-align-center">
					<div class="modal-content <% if(messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success"); %>">
						<div class="modal-header panel-heading">
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&times;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title">
								<%= messageType %>
							</h4>
						</div>
						<div class="modal-body">
							<%= messageContent %>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%	
			/* 서버로부터 받은 세션 값 */
			session.removeAttribute("messageContent");
			session.removeAttribute("messageType");
			}
		%>
		<script>
			$('#messageModal').modal("show");
		</script>
		<%
			if(userID != null) {
		%>
			<script type="text/javascript">
				$(document).ready(function() {
					getUnread();
					getInfiniteUnread();
				});
			</script>
		<%
			}
		%>
			<!-- footer -->
			<footer class="footer">
	    		<!-- About -->
	    		
	    		<div class="row">
	    			<div class="col-sm-2"  style="text-align: center;"><h4>이진염(Jinyeom Lee) : </h4></div>
	    			<div style="text-align: center;"><h5>경기산업기술교육센터에서 처음 코딩을 접하고 재미를 느껴 공부하고 있습니다.
		        		현재 포트폴리오를 만드는 중입니다.<h5>Arduino, c++, python, java, html, php, mySQL, javascript, jsp 등을 사용해 보았고
           				웹개발자를 목표로 하고 있습니다.</h5></h5></div>
	    		</div>
	    		<br>
	    		<br>
	    		<a style="color: #ffffff;"> Email: vpxh12@naver.com, call: 010-5179-9279</a>
	      	</footer>
	</body> 
</html> 