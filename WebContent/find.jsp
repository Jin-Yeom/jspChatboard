<%@ page language="java" contentType = "text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html> 
<html> 
	<%
			String userID = null;
			if (session.getAttribute("userID") != null) {
				userID = (String) session.getAttribute("userID");
			}
			if(userID == null) {
				session.setAttribute("messageType", "오류 메시지");
				session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
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
 			function findFunction() {
 				var userID = $('#findID').val();
 				$.ajax({
 					type: "POST",
 					url: "./UserFindServlet",
 					data: {userID: userID},
 					success: function(result) {
 						if (result == -1) {
 							$('#checkMessage').html('친구를 찾을 수 없습니다.');
 							$('#checkType').attr('class', 'modal-content panel-warning');
 							failFriend();
 						} else {
 							$('#checkMessage').html('친구찾기에 성공했습니다.');
 							$('#checkType').attr('class', 'modal-content panel-success');
 							var data = JSON.parse(result);
 							var profile = data.userProfile;
 							getFriend(userID, profile);
 						}
 						$('#checkModal').modal("show");
 					}
 				});
 			}
 			function getFriend(findID, userProfile) {
 				$('#friendResult').html('<thead style="background-color: #CCFFFF;">' +
 						'<tr>' +
 						'<th><h4 style="text-align: center;"><b>검색 결과</b></h4></th>' +
 						'</tr>' +
 						'</thead>' +
 						'<tbody>' +
 						'<tr>' +
 						'<td style="text-align: center; background-color: #CCCCFF;">' +
 						'<img class="media-object img-circle" style="max-width: 300px; margin: 0 auto;" src="' + 
 						userProfile + '">' +
 						'<h3>' + findID +
 						'</h3><a href="chat.jsp?toID=' +
 						encodeURIComponent(findID) +
 						'" class="btn btn-primary pull-right">' +
 						'메시지 보내기</a></td>' +
 						'</tr>' +
 						'</tbody>');
 			}
 			function failFriend() {
 				$('#friendResult').html('');
 			}
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
			<table class="table table-bordered" style="border: 1px solid #dddddd;">
				<thead style="background-color: #99ff99;">
					<tr>
						<th colspan="2"><h4 style="text-align: center;"><b>검색으로 친구찾기</b></h4></th>
					</tr>
				</thead>
				<tbody style="background-color: #99cc99;">
					<tr>
						<td style="width: 110px;"><h5><b>친구 아이디</b></h5></td>
						<td><input class="form-control" type="text" id="findID" maxlength="20" placeholder="찾을 아이디"></td>
					</tr>
					<tr>
						<td colspan="2"><button class="btn btn-primary pull-right" onclick="findFunction();">검색</button></td>
					</tr>
				</tbody>
			</table>
			<div style=" border: 1px solid #dddddd;">
				<table id="friendResult" class="table table-bordered table-hover">
				</table>
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
		<script>
			$('#messageModal').modal("show");
		</script>
		<%	
			/* 서버로부터 받은 세션 값 */
			session.removeAttribute("messageContent");
			session.removeAttribute("messageType");
			}
		%>
		<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="vertical-alignment-helper">
				<div class="modal-dialog vertical-align-center">
					<div id="checkType" class="modal-content panel-info">
						<div class="modal-header panel-heading">
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&times;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title">
								확인 메시지
							</h4>
						</div>
						<div id="checkMessage" class="modal-body"></div>
						<div class="modal-footer">
							<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
						</div>
					</div>
				</div>
			</div>
		</div>
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