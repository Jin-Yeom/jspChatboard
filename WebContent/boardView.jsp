<%@ page language="java" contentType = "text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="java.util.ArrayList" %>
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
		String pageNumber = "1";
		if (request.getParameter("pageNumber") != null) {
			pageNumber = request.getParameter("pageNumber");
		}
		try {
			Integer.parseInt(pageNumber);
		} catch (Exception e) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "페이지 번호가 잘못되었습니다.");
			response.sendRedirect("boardView.jsp");
			return;
		}
		ArrayList<BoardDTO> boardList = new BoardDAO().getList(pageNumber);
	%>
 	<head> 
 		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 		<meta name="viewport" content="width=device-width, initial-scale=1">
 		<link rel="stylesheet" href="css/bootstrap.css">
 		<link rel="stylesheet" href="css/custom.css?after6">
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
						<th colspan="5" style="text-align: center;"><h4>게시판</h4></th>
					</tr>
					<tr>
						<th style="text-align: center;"><h5>번호</h5></th>
						<th style="text-align: center;"><h5>제목</h5></th>
						<th style="text-align: center;"><h5>작성자</h5></th>
						<th style="text-align: center;"><h5>날짜</h5></th>
						<th style="text-align: center;"><h5>조회수</h5></th>
					</tr>
				</thead>
				<tbody>
					<%
						for(int i = 0; i < boardList.size(); i++) {
							BoardDTO board = boardList.get(i);
					%>
						<tr>
							<td><%= board.getBoardID() %></td>
							<td style="text-align: left;">
								<a href="boardShow.jsp?boardID=<%= board.getBoardID() %>">
							<%
								for(int j = 0; j < board.getBoardLevel(); j++) {
							%>
									<span class="glyphicon glyphicon-arrow-right" aria-hidden="true"></span>
							<%
								}
							%>
							<%
								if (board.getBoardAvailable() == 0) {
							%>
								(삭제된 게시물입니다.)
							<%
								} else {
							%>
								<%= board.getBoardTitle() %>
							<%
								}
							%></a></td>
							<td><%= board.getUserID() %></td>
							<td><%= board.getBoardDate() %></td>
							<td><%= board.getBoardHit() %></td>
						</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<ul class="pagination" style="position: absolute; left: 50%; transform: translateX(-50%);">
			<%
				int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
				if (Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
				int targetPage = new BoardDAO().targetPage(pageNumber);
				if(startPage != 1) {
			%>
				<li><a href="boardView.jsp?pageNumber=<%= startPage - 1%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
			<%
				} else {
			%>
				<li><span class="glyphicon glyphicon-chevron-left" style="color: gray;"></span></li>
			<%
				}
				for(int i = startPage; i < Integer.parseInt(pageNumber); i++) {
			%>
				<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
			<%
				}
			%>
				<li class="active"><a href="boardView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>
			<%
				for(int i = Integer.parseInt(pageNumber) + 1; i <= targetPage + Integer.parseInt(pageNumber); i++) {
					if (i < startPage + 10) {
			%>
				<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
			<%
					}
				}
			if (targetPage + Integer.parseInt(pageNumber) > startPage +9) {
			%>
				<li><a href="boardView.jsp?pageNumber=<%= startPage + 10 %>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
			<%
				} else {
			%>
				<li><span class="glyphicon glyphicon-chevron-right" style="color: gray;"></span></li>
			<%
				}
			%>
			</ul>
			<a href="boardWrite.jsp" class="btn btn-primary pull-right" type="submit">글쓰기</a>
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