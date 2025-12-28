<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ReadingLetter - Home</title>


    <style>
        html, body { margin:0; padding:0; }
        body { background:#f3f4f6; }

        /* ✅ 본문만 중앙정렬 + 여백 */
        .container{
            max-width: 1280px;
            margin: 0 auto;
            padding: 100px 24px;   /* 위아래 16, 좌우 24 */
        }

        .grid { display:grid; grid-template-columns: 1.2fr 1fr; gap: 16px; margin-top: 16px; }
        @media (max-width: 820px) { .grid { grid-template-columns: 1fr; } }

        .card {
            background: #fff; border: 1px solid #e5e7eb;
            border-radius: 16px; padding: 18px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.05);
        }
        .card h2 { margin:0 0 10px; font-size: 16px; }
        .muted { color:#6b7280; font-size: 13px; margin:0; }

        .actions { display:flex; flex-wrap:wrap; gap:10px; margin-top:14px; }
        .btn {
            display:inline-flex; align-items:center; justify-content:center;
            padding: 10px 14px; border-radius: 12px;
            border: 1px solid #e5e7eb; background:#f9fafb;
            text-decoration:none; color:#111827; font-weight:600;
            transition: .15s;
        }
        .btn:hover { transform: translateY(-1px); background:#fff; }
        .btn.primary { background:#111827; border-color:#111827; color:#fff; }
        .btn.primary:hover { background:#0b1220; }

        .kpi { display:grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 14px; }
        .kpi .box { background:#f8fafc; border:1px solid #e5e7eb; border-radius: 14px; padding: 12px; }
        .kpi .num { font-size: 18px; font-weight: 800; margin:0; }
        .kpi .label { font-size: 12px; color:#6b7280; margin: 2px 0 0; }

        .list { margin-top: 12px; display:flex; flex-direction:column; gap:10px; }
        .item {
            border:1px solid #e5e7eb; border-radius: 14px;
            padding: 12px; display:flex; justify-content:space-between; gap: 10px;
            background:#fff;
        }
        .item strong { display:block; font-size: 14px; }
        .item span { color:#6b7280; font-size: 12px; }
        .pill {
            font-size: 12px; padding: 6px 10px; border-radius: 999px;
            background:#eef2ff; color:#3730a3; border:1px solid #e0e7ff;
            height: fit-content;
        }

        .footer { margin-top: 18px; color:#9ca3af; font-size: 12px; text-align:center; }
    </style>
</head>

<body>

<!-- ✅ 헤더는 화면 최상단(풀폭) -->
<jsp:include page="common/header.jsp" />

<!-- ✅ 본문만 container로 중앙정렬 -->
<div class="container">
    <c:choose>

        <%-- 로그인 상태 --%>
        <c:when test="${not empty user}">
            <div class="grid">
                <div class="card">
                    <h2>안녕하세요, <b>${user.nickname}</b> 님 👋</h2>
                    <p class="muted">오늘도 한 문장 남기고, 미래의 나에게 보내볼까요?</p>

                    <div class="actions">
                        <a class="btn primary" href="${pageContext.request.contextPath}/letter/ai">✍️ AI 편지 만들기</a>
                        <a class="btn" href="${pageContext.request.contextPath}/books">📚 내 책장</a>
                        <a class="btn" href="${pageContext.request.contextPath}/timer">⏱️ 타이머</a>
                        <a class="btn" href="${pageContext.request.contextPath}/ranking">🏆 TOP 5</a>
                    </div>

                    <div class="kpi">
                        <div class="box">
                            <p class="num">${empty stats ? 0 : stats.letterCount}</p>
                            <p class="label">총 작성</p>
                        </div>
                        <div class="box">
                            <p class="num">${empty stats ? 0 : stats.readMinutesWeek}</p>
                            <p class="label">이번 주 읽기(분)</p>
                        </div>
                        <div class="box">
                            <p class="num">${empty stats ? 0 : stats.likeCount}</p>
                            <p class="label">받은 좋아요</p>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h2>다가오는 리마인드</h2>
                    <p class="muted">다음 발송 예정 편지들</p>

                    <div class="list">
                        <div class="item">
                            <div>
                                <strong>『아토믹 해빗』 - #미래의나에게</strong>
                                <span>발송: 2026-01-07 (수) 09:00</span>
                            </div>
                            <div class="pill">예약</div>
                        </div>

                        <div class="item">
                            <div>
                                <strong>『데미안』 - #회고</strong>
                                <span>발송: 2026-01-10 (토) 21:00</span>
                            </div>
                            <div class="pill">예약</div>
                        </div>
                    </div>

                    <div class="actions" style="margin-top:12px;">
                        <a class="btn" href="${pageContext.request.contextPath}/letter/list">📩 내 편지함</a>
                        <a class="btn" href="${pageContext.request.contextPath}/recommend">🤖 AI 추천</a>
                    </div>
                </div>
            </div>

            <div class="footer">© ReadingLetter · 세션 로그인 기반</div>
        </c:when>

        <%-- 비로그인 상태 --%>
        <c:otherwise>
            <div class="card" style="margin-top:16px;">
                <h2>로그인이 필요합니다</h2>
                <p class="muted">AI 편지 생성과 리마인드 기능은 로그인 후 사용할 수 있어요.</p>
                <div class="actions">
                    <a class="btn primary" href="${pageContext.request.contextPath}/auth/login">로그인</a>
                    <a class="btn" href="${pageContext.request.contextPath}/auth/signup">회원가입</a>
                </div>
            </div>

            <div class="footer">© ReadingLetter</div>
        </c:otherwise>

    </c:choose>
</div>

</body>
</html>
