<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- 공용 + 레이아웃 + 편지함 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/letter.css">

    <title>편지 상세</title>

    <style>
        /* ✅ 상세페이지에서 카드가 너무 어두우면 종이색이 죽어서,
           종이 미리보기 느낌을 살리기 위해 card를 투명하게 */
        .letter-detail-card{
            background: transparent !important;
            border: none !important;
            box-shadow: none !important;
            padding: 0 !important;
        }
        .detail-meta{
            margin: 10px 0 0;
            font-size: 13px;
            opacity: .85;
        }
        .detail-divider{
            border:0;
            border-top:1px solid rgba(35,49,74,.35);
            margin:14px 0;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="container">
    <h2 class="page-title">편지 상세</h2>

    <div class="card letter-detail-card">

        <!-- ✅ 미리보기와 동일한 종이 박스 -->
        <div class="paper-preview-wrap">
            <div class="paper-preview paper-lined paper-${letter.paperType}">
                <div class="paper-head">
                    <!-- 제목: tag가 있으면 tag, 없으면 "내 편지" -->
                    <div class="paper-title" id="previewTagTitle">
                        <c:choose>
                            <c:when test="${not empty letter.tag}">${letter.tag}</c:when>
                            <c:otherwise>내 편지</c:otherwise>
                        </c:choose>
                    </div>

                    <!-- ✅ 뱃지들 -->
                    <div style="display:flex; gap:8px; flex-wrap:wrap;">
                        <c:if test="${not empty letter.paperType}">
                            <span class="badge" id="badgePaper">${letter.paperType}</span>
                        </c:if>
                        <c:if test="${not empty letter.writingStyle}">
                            <span class="badge">${letter.writingStyle}</span>
                        </c:if>
                    </div>
                </div>

                <!-- ✅ 메타 정보(미리보기 안에 넣어서 통일) -->
                <p class="muted detail-meta">
                    ${letter.createdAt}
                    · &#10084; ${letter.likeCount}
                    · 조회수 ${letter.viewCount}
                    ·
                    <c:choose>
                        <c:when test="${letter.isPublic == 1}">공개</c:when>
                        <c:otherwise>비공개</c:otherwise>
                    </c:choose>
                </p>

                <hr class="detail-divider">

                <!-- ✅ 본문: pre로 출력해야 미리보기랑 동일하게 줄바꿈 유지 -->
                <pre class="paper-content" id="previewText">${letter.content}</pre>
            </div>
        </div>

        <div style="margin-top:16px;">
            <a class="btn"
               href="${pageContext.request.contextPath}/letter/list?scope=${scope}">
                목록
            </a>
        </div>

    </div>
</div>

</body>
</html>
