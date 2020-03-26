<%@page language="java" contentType = "text/html; charset = UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<!-- 뷰포트 -->
		<meta name="viewport" content="width=device-width, initial-scale=1">
		
		<!-- 부트스트랩 -->
		<link rel="stylesheet" href="css/bootstrap.css">
		<link rel="stylesheet" href="css/custom.css?after">
		<title>jsp 웹게시판</title>
		<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    	<script src="js/bootstrap.js"></script>
    	<script type="text/javascript">
    		function registerCheckFunction() {
    			var userID = $('#userID').val();
    			$.ajax({
    				type: 'POST',
    				url: './UserRegisterCheckServlet',
    				data: {userID: userID},
    				success: function(result) {
    					if (result == 1) {
    						$('#checkMessage').html('사용할 수 있는 아이디입니다.');
    						$('#checkType').attr('class', 'modal-content panel-success');
    					} else {
    						$('#checkMessage').html('사용할 수 없는 아이디입니다.');
    						$('#checkType').attr('class', 'modal-content panel-warning');
    					}
    					$('#checkModal').modal("show");
    				}	
    			})
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
		<%
			String userID = null;
			if (session.getAttribute("userID") != null) {
				userID = (String) session.getAttribute("userID");
			}
			if(userID != null) {
				session.setAttribute("messageType", "오류 메시지");
				session.setAttribute("messageContent", "현재 로그인이 되어 있는 상태입니다.");
				response.sendRedirect("index.jsp");
				return;
			}
		%>
		<nav class="navbar navbar-default">
			<div class="container-fluid">
				<div class="navbar-header">
					<a class="navbar-brand" href="index.jsp">JSP 웹게시판</a>
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
						}
					%>
				</div>
			</div>
		</nav>
		
		<!-- 회원가입 폼 -->
		<div class="container">
			<div class="col-lg-4"></div>
			<div class="col-lg-4">
			
				<!-- 로그인 정보를 숨기면서 전송post -->
				<form method="post" action="./userRegister">
					<h3 style="text-align: center;">회원가입</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디"
							name="userID" maxlength="20" id="userID">
					</div>
					<div class="form-group" style="text-align: center;">
					<button class="btn btn-primary" onclick="registerCheckFunction();" type="button">중복체크</button>
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
							name="userName" maxlength="20" id="userName">
					</div>
					<div class="form-group">
						<input type="number" class="form-control" placeholder="나이"
							name="userAge" maxlength="20" id="userAge">
					</div>
					<div class="form-group" style="text-align: center;">
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-primary active"> 
								<input type="radio" name="userGender" autocomplete="off" 
									value="남자" checked>남자
							</label> 
							<label class="btn btn-primary"> 
							<input type="radio" name="userGender" autocomplete="off" 
								value="여자" >여자
							</label>
						</div>
					</div>
					<div class="form-group">
						<input type="email" class="form-control" placeholder="이메일"
							name="userEmail" maxlength="50" id="userEmail">
					</div>
					<h5 style="color: red;" id="passwordCheckMessage"></h5>
					<input type="submit" class="btn btn-primary form-control"
						value="회원가입">
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
	</body>
</html>