<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String err = request.getParameter("error"); // 필요하면 사용
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>회원가입 | ReadingLetter</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/auth/auth.css">

</head>
<body>

<div class="auth-wrap">

    <!-- Left: Brand -->
    <section class="brand-panel" aria-label="브랜드 소개">
        <div class="logo">
            <div class="logo-badge" aria-hidden="true">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                    <path d="M4 6.5C4 5.12 5.12 4 6.5 4H20v14.5c0 1.38-1.12 2.5-2.5 2.5H4V6.5Z" stroke="white" stroke-width="1.6"/>
                    <path d="M8 7h8M8 11h8M8 15h5" stroke="white" stroke-width="1.6" stroke-linecap="round"/>
                </svg>
            </div>
            <div>ReadingLetter</div>
        </div>

        <h1 class="brand-title">환영해! 이제 시작이야</h1>
        <p class="brand-sub">
            가입하고 나만의 독후감을 만들고, <br/>
            미래의 나에게 편지로 보내보자.
        </p>

        <ul class="feature-list">
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>태그로 편지 톤 선택</b>
                    <span>#위로 #동기부여 #냉정한조언 등</span>
                </div>
            </li>
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>독서 기록 자동 저장</b>
                    <span>타이머 기반으로 읽기 세션이 쌓여요</span>
                </div>
            </li>
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>공개글 & 랭킹</b>
                    <span>좋아요/조회 기반 TOP 5에 도전!</span>
                </div>
            </li>
        </ul>
    </section>

    <!-- Right: Form -->
    <section class="form-card" aria-label="회원가입 폼">
        <div class="card-top">
            <div>
                <h2>회원가입</h2>
                <p>30초면 끝. 이메일/닉네임만 있으면 돼.</p>
            </div>
            <span class="badge">Create Account</span>
        </div>

        <form method="post" action="<%=request.getContextPath()%>/auth/signup" autocomplete="on" onsubmit="return validateForm();">
            <div class="field">
                <label for="email">이메일</label>
                <input class="input" id="email" name="email" type="email" placeholder="example@domain.com" required />
            </div>

            <div class="row">
                <div class="field">
                    <label for="nickname">닉네임</label>
                    <input class="input" id="nickname" name="nickname" type="text" placeholder="예: 영준" minlength="2" maxlength="20" required />
                </div>
            </div>

            <div class="row">
                <div class="field">
                    <label for="password">비밀번호</label>
                    <input class="input" id="password" name="password" type="password" placeholder="최소 6자" minlength="6" required />
                </div>
                <div class="field">
                    <label for="password2">비밀번호 확인</label>
                    <input class="input" id="password2" type="password" placeholder="한 번 더 입력" minlength="6" required />
                </div>
            </div>

            <div id="msg" class="alert" style="display:none;"></div>

            <div class="actions">
                <a class="link" href="<%=request.getContextPath()%>/auth/login">이미 계정이 있어요</a>
                <button class="btn" type="submit">가입하기</button>
            </div>

            <p class="mini">
                가입하면 서비스 이용약관 및 개인정보 처리방침에 동의한 것으로 간주됩니다.
            </p>
        </form>

        <script>
            function validateForm(){
                const pw = document.getElementById('password').value;
                const pw2 = document.getElementById('password2').value;
                const msg = document.getElementById('msg');

                msg.style.display = 'none';
                msg.textContent = '';

                if(pw !== pw2){
                    msg.textContent = '비밀번호 확인이 일치하지 않습니다.';
                    msg.style.display = 'block';
                    return false;
                }
                if(pw.length < 6){
                    msg.textContent = '비밀번호는 최소 6자 이상이어야 합니다.';
                    msg.style.display = 'block';
                    return false;
                }
                return true;
            }
        </script>

    </section>

</div>
</body>
</html>
