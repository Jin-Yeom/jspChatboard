<%@ page language="java" contentType = "text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
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
		String boardID = null;
		if (request.getParameter("boardID") != null) {
			boardID = (String) request.getParameter("boardID");
		}
		if (boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "게시물을 선택해주세요.");
			response.sendRedirect("index.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO board = boardDAO.getBoard(boardID);
		if (board.getBoardAvailable() == 0) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "삭제된 게시물입니다.");
			response.sendRedirect("boardView.jsp");
			return;
		}
		boardDAO.hit(boardID);
	%>
 	<head> 
 		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 		<meta name="viewport" content="width=device-width, initial-scale=1">
 		<link rel="stylesheet" href="css/bootstrap.css">
 		<link rel="stylesheet" href="css/custom.css?after11">
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
			<table class="table table-bordered table-hover">
				<thead>
					<tr>
						<th colspan="6"><h4>게시물</h4></th>
					</tr>
					<tr>
						<td style="width: 80px;"><h5>제목</h5></td>
						<td colspan="5" style="background-color: #dddddd;"><h5><%= board.getBoardTitle() %></h5></td>
					</tr>
					<tr>
						<td style="width: 80px;"><h5>작성자</h5></td>
						<td colspan="5" style="background-color: #dddddd;"><h5><%= board.getUserID() %></h5></td>
					</tr>
					<tr>
						<td style="width: 80px;"><h5>작성날짜</h5></td>
						<td colspan="3" style="background-color: #dddddd;"><h5><%= board.getBoardDate() %></h5></td>
						<td style="width: 80px;"><h5>조회수</h5></td>
						<td colspan="3" style="background-color: #dddddd;"><h5><%= board.getBoardHit() + 1%></h5></td>
					</tr>
					<tr>
						<td style="min-height: 150px; vertical-align: middle; width: 80px; height: 300px;"><h5>글 내용</h5></td>
						<td colspan="5" style="text-align: left; background-color: #dddddd;"><h5><%= board.getBoardContent() %></h5></td>
					</tr>
					<tr>
						<td style="width: 80px;"><h5>첨부파일</h5></td>
						<td colspan="5" style="background-color: #dddddd;"><h5><a href="boardDownload.jsp?boardID=<%= board.getBoardID() %>"><%= board.getBoardFile() %></a></h5></td>
					</tr>
				</thead>
			</table>
			<a href="boardView.jsp" class="btn btn-primary pull-right">목록</a>
			<a href="boardReply.jsp?boardID=<%= board.getBoardID() %>" class="btn btn-primary pull-right">답변</a>
			<%
				if(userID.equals(board.getUserID())) {
			%>		
					<a href="boardDelete?boardID=<%= board.getBoardID() %>" class="btn btn-primary pull-right" onclick="return confirm('삭제 하시겠습니까?')">삭제</a>
					<a href="boardUpdate.jsp?boardID=<%= board.getBoardID() %>" class="btn btn-primary pull-right">수정</a>
			<%
				}
			%>
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