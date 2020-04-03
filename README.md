# jspChatboard
실시간 채팅기능과 게시판기능을 혼합해놓은 jsp웹사이트입니다.
실시간채팅과 메시지 그리고 프로필사진을 추가할 수 있습니다.
게시판 또한 이미지파일을 첨부할 수 있으며 다운로드 할 수 있게 만들었습니다. 
이 기능들은 회원가입 및 로그인을 하지 않으면 사용할 수 없습니다.

# 사용 기술
<li><a>Java, Html, xml, Servlet, Ajax, Json, bootstrap</a></li>

# 프로젝트 기간 및 인원
기간 : 2020.03.12 ~ 2020.04.01<br>
인원 : 1명

# 프로젝트
<strong>시작 화면</strong>



![jsp](https://user-images.githubusercontent.com/57334358/78343163-64eda080-75d5-11ea-9a12-325f145a438d.png)

jumbotron과 footer, navbar를 사용하여 간단하게 꾸몄습니다.


<strong>로그인 및 회원가입</strong>



![login](https://user-images.githubusercontent.com/57334358/78344343-353f9800-75d7-11ea-821f-f616ceeaf3ac.PNG)
![register](https://user-images.githubusercontent.com/57334358/78344473-66b86380-75d7-11ea-9ab9-0d7ec072e9e7.PNG)

간단한 정보들을 넣을 수 있도록 회원가입을 구성했습니다. <br>
로그인을 하지 않을 시에는 사이트의 기능을 사용하지 못합니다.

<strong>프로필 수정 및 회원정보 수정</strong>



![프로필수정](https://user-images.githubusercontent.com/57334358/78345238-6c627900-75d8-11ea-9c83-490f79289dbc.PNG)
![회원정보수정](https://user-images.githubusercontent.com/57334358/78345266-77b5a480-75d8-11ea-8558-21c6ffeede8f.PNG)

회원정보와 프로필을 수정 할 수 있습니다.<br>
프로필을 등록하지 않았을 시에는 기본 아이콘이 나오도록 설정하였습니다.


<strong>메시지함</strong>



![메시지함](https://user-images.githubusercontent.com/57334358/78346704-5e155c80-75da-11ea-8711-0c13cc718f1c.PNG)

다른 유저에게 채팅을 보내면 메시지함에 읽지 않은 메시지로 저장이 됩니다. <br>
읽었을 시, '읽지 않은 메시지 수' 아이콘이 사라지며 채팅창으로 이동하게 됩니다.


<strong>친구 찾기</strong>


![검색1](https://user-images.githubusercontent.com/57334358/78347690-d4ff2500-75db-11ea-9fb5-c82f38626f8d.PNG)
![검색](https://user-images.githubusercontent.com/57334358/78347271-307ce300-75db-11ea-8512-e4d306b19d72.PNG)

채팅창을 들어가면 우선 대상자를 찾을 수 있게 도와줍니다. <br>
검색을 통해 대상을 찾았다면 대상이 지정해놓은 이미지와 함께 채팅창으로 들어가는 버튼이 활성화됩니다.


<strong>채팅창</strong>



![채팅](https://user-images.githubusercontent.com/57334358/78348056-6078b600-75dc-11ea-9151-828b63fe8762.PNG)

내용을 작성하면 채팅창에 기록이 되고 받는 대상의 '읽지 않은 메시지 수'를 추가시킵니다.


<strong>게시판</strong>



![게시판](https://user-images.githubusercontent.com/57334358/78348783-8f435c00-75dd-11ea-9b8c-5d9ae8e211ab.PNG)

자신의 게시물을 수정 및 삭제할 수 있습니다. 답변을 달 시에는 화살표로 '답변'이라고 표시해줍니다.


<strong>파일 다운로드</strong>



![다운로드](https://user-images.githubusercontent.com/57334358/78349503-aafb3200-75de-11ea-81b2-b9260f58027d.PNG)

게시판에 10MB이하의 파일을 첨부하였을 시 다른 사용자가 그 파일을 다운로드 할 수 있습니다.
