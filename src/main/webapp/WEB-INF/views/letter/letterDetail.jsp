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
</head>
<body>

<div class="container">
    <h2 class="page-title">편지 상세</h2>

    <div class="card">
        <!-- 제목: tag가 있으면 tag, 없으면 "내 편지" -->
        <h3>
            <c:choose>
                <c:when test="${not empty letter.tag}">${letter.tag}</c:when>
                <c:otherwise>내 편지</c:otherwise>
            </c:choose>
        </h3>

        <!-- 메타 정보 -->
        <p class="muted">
            ${letter.createdAt}
            · &#10084; ${letter.likeCount}
            · 조회수 ${letter.viewCount}
            ·
            <c:choose>
                <c:when test="${letter.isPublic == 1}">공개</c:when>
                <c:otherwise>비공개</c:otherwise>
            </c:choose>
        </p>

        <hr style="border:0;border-top:1px solid rgba(35,49,74,.85); margin:14px 0;">

        <!-- 본문 -->
        <p style="line-height:1.8; white-space:pre-line;">
            ${letter.content}
        </p>

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
