<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // ✅ JSP EL에서는 '\n' 같은 이스케이프 사용 불가 → 변수로 만들어서 치환
    pageContext.setAttribute("LF", "\n");
    pageContext.setAttribute("CR", "\r");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- 공용 + 레이아웃 + 편지함 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/letter.css">

    <title>내 편지함</title>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>


<div class="container">

    <%-- ✅ scope가 안 넘어오면 기본 all로 --%>
    <c:set var="scope" value="${empty scope ? 'all' : scope}" />

    <h2 class="page-title">내 편지함</h2>

    <!-- ✅ 탭: 전체 / 공개 / 비공개 -->
    <div class="tab-group">
        <a class="tab ${scope eq 'all' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/letter/list?scope=all">전체</a>

        <a class="tab ${scope eq 'public' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/letter/list?scope=public">공개</a>

        <a class="tab ${scope eq 'private' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/letter/list?scope=private">비공개</a>
    </div>

    <!-- ✅ 리스트 -->
    <div class="letter-list">
        <c:choose>
            <c:when test="${empty letters}">
                <div class="empty-state">
                    아직 작성한 편지가 없어요.
                </div>
            </c:when>

            <c:otherwise>
                <c:forEach var="l" items="${letters}">
                    <a class="letter-card"
                       href="${pageContext.request.contextPath}/letter/detail/${l.id}?scope=${scope}">

                        <!-- ✅ tag를 제목처럼 -->
                        <h4>
                            <c:choose>
                                <c:when test="${not empty l.tag}">
                                    <c:out value="${l.tag}" />
                                </c:when>
                                <c:otherwise>내 편지</c:otherwise>
                            </c:choose>
                        </h4>

                        <!-- ✅ content 미리보기 (개행 제거) -->
                        <c:set var="preview"
                               value="${empty l.content ? ''
                                       : fn:replace(fn:replace(l.content, CR, ' '), LF, ' ')}" />

                        <p>
                            <c:choose>
                                <c:when test="${fn:length(preview) > 30}">
                                    <c:out value="${fn:substring(preview, 0, 30)}" />...
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${preview}" />
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="meta">
                                <%-- ✅ createdAt이 LocalDateTime이라 fmt:formatDate 사용하면 500남
                                     LocalDateTime 문자열(2025-12-27T22:11:17)에서 날짜만 잘라서 출력 --%>
                            <span>
                                <c:choose>
                                    <c:when test="${not empty l.createdAt}">
                                        <c:out value="${fn:replace(fn:substring(l.createdAt, 0, 10), '-', '.')}" />
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </span>

                            <span>&#10084; <c:out value="${l.likeCount}" /></span>
                        </div>

                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</div>

</body>
</html>
