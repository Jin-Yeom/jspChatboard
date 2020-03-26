<%@ page language="java" contentType = "text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLDecoder" %>
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
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않는 상태입니다.");
			response.sendRedirect("index.jsp");
			return;
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
 			/* 읽지 않는 메시지 개수 요청 함수 */
 			function getInfiniteUnread() {
 				setInterval(function() {
 					getUnread();
 				});
 			}
 			function showUnread(result) {
 				$('#unread').html(result);
 			}
 			function chatBoxFunction() {
 				var userID = '<%= userID %>';
 				$.ajax({
 					type: "POST",
 					url: "./chatBox",
 					data: {
 						userID: encodeURIComponent(userID),
 					},
 					success: function(data) {
 						if (data == "") return;
 						$('#boxTable').html('');
 						var parsed =  JSON.parse(data);
 						var result = parsed.result;
 						for (var i = 0; i < result.length; i++) {
 							if(result[i][0].value == userID) {
 								result[i][0].value = result[i][1].value;
 							} else {
 								result[i][1].value = result[i][0].value;
 							}
 							addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value, result[i][5].value);
 						}
 					}
 				});
 			}
 			function addBox(lastID, toID, chatContent, chatTime, unread, profile) {
 				$('#boxTable').append('<tr onclick="location.href=\'chat.jsp?toID=' + encodeURIComponent(toID) + '\'">' +	//toID가 제대로 잡히질 않음, 해결 이유 : &nbsp 오류였음
 						'<td style="width: 150px;">' +
 						'<img class="media-object img-circle" style="max-width: 40px; max-height: 40px; margin: 0 auto;" src="' + 
 						profile + '">' +
 						'<h5>' + lastID + '</h5></td>' +
 						'<td>' +
 						'<h5>' + chatContent +
 						'<span class="label label-info">' + unread + '</span></h5>' +
 						'<div class="pull-right">' + chatTime + '</div>' +	//'오전', '오후'가 ??로 나옴 한글이 깨진다, 오타였다
 						'</td>' +
 						'</tr>');
 			}
 			function getInfiniteBox() {
 				setInterval(function() {
 					chatBoxFunction();
 				}, 1000);
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
		<div class="container">
			<table class="table" style="margin: 0 auto;">
				<thead>
					<tr>
						<th><h4>주고받은 메시지 목록</h4></th>
					</tr>
				</thead>
					<tr>
						<td><div style="overflow-y: auto; width: 100%; max-height: 450px;">
							<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd; margin: 0 auto;">
								<tbody id="boxTable">
								</tbody>
							</table>
						</div></td>
					</tr>
			</table>
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
					chatBoxFunction();
					getInfiniteBox();
				});
			</script>
		<%
			}
		%>
	</body> 
</html> 