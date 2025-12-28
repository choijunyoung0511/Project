<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>회원가입 | ReadingLetter</title>

    <!-- ✅ 공용(base) 먼저 -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/base.css">
    <!-- ✅ 회원가입 전용 -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/auth/auth.css">
</head>

<!-- ✅ 로그인/회원가입만 다크 -->
<body class="theme-dark">

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

        <h1 class="brand-title">오늘의 기록이, 내일의 편지가 돼요</h1>
        <p class="brand-sub">
            1분이면 가입 끝. <br/>
            독후감을 AI 편지로 바꾸고, 리마인드로 미래의 나에게 보내봐요.
        </p>

        <ul class="feature-list">
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>AI 편지 만들기</b>
                    <span>원하는 스타일/톤으로 독후감을 편지로 변환</span>
                </div>
            </li>
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>내 기록 관리</b>
                    <span>읽은 책·세션·편지를 한 페이지에서</span>
                </div>
            </li>
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>공개/비공개 선택</b>
                    <span>커뮤니티 공유 또는 나만 보기</span>
                </div>
            </li>
        </ul>

        <p class="mini">
            이미 계정이 있다면 로그인으로 돌아가세요.
        </p>
    </section>

    <!-- Right: Form -->
    <section class="form-card" aria-label="회원가입 폼">
        <div class="card-top">
            <div>
                <h2>회원가입</h2>
                <p>계정을 만들어 독서 편지를 시작해보자.</p>
            </div>
            <span class="badge">Create Account</span>
        </div>

        <!-- ✅ 컨트롤러에서 model.addAttribute("error", "...")를 내려주면 이거로 출력 -->
        <%
            Object errorObj = request.getAttribute("error");
            String errorMsg = (errorObj != null) ? String.valueOf(errorObj) : null;
        %>
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div class="alert"><%= errorMsg %></div>
        <% } %>

        <form method="post" action="<%=request.getContextPath()%>/auth/signup" autocomplete="on">

            <div class="field">
                <label for="email">이메일</label>
                <input class="input" id="email" name="email" type="email" placeholder="example@domain.com" required />
            </div>

            <div class="field">
                <label for="nickname">닉네임</label>
                <input class="input" id="nickname" name="nickname" type="text" placeholder="닉네임" required />
            </div>

            <div class="field">
                <label for="password">비밀번호</label>
                <input class="input" id="password" name="password" type="password" placeholder="••••••••" required />
            </div>

            <div class="actions">
                <button class="btn" type="submit">회원가입</button>
            </div>

            <p class="mini">
                이미 계정이 있나요?
                <a class="link" href="<%=request.getContextPath()%>/auth/login">로그인</a>
            </p>

        </form>
    </section>

</div>

</body>
</html>
