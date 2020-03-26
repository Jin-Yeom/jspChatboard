<%@ page language="java" contentType = "text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="board.BoardDAO" %>
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
		String boardID = request.getParameter("boardID");
		if (boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO board = boardDAO.getBoard(boardID);
		if(!userID.equals(board.getUserID())) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
 	<head> 
 		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 		<meta name="viewport" content="width=device-width, initial-scale=1">
 		<link rel="stylesheet" href="css/bootstrap.css">
 		<link rel="stylesheet" href="css/custom.css?after3" >
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

		<!-- 프로필사진 폼 -->
		<div class="container">	
			<form method="post" action="./boardUpdate" enctype="multipart/form-data">
				<table class="table table-bordered" style="text-align: center; border: 1px solid #dddddd;">
					<thead>
						<tr>
							<th colspan="3" style="text-align: center;"><h4>게시글 수정</h4></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width: 110px;"><h5>아이디</h5></td>
							<td><h5><%= user.getUserID() %></h5>
							<input type="hidden" name="userID" value="<%= user.getUserID() %>">
							<input type="hidden" name="boardID" value="<%= boardID %>"></td>
						</tr>
						<tr>
							<td style="width: 110px;"><h5>글 제목</h5></td>
							<td><input class="form-control" type="text" name="boardTitle" maxlength="50" placeholder="글 제목을 입력하세요" value="<%= board.getBoardTitle() %>"></td>
						</tr>
						<tr>
							<td style="width: 110px;"><h5>글 내용</h5></td>
							<td><textarea class="form-control" rows="10" name="boardContent" maxlength="2048" placeholder="글 내용을 입력하세요"><%= board.getBoardContent() %></textarea></td>
						</tr>
						<tr>
							<td style="width: 110px;"><h5>파일 업로드</h5></td>
							<td colspan="2">
								<input type="file" name="boardFile" class="file">
								<div class="input-group col-xs-12">
									<span class="input-group-addon"><i class="glyphicon glyphicon-picture"></i></span>
									<input type="text" class="form-control input-lg" disabled placeholder="<%= board.getBoardFile() %>">
									<span class="input-group-btn">
										<button class="browse btn btn-primary input-lg" type="button"><i class="glyphicon glyphicon-search"></i>파일찾기</button>
									</span>
								</div>	
							</td>	
						</tr>
						<tr>
							<td style="text-align: left;" colspan="3"><input type="submit" class="btn btn-primary form-control" 
								value="수정"></td>
						</tr>
					</tbody>
				</table>
			</form>
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
		<script type="text/javascript">
			$(document).on('click', '.browse', function() {
				var file = $(this).parent().parent().parent().find('.file');
				file.trigger('click');
			});
			$(document).on('change', '.file', function() {
				$(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
			});
		</script>
	</body> 
</html> 