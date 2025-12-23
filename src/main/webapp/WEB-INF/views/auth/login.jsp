<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String err = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>로그인 | ReadingLetter</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/auth/auth.css">

    <style>
        /* JSP에서 WEB-INF 내부는 브라우저가 직접 접근 못함.
           아래 주석 참고하고, 실제 배포는 /static 으로 옮기는 걸 추천! */
    </style>
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

        <h1 class="brand-title">독서가 ‘기억’이 되는 곳</h1>
        <p class="brand-sub">
            책을 읽고, 기록하고, AI가 만든 편지를 미래의 나에게 보내요. <br/>
            이번 주 가장 공감받은 독후감 TOP 5도 확인할 수 있어요.
        </p>

        <ul class="feature-list">
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>AI 독후감(편지) 생성</b>
                    <span>#미래의나에게 #위로 #동기부여 같은 태그로 톤을 선택</span>
                </div>
            </li>
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>읽기 기록 & 대시보드</b>
                    <span>타이머로 독서 세션을 저장하고 내 기록을 한눈에</span>
                </div>
            </li>
            <li class="feature">
                <span class="dot"></span>
                <div>
                    <b>커뮤니티 & 랭킹</b>
                    <span>좋아요·조회 기반으로 ‘이번 주 TOP 5’ 노출</span>
                </div>
            </li>
        </ul>

        <p class="mini">
            테스트: 로그인 성공하면 세션에 <code>SS_USER_ID</code>, <code>SS_NICKNAME</code> 저장
        </p>
    </section>

    <!-- Right: Form -->
    <section class="form-card" aria-label="로그인 폼">
        <div class="card-top">
            <div>
                <h2>로그인</h2>
                <p>계정으로 접속해서 편지를 만들고 저장해보자.</p>
            </div>
            <span class="badge">Session Login</span>
        </div>

        <% if ("1".equals(err)) { %>
        <div class="alert">이메일 또는 비밀번호가 올바르지 않습니다.</div>
        <% } %>

        <form method="post" action="<%=request.getContextPath()%>/auth/login" autocomplete="on">
            <div class="field">
                <label for="email">이메일</label>
                <input class="input" id="email" name="email" type="email" placeholder="example@domain.com" required />
            </div>

            <div class="field">
                <label for="password">비밀번호</label>
                <input class="input" id="password" name="password" type="password" placeholder="••••••••" required />
            </div>

            <div class="actions">
                <div class="helper">
                    <input class="chk" id="remember" type="checkbox" />
                    <label for="remember" style="margin:0;">기억하기(브라우저)</label>
                </div>

                <button class="btn" type="submit">로그인</button>
            </div>

            <p class="mini">
                아직 계정이 없나요?
                <a class="link" href="<%=request.getContextPath()%>/auth/signup">회원가입</a>
            </p>
        </form>
    </section>

</div>

<!-- NOTE:
  WEB-INF 경로의 CSS는 직접 링크가 안 먹을 수 있어.
  가장 깔끔한 방법:
  1) auth.css 를 src/main/resources/static/auth/auth.css 로 옮기고
  2) <link rel="stylesheet" href="/auth/auth.css"> 로 바꿔.
-->
</body>
</html>
