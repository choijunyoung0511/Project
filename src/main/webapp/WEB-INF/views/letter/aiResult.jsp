<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>AI 편지 결과</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/letter.css">

    <style>
        /* ✅ 저장 로딩 오버레이 */
        .save-loading-overlay{
            display:none;
            position:fixed;
            inset:0;
            background:rgba(0,0,0,.45);
            z-index:9999;
            align-items:center;
            justify-content:center;
        }
        .save-loading-overlay.on{ display:flex; }
        .save-loading-box{
            width:min(420px, 92vw);
            background:#ffffff;
            border-radius:16px;
            padding:20px 18px;
            box-shadow:0 18px 60px rgba(0,0,0,.25);
            text-align:center;
        }
        .save-spinner{
            width:52px; height:52px;
            margin:4px auto 12px;
            border-radius:50%;
            border:6px solid rgba(0,0,0,.12);
            border-top-color: rgba(0,0,0,.55);
            animation: saveSpin .9s linear infinite;
        }
        @keyframes saveSpin { to { transform:rotate(360deg); } }
        .save-title{ margin:0; font-size:16px; font-weight:700; }
        .save-desc{ margin:6px 0 0; font-size:13px; color:#666; line-height:1.35; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<!-- ✅ 저장 로딩 오버레이 -->
<div class="save-loading-overlay" id="saveLoading" aria-hidden="true">
    <div class="save-loading-box" role="dialog" aria-modal="true" aria-label="저장 로딩">
        <div class="save-spinner" aria-hidden="true"></div>
        <p class="save-title">저장 중이에요…</p>
        <p class="save-desc">잠시만 기다려 주세요.</p>
    </div>
</div>

<div class="container">
    <h2 class="page-title">AI 편지 결과 (수정 후 저장)</h2>

    <!-- ✅ AI 생성 에러 메시지 -->
    <c:if test="${not empty errorMsg}">
        <div class="alert error" style="margin-bottom:12px;">
                ${errorMsg}
        </div>
    </c:if>

    <form id="saveForm"
          method="post"
          action="${pageContext.request.contextPath}/letter/ai/save"
          class="card">

        <!-- 이전 선택값 유지 -->
        <input type="hidden" name="tag" value="${tag}" />
        <input type="hidden" name="isPublic" value="${isPublic}" />
        <input type="hidden" name="paperType" value="${paperType}" />
        <input type="hidden" name="writingStyle" value="${writingStyle}" />
        <input type="hidden" name="aiPrompt" value="${aiPrompt}" />

        <div style="margin-bottom:12px;">
            <span class="badge">${paperType}</span>
            <span class="badge">${writingStyle}</span>
            <span class="badge ai">AI</span>
        </div>

        <label>내용(수정 가능)</label>
        <textarea name="content" rows="14" required>${generatedContent}</textarea>

        <div style="display:flex; gap:10px; margin-top:12px;">
            <button id="btnSave" type="submit" class="btn primary">저장하기</button>
            <a class="btn" href="${pageContext.request.contextPath}/letter/ai">다시 만들기</a>
        </div>
    </form>
</div>

<script>
    (function(){
        const form = document.getElementById('saveForm');
        const overlay = document.getElementById('saveLoading');
        const btn = document.getElementById('btnSave');

        let submitting = false;

        function setLoading(on){
            overlay.classList.toggle('on', on);
            overlay.setAttribute('aria-hidden', on ? 'false' : 'true');
            btn.disabled = on;
            btn.textContent = on ? '저장 중...' : '저장하기';
        }

        form.addEventListener('submit', (e) => {
            if (submitting) {
                e.preventDefault();
                return;
            }
            submitting = true;
            setLoading(true);

            // 안전장치
            setTimeout(() => {
                if (document.body.contains(overlay)) {
                    submitting = false;
                    setLoading(false);
                }
            }, 120000);
        });

        // 뒤로가기 복귀 시 로딩 해제
        window.addEventListener('pageshow', () => {
            submitting = false;
            setLoading(false);
        });
    })();
</script>
</body>
</html>
