<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>AI 편지 만들기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/letter.css">

    <style>
        /* ✅ 로딩 오버레이 */
        .ai-loading-overlay{
            display:none;
            position:fixed;
            inset:0;
            background:rgba(0,0,0,.45);
            z-index:9999;
            align-items:center;
            justify-content:center;
        }
        .ai-loading-overlay.on{ display:flex; }

        .ai-loading-box{
            width:min(420px, 92vw);
            background:#ffffff;
            border-radius:16px;
            padding:20px 18px;
            box-shadow:0 18px 60px rgba(0,0,0,.25);
            text-align:center;
        }
        .ai-spinner{
            width:52px;
            height:52px;
            margin:4px auto 12px;
            border-radius:50%;
            border:6px solid rgba(0,0,0,.12);
            border-top-color: rgba(0,0,0,.55);
            animation: aiSpin .9s linear infinite;
        }
        @keyframes aiSpin { to { transform:rotate(360deg); } }

        .ai-loading-title{
            margin:0;
            font-size:16px;
            font-weight:700;
        }
        .ai-loading-desc{
            margin:6px 0 0;
            font-size:13px;
            color:#666;
            line-height:1.35;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<!-- ✅ 로딩 오버레이 -->
<div class="ai-loading-overlay" id="aiLoading" aria-hidden="true">
    <div class="ai-loading-box" role="dialog" aria-modal="true" aria-label="AI 생성 로딩">
        <div class="ai-spinner" aria-hidden="true"></div>
        <p class="ai-loading-title">AI가 편지를 작성 중이에요…</p>
        <p class="ai-loading-desc">
            잠시만 기다려 주세요.<br/>
            생성이 끝나면 결과 화면으로 이동합니다.
        </p>
    </div>
</div>

<div class="container">
    <h2 class="page-title">AI 편지 만들기</h2>

    <form id="aiForm"
          method="post"
          action="${pageContext.request.contextPath}/letter/ai/generate"
          class="card">

        <label>제목(태그)</label>
        <input type="text" name="tag" maxlength="50" placeholder="예: 비공개 테스트" required />

        <label>공개 여부</label>
        <select name="isPublic">
            <option value="0">비공개</option>
            <option value="1">공개</option>
        </select>

        <label>편지지 선택</label>
        <select name="paperType">
            <option value="BASIC">BASIC (기본)</option>
            <option value="VINTAGE">VINTAGE (감성)</option>
            <option value="PASTEL">PASTEL (파스텔)</option>
            <option value="MINIMAL">MINIMAL (미니멀)</option>
        </select>

        <label>편지 문체(스타일)</label>
        <select name="writingStyle">
            <option value="CASUAL">CASUAL (친근)</option>
            <option value="FORMAL">FORMAL (정중)</option>
            <option value="EMOTIONAL">EMOTIONAL (감성)</option>
            <option value="SHORT">SHORT (짧게)</option>
            <option value="LONG">LONG (길게)</option>
        </select>

        <label>상황/요청(프롬프트)</label>
        <textarea name="prompt" rows="8"
                  placeholder="예: 친구에게 위로 편지를 쓰고 싶어. 최근 힘든 일이 있었어..."
                  required></textarea>

        <button id="btnGenerate" type="submit" class="btn primary">AI로 작성하기</button>
    </form>
</div>

<script>
    (function(){
        const form = document.getElementById('aiForm');
        const overlay = document.getElementById('aiLoading');
        const btn = document.getElementById('btnGenerate');

        let submitting = false;

        function setLoading(on){
            overlay.classList.toggle('on', on);
            overlay.setAttribute('aria-hidden', on ? 'false' : 'true');
            btn.disabled = on;
            btn.textContent = on ? '생성 중...' : 'AI로 작성하기';
        }

        form.addEventListener('submit', (e) => {
            if (submitting) {
                e.preventDefault();
                return;
            }

            // ✅ 기본 required 검증 통과 후 로딩 ON
            // (브라우저가 required 체크를 하고 submit이 들어옴)
            submitting = true;
            setLoading(true);

            // ✅ 혹시 서버가 에러나서 뒤로가기/이탈할 때 대비: 2분 후 자동 해제(안전장치)
            setTimeout(() => {
                // 페이지 이동이 안 되었을 때만 해제
                if (document.body.contains(overlay)) {
                    submitting = false;
                    setLoading(false);
                }
            }, 120000);
        });

        // ✅ 뒤로가기(bfcache)로 돌아왔을 때 로딩 남아있으면 끄기
        window.addEventListener('pageshow', () => {
            submitting = false;
            setLoading(false);
        });
    })();
</script>
</body>
</html>
