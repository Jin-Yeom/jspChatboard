<%@ page language="java" contentType = "text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html> 
<html>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않은 상태입니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		UserDTO user = new UserDAO().getUser(userID);
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
 			function passwordCheckFunction() {
    			var userPassword1 = $('#userPassword1').val();
    			var userPassword2 = $('#userPassword2').val();
    			if(userPassword1 != userPassword2) {
    				$('#passwordCheckMessage').html('비밀번호가 서로 일치하지 않습니다.');
    			} else {
    				$('#passwordCheckMessage').html('');
    			}
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
				</div>
			</div>
		</nav>

		<!-- 회원가입 폼 -->
		<div class="container">
			<div class="col-lg-4"></div>
			<div class="col-lg-4">
				
					<!-- 회원가입 정보를 숨기면서 전송post -->
					<form method="post" action="./userUpdate">
						<h3 style="text-align: center;">회원정보수정</h3>
						<div class="form-group">
							<input type="hidden" class="form-control" placeholder="아이디"
								name="userID" maxlength="20" id="userID" value="<%= user.getUserID() %>">
						</div>
						<div class="form-group">
							<input type="password" class="form-control" placeholder="비밀번호"
								name="userPassword1" onkeyup="passwordCheckFunction();" maxlength="20" id="userPassword1">
						</div>
						<div class="form-group">
							<input type="password" class="form-control" placeholder="비밀번호 확인"
								name="userPassword2" onkeyup="passwordCheckFunction();" maxlength="20" id="userPassword2">
						</div>
						<div class="form-group">
							<input type="text" class="form-control" placeholder="이름"
								name="userName" maxlength="20" id="userName" value="<%= user.getUserName() %>">
						</div>
						<div class="form-group">
							<input type="number" class="form-control" placeholder="나이"
								name="userAge" maxlength="20" id="userAge" value="<%= user.getUserAge() %>">
						</div>
						<div class="form-group" style="text-align: center;">
							<div class="btn-group" data-toggle="buttons">
								<label class="btn btn-primary <% if(user.getUserGender().equals("남자")) out.print("active"); %>"> 
									<input type="radio" name="userGender" autocomplete="off" 
										value="남자" <% if(user.getUserGender().equals("남자")) out.print("checked"); %>>남자
								</label> 
								<label class="btn btn-primary <% if(user.getUserGender().equals("여자")) out.print("active"); %>"> 
								<input type="radio" name="userGender" autocomplete="off" 
									value="여자" <% if(user.getUserGender().equals("여자")) out.print("checked"); %>>여자
								</label>
							</div>
						</div>
						<div class="form-group">
							<input type="email" class="form-control" placeholder="이메일"
								name="userEmail" maxlength="50" id="userEmail" value="<%= user.getUserEmail() %>">
						</div>
						<h5 style="color: red;" id="passwordCheckMessage"></h5>
						<input type="submit" class="btn btn-primary form-control"
							value="수정">
					</form>
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
	</body> 
</html> 