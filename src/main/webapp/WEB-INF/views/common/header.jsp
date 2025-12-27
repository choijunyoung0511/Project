<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* ✅ 상단바는 화면 전체 폭 */
    .rl-topbar {
        position: sticky;
        top: 0;
        z-index: 999;
        width: 100%;
        background: rgba(255,255,255,0.92);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid #e5e7eb;
    }

    /* ✅ 상단바 안쪽 콘텐츠만 가운데 정렬 + 최대폭 */
    .rl-topbar-inner {
        max-width: 1280px;
        margin: 0 auto;
        padding: 14px 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 14px;
    }

    .rl-brand {
        display: flex;
        align-items: center;
        gap: 12px;
        text-decoration: none;
        color: inherit;
        min-width: 0;
    }

    .rl-logo {
        width: 40px; height: 40px;
        border-radius: 14px;
        display:flex; align-items:center; justify-content:center;
        background: linear-gradient(135deg, #111827, #334155);
        color: #fff;
        font-weight: 900;
        flex: 0 0 auto;
    }

    .rl-brand-text { min-width:0; }
    .rl-title { margin:0; font-size: 15px; font-weight: 900; line-height: 1.1; }
    .rl-sub { margin:0; font-size: 12px; color:#6b7280; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

    .rl-nav {
        display:flex;
        align-items:center;
        gap: 10px;
        flex-wrap: wrap;
        justify-content: flex-end;
    }

    .rl-pill {
        display:inline-flex; align-items:center; gap:8px;
        padding: 8px 12px;
        border-radius: 999px;
        background: #f3f4f6;
        border: 1px solid #e5e7eb;
        font-size: 13px;
        font-weight: 700;
    }
    .rl-dot { width:8px; height:8px; border-radius:999px; background:#22c55e; }

    .rl-btn {
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding: 9px 14px;
        border-radius: 12px;
        border: 1px solid #e5e7eb;
        background: #fff;
        text-decoration:none;
        color:#111827;
        font-weight: 800;
        font-size: 13px;
        transition: .15s;
    }
    .rl-btn:hover { transform: translateY(-1px); background:#f9fafb; }

    .rl-primary { background:#111827; border-color:#111827; color:#fff; }
    .rl-primary:hover { background:#0b1220; }

    .rl-danger { border-color:#fecaca; color:#b91c1c; background:#fff; }
    .rl-danger:hover { background:#fff5f5; }

    /* 모바일에서는 메뉴 줄이기 */
    @media (max-width: 720px) {
        .rl-topbar-inner { padding: 12px 14px; }
        .rl-sub { display:none; }
        .rl-btn { padding: 8px 10px; border-radius: 10px; }
    }
</style>

<div class="rl-topbar">
    <div class="rl-topbar-inner">

        <a class="rl-brand" href="${pageContext.request.contextPath}/">
            <div class="rl-logo">RL</div>
            <div class="rl-brand-text">
                <p class="rl-title">ReadingLetter</p>
                <p class="rl-sub">AI 독후감(편지) + 리마인드</p>
            </div>
        </a>

        <div class="rl-nav">
            <c:choose>
                <c:when test="${not empty user}">
          <span class="rl-pill">
            <span class="rl-dot"></span>
            <span>${user.nickname}</span>
          </span>

                    <a class="rl-btn" href="${pageContext.request.contextPath}/letter/list">내 편지함</a>
                    <a class="rl-btn" href="${pageContext.request.contextPath}/books">내 책장</a>
                    <a class="rl-btn" href="${pageContext.request.contextPath}/timer">타이머</a>
                    <a class="rl-btn" href="${pageContext.request.contextPath}/ranking">TOP 5</a>

                    <a class="rl-btn rl-primary" href="${pageContext.request.contextPath}/letters/new">AI 편지 만들기</a>
                    <a class="rl-btn rl-danger" href="${pageContext.request.contextPath}/auth/logout">로그아웃</a>
                </c:when>

                <c:otherwise>
                    <a class="rl-btn rl-primary" href="${pageContext.request.contextPath}/auth/login">로그인</a>
                    <a class="rl-btn" href="${pageContext.request.contextPath}/auth/signup">회원가입</a>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>
