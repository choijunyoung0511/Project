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
        :root{
            --paper-radius: 18px;
            --paper-shadow: 0 18px 60px rgba(0,0,0,.12);
            --paper-line: rgba(16,24,40,.12);
            --paper-text: #121926;
            --paper-muted: rgba(18,25,38,.70);
            --paper-border: rgba(16,24,40,.14);
            --paper-gap: 26px;
            --paper-pad: 18px;
            --paper-font: ui-serif, "Noto Serif KR", "NanumMyeongjo", "Apple SD Gothic Neo", system-ui, sans-serif;
        }

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

        /* ✅ 폼 내 2열 레이아웃 */
        .grid-2{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap:12px;
        }
        @media (max-width: 860px){
            .grid-2{ grid-template-columns: 1fr; }
        }
        .field label{ display:block; margin-bottom:6px; font-weight:800; font-size:13px; letter-spacing:-.2px; }
        .field select,
        .field input{
            width:100%;
            padding:11px 12px;
            border-radius:12px;
            border:1px solid rgba(0,0,0,.14);
            outline:none;
            background:linear-gradient(180deg,#fff,#f7f8fb);
            box-shadow:0 10px 22px rgba(0,0,0,.06);
        }

        .page-title{ letter-spacing:-.4px; }

        /* =========================
           🧾 미리보기/편집 공통
        ========================== */
        .paper-preview-wrap{ margin-top:14px; }
        .paper-preview-label{
            font-weight:900;
            margin:0 0 10px;
            font-size:14px;
            letter-spacing:-.2px;
        }

        .paper-preview{
            position:relative;
            overflow:hidden;
            border-radius: var(--paper-radius);
            padding: calc(var(--paper-pad) + 14px) var(--paper-pad) var(--paper-pad);
            border:1px solid var(--paper-border);
            box-shadow: var(--paper-shadow);
            color: var(--paper-text);
        }
        .paper-preview::before{
            content:"";
            position:absolute;
            inset:0;
            pointer-events:none;
            opacity:.30;
            background:
                    radial-gradient(900px 340px at 20% 8%, rgba(255,255,255,.75), transparent 60%),
                    radial-gradient(600px 280px at 90% 10%, rgba(255,255,255,.55), transparent 55%),
                    radial-gradient(520px 260px at 10% 90%, rgba(0,0,0,.05), transparent 60%),
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.8' numOctaves='2' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='120' height='120' filter='url(%23n)' opacity='.18'/%3E%3C/svg%3E");
            mix-blend-mode: multiply;
        }
        .paper-preview::after{
            content:"";
            position:absolute;
            inset:14px;
            border-radius: calc(var(--paper-radius) - 12px);
            pointer-events:none;
            border: 2px solid rgba(255,255,255,.60);
            box-shadow: inset 0 0 0 1px rgba(0,0,0,.06), 0 0 0 1px rgba(0,0,0,.06);
            opacity:.95;
        }

        .paper-head{
            position:relative;
            display:flex;
            align-items:flex-start;
            justify-content:space-between;
            margin-bottom:10px;
            gap:12px;
            flex-wrap:wrap;
            z-index:1;
        }
        .paper-title{
            font-weight:900;
            font-size:14px;
            letter-spacing:-.3px;
            color: var(--paper-text);
        }
        .paper-content{
            position:relative;
            margin:0;
            white-space:pre-wrap;
            font-family: var(--paper-font);
            font-size: 15px;
            line-height: 1.95;
            z-index:1;
            color: var(--paper-text);
        }

        .paper-lined{
            background:
                    repeating-linear-gradient(
                            to bottom,
                            transparent 0px,
                            transparent calc(var(--paper-gap) - 1px),
                            var(--paper-line) calc(var(--paper-gap) - 1px),
                            var(--paper-line) var(--paper-gap)
                    );
            background-attachment: local;
        }

        .badge{
            border:1px solid rgba(0,0,0,.10);
            background:rgba(255,255,255,.65);
            backdrop-filter: blur(6px);
        }

        /* ✅ textarea는 투명 유지(편집 박스 배경을 그대로 보이게) */
        textarea#contentArea{
            border: none !important;
            background: transparent !important;
            box-shadow: none !important;
            padding: 0 !important;
            outline: none !important;
            width: 100%;
            min-height: 280px;
            resize: vertical;
            font: inherit;
            color: inherit;
            line-height: inherit;
        }

        .paper-editor-shell{
            margin-top: 6px;
            border:1px solid rgba(0,0,0,.12);
            border-radius: var(--paper-radius);
            box-shadow: var(--paper-shadow);
            padding: calc(var(--paper-pad) + 18px) var(--paper-pad) var(--paper-pad);
        }

        /* ======================================
           🌈 THEMES
        ====================================== */

        .paper-BASIC{
            background:
                    radial-gradient(900px 420px at 12% 10%, rgba(147,197,253,.28), transparent 62%),
                    radial-gradient(760px 380px at 90% 18%, rgba(196,181,253,.20), transparent 60%),
                    linear-gradient(180deg,#ffffff,#fbfbff);
        }
        .paper-MINIMAL{
            background:
                    radial-gradient(820px 420px at 18% 8%, rgba(99,102,241,.18), transparent 62%),
                    radial-gradient(760px 380px at 88% 18%, rgba(16,185,129,.12), transparent 60%),
                    linear-gradient(180deg,#f8fafc,#f2f4f8);
        }
        .paper-PASTEL{
            background:
                    radial-gradient(900px 420px at 15% 10%, rgba(147,197,253,.22), transparent 60%),
                    radial-gradient(700px 360px at 90% 18%, rgba(253,164,175,.22), transparent 55%),
                    linear-gradient(180deg,#f6fbff,#fff6fb);
        }
        .paper-VINTAGE{
            background:
                    radial-gradient(900px 420px at 15% 5%, rgba(120,80,30,.16), transparent 60%),
                    radial-gradient(700px 340px at 90% 20%, rgba(200,150,80,.14), transparent 55%),
                    linear-gradient(180deg,#fbf2df,#f6e8c9);
        }
        .paper-DARK{
            --paper-text:#f8fafc;
            --paper-border: rgba(255,255,255,.16);
            --paper-line: rgba(255,255,255,.10);
            background:
                    radial-gradient(900px 420px at 12% 10%, rgba(99,102,241,.22), transparent 62%),
                    radial-gradient(760px 380px at 90% 18%, rgba(16,185,129,.16), transparent 60%),
                    linear-gradient(180deg,#0b1220,#0f172a);
        }
        .paper-DARK .badge{ background: rgba(0,0,0,.35); border-color: rgba(255,255,255,.12); color:#f8fafc; }

        .paper-SPRING{ background: radial-gradient(900px 420px at 12% 10%, rgba(253,164,175,.34), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(52,211,153,.18), transparent 60%), linear-gradient(180deg,#fff,#fff7fb); }
        .paper-SUMMER{ background: radial-gradient(900px 420px at 12% 10%, rgba(147,197,253,.38), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(59,130,246,.20), transparent 60%), linear-gradient(180deg,#ffffff,#f1fbff); }
        .paper-AUTUMN{ background: radial-gradient(900px 420px at 12% 10%, rgba(245,158,11,.28), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(234,88,12,.18), transparent 60%), linear-gradient(180deg,#fff6e7,#f8e6c8); }
        .paper-WINTER{ background: radial-gradient(900px 420px at 12% 10%, rgba(219,234,254,.55), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(165,243,252,.20), transparent 60%), linear-gradient(180deg,#ffffff,#f3f7ff); }

        .paper-CHRISTMAS{ background: radial-gradient(900px 420px at 12% 10%, rgba(34,197,94,.22), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(239,68,68,.18), transparent 60%), linear-gradient(180deg,#fff,#fff6f6); }
        .paper-NEWYEAR{ background: radial-gradient(900px 420px at 12% 10%, rgba(250,204,21,.26), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(99,102,241,.18), transparent 60%), linear-gradient(180deg,#ffffff,#fbfbff); }
        .paper-BIRTHDAY{ background: radial-gradient(900px 420px at 12% 10%, rgba(253,164,175,.30), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(147,197,253,.22), transparent 60%), linear-gradient(180deg,#fff,#fff7fb); }
        .paper-ANNIVERSARY{ background: radial-gradient(900px 420px at 12% 10%, rgba(251,113,133,.22), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(167,139,250,.18), transparent 60%), linear-gradient(180deg,#ffffff,#fff7fb); }
        .paper-GRADUATION{ background: radial-gradient(900px 420px at 12% 10%, rgba(96,165,250,.22), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(250,204,21,.14), transparent 60%), linear-gradient(180deg,#ffffff,#f5f7ff); }
        .paper-THANKYOU{ background: radial-gradient(900px 420px at 12% 10%, rgba(34,197,94,.16), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(59,130,246,.12), transparent 60%), linear-gradient(180deg,#ffffff,#f3fff8); }

        .paper-NOTE{ background: linear-gradient(180deg,#ffffff,#fbfbff); }
        .paper-GRID{ background: linear-gradient(180deg,#ffffff,#f7fbff); }
        .paper-MEMO{ background: linear-gradient(180deg,#fffdf7,#fff8f0); }
        .paper-DIARY{ background: linear-gradient(180deg,#ffffff,#f8fafc); }
        .paper-LETTERPAD{ background: linear-gradient(180deg,#ffffff,#fbfbfd); }

        .paper-CRAFT{ background: radial-gradient(900px 420px at 12% 10%, rgba(120,80,30,.20), transparent 62%), linear-gradient(180deg,#f4e6cf,#e6cfad); }
        .paper-LOVE{ background: radial-gradient(900px 420px at 12% 10%, rgba(244,114,182,.32), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(253,164,175,.26), transparent 60%), linear-gradient(180deg,#fff,#fff5f9); }
        .paper-FOREST{ background: radial-gradient(900px 420px at 12% 10%, rgba(34,197,94,.20), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(16,185,129,.14), transparent 60%), linear-gradient(180deg,#ffffff,#f3fff8); }
        .paper-SKY{ background: radial-gradient(900px 420px at 12% 10%, rgba(147,197,253,.35), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(59,130,246,.18), transparent 60%), linear-gradient(180deg,#ffffff,#f1fbff); }
        .paper-NIGHT{ background: radial-gradient(900px 420px at 12% 10%, rgba(99,102,241,.24), transparent 62%), radial-gradient(760px 380px at 90% 18%, rgba(30,41,59,.14), transparent 60%), linear-gradient(180deg,#ffffff,#f5f7ff); }

        /* ✅ editor는 '테마 배경'을 그대로 쓰고 싶으면 inherit 하지 말고, 아래처럼 그대로 둬도 됨.
           다만 지금 요구사항은 "편집은 흰색"이므로 editor만 흰색 강제 처리함. */

        /* ==============================
           ✅ 편집 영역만 흰색 강제(핵심!)
           - 미리보기는 건드리지 않음
        ============================== */
        #editorShell.paper-editor-shell{
            background: #ffffff !important;
            background-image: none !important;
            color: #121926 !important;
        }
        /* lined 배경도 제거(편집만) */
        #editorShell.paper-editor-shell.paper-lined{
            background: #ffffff !important;
            background-image: none !important;
        }
        /* 편집영역 pseudo 제거(편집만) */
        #editorShell.paper-editor-shell::before,
        #editorShell.paper-editor-shell::after{
            content: none !important;
            display: none !important;
        }
        /* textarea는 투명이라 editorShell의 흰색이 보임 */
        #contentArea{
            color: #121926 !important;
        }

        /* ❌ (삭제) 미리보기 전체 흰색 강제하는 코드 제거!
        .paper-preview,
        .paper-preview *{
            background: #fff !important;
            color: #121926 !important;
        }
        */

        /* ✅ (선택) 다크 편지지일 때 미리보기 본문이 안 보이면, 본문만 보정 */
        .paper-preview.paper-DARK .paper-content,
        .paper-preview.paper-DARK .paper-title{
            color: #f8fafc;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="save-loading-overlay" id="saveLoading" aria-hidden="true">
    <div class="save-loading-box" role="dialog" aria-modal="true" aria-label="저장 로딩">
        <div class="save-spinner" aria-hidden="true"></div>
        <p class="save-title">저장 중이에요…</p>
        <p class="save-desc">잠시만 기다려 주세요.</p>
    </div>
</div>

<div class="container">
    <h2 class="page-title">AI 편지 결과 (수정 후 저장)</h2>

    <c:if test="${not empty errorMsg}">
        <div class="alert error" style="margin-bottom:12px;">
                ${errorMsg}
        </div>
    </c:if>

    <form id="saveForm"
          method="post"
          action="${pageContext.request.contextPath}/letter/ai/save"
          class="card">

        <!-- 유지값 -->
        <input type="hidden" name="isPublic" value="${isPublic}" />
        <input type="hidden" name="aiPrompt" value="${aiPrompt}" />
        <div class="field">
            <label for="writingStyleSelect">문체(스타일)</label>
            <select name="writingStyle" id="writingStyleSelect" required>
                <option value="CASUAL"     ${writingStyle eq 'CASUAL' ? 'selected' : ''}>CASUAL (친근)</option>
                <option value="FORMAL"     ${writingStyle eq 'FORMAL' ? 'selected' : ''}>FORMAL (정중)</option>
                <option value="EMOTIONAL"  ${writingStyle eq 'EMOTIONAL' ? 'selected' : ''}>EMOTIONAL (감성)</option>
                <option value="SHORT"      ${writingStyle eq 'SHORT' ? 'selected' : ''}>SHORT (짧게)</option>
                <option value="LONG"       ${writingStyle eq 'LONG' ? 'selected' : ''}>LONG (길게)</option>
            </select>
        </div>


        <div class="grid-2" style="margin-bottom:12px;">
            <div class="field">
                <label for="paperSelect">편지지 선택</label>
                <select name="paperType" id="paperSelect" required>
                    <optgroup label="기본">
                        <option value="BASIC"   ${paperType eq 'BASIC'   ? 'selected' : ''}>BASIC (기본)</option>
                        <option value="MINIMAL" ${paperType eq 'MINIMAL' ? 'selected' : ''}>MINIMAL (미니멀)</option>
                        <option value="PASTEL"  ${paperType eq 'PASTEL'  ? 'selected' : ''}>PASTEL (파스텔)</option>
                        <option value="VINTAGE" ${paperType eq 'VINTAGE' ? 'selected' : ''}>VINTAGE (감성)</option>
                        <option value="DARK"    ${paperType eq 'DARK'    ? 'selected' : ''}>DARK (다크)</option>
                    </optgroup>

                    <optgroup label="계절">
                        <option value="SPRING" ${paperType eq 'SPRING' ? 'selected' : ''}>SPRING (봄)</option>
                        <option value="SUMMER" ${paperType eq 'SUMMER' ? 'selected' : ''}>SUMMER (여름)</option>
                        <option value="AUTUMN" ${paperType eq 'AUTUMN' ? 'selected' : ''}>AUTUMN (가을)</option>
                        <option value="WINTER" ${paperType eq 'WINTER' ? 'selected' : ''}>WINTER (겨울)</option>
                    </optgroup>

                    <optgroup label="이벤트">
                        <option value="CHRISTMAS"   ${paperType eq 'CHRISTMAS'   ? 'selected' : ''}>CHRISTMAS (크리스마스)</option>
                        <option value="NEWYEAR"     ${paperType eq 'NEWYEAR'     ? 'selected' : ''}>NEWYEAR (새해)</option>
                        <option value="BIRTHDAY"    ${paperType eq 'BIRTHDAY'    ? 'selected' : ''}>BIRTHDAY (생일)</option>
                        <option value="ANNIVERSARY" ${paperType eq 'ANNIVERSARY' ? 'selected' : ''}>ANNIVERSARY (기념일)</option>
                        <option value="GRADUATION"  ${paperType eq 'GRADUATION'  ? 'selected' : ''}>GRADUATION (졸업)</option>
                        <option value="THANKYOU"    ${paperType eq 'THANKYOU'    ? 'selected' : ''}>THANKYOU (감사)</option>
                    </optgroup>

                    <optgroup label="노트/문구">
                        <option value="NOTE"      ${paperType eq 'NOTE'      ? 'selected' : ''}>NOTE (노트지)</option>
                        <option value="GRID"      ${paperType eq 'GRID'      ? 'selected' : ''}>GRID (그리드)</option>
                        <option value="MEMO"      ${paperType eq 'MEMO'      ? 'selected' : ''}>MEMO (메모지)</option>
                        <option value="DIARY"     ${paperType eq 'DIARY'     ? 'selected' : ''}>DIARY (일기장)</option>
                        <option value="LETTERPAD" ${paperType eq 'LETTERPAD' ? 'selected' : ''}>LETTERPAD (편지지)</option>
                    </optgroup>

                    <optgroup label="무드">
                        <option value="CRAFT"  ${paperType eq 'CRAFT'  ? 'selected' : ''}>CRAFT (크라프트)</option>
                        <option value="LOVE"   ${paperType eq 'LOVE'   ? 'selected' : ''}>LOVE (러브)</option>
                        <option value="FOREST" ${paperType eq 'FOREST' ? 'selected' : ''}>FOREST (숲)</option>
                        <option value="SKY"    ${paperType eq 'SKY'    ? 'selected' : ''}>SKY (하늘)</option>
                        <option value="NIGHT"  ${paperType eq 'NIGHT'  ? 'selected' : ''}>NIGHT (밤)</option>
                    </optgroup>
                </select>
            </div>

            <div class="field">
                <label for="tagSelect">태그</label>

                <c:choose>
                    <c:when test="${not empty tagList}">
                        <select id="tagSelect" name="tag" required>
                            <c:forEach var="t" items="${tagList}">
                                <option value="${t}" ${t eq tag ? 'selected' : ''}>${t}</option>
                            </c:forEach>
                            <c:if test="${not empty tag}">
                                <option value="${tag}" ${empty tagList ? 'selected' : ''} hidden>${tag}</option>
                            </c:if>
                        </select>
                    </c:when>
                    <c:otherwise>
                        <input type="text" id="tagSelect" name="tag" value="${tag}" readonly />
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="field" style="margin-bottom:12px;">
            <label>문체(스타일)</label>
            <div style="display:flex; gap:8px; flex-wrap:wrap; align-items:center; padding:10px 0;">
                <span class="badge">${writingStyle}</span>
                <span class="badge ai">AI</span>
            </div>
        </div>

        <label for="contentArea" style="font-weight:900; display:block; margin:6px 0 8px;">내용(수정 가능)</label>

        <div id="editorShell" class="paper-editor-shell paper-lined paper-${paperType}">
            <textarea id="contentArea" name="content" rows="14" required>${generatedContent}</textarea>
        </div>

        <div class="paper-preview-wrap">
            <p class="paper-preview-label">미리보기</p>
            <div id="previewBox" class="paper-preview paper-lined paper-${paperType}">
                <div class="paper-head">
                    <div class="paper-title" id="previewTagTitle">${tag}</div>
                    <div style="display:flex; gap:8px; flex-wrap:wrap;">
                        <span class="badge" id="badgePaper">${paperType}</span>
                        <span class="badge">${writingStyle}</span>
                        <span class="badge ai">AI</span>
                    </div>
                </div>
                <pre id="previewText" class="paper-content">${generatedContent}</pre>
            </div>
        </div>

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

        const paperSelect = document.getElementById('paperSelect');
        const tagSelect = document.getElementById('tagSelect');

        const contentArea = document.getElementById('contentArea');
        const previewBox = document.getElementById('previewBox');
        const previewText = document.getElementById('previewText');
        const badgePaper = document.getElementById('badgePaper');
        const previewTagTitle = document.getElementById('previewTagTitle');
        const editorShell = document.getElementById('editorShell');

        let submitting = false;

        function setLoading(on){
            overlay.classList.toggle('on', on);
            overlay.setAttribute('aria-hidden', on ? 'false' : 'true');
            btn.disabled = on;
            btn.textContent = on ? '저장 중...' : '저장하기';
        }

        function applyPaper(){
            const v = paperSelect.value;
            previewBox.className = 'paper-preview paper-lined paper-' + v;
            badgePaper.textContent = v;
            editorShell.className = 'paper-editor-shell paper-lined paper-' + v;
        }

        function applyText(){
            previewText.textContent = contentArea.value;
        }

        function applyTag(){
            if (tagSelect && previewTagTitle){
                previewTagTitle.textContent = tagSelect.value;
            }
        }

        paperSelect.addEventListener('change', applyPaper);
        contentArea.addEventListener('input', applyText);
        if (tagSelect && tagSelect.tagName === 'SELECT') {
            tagSelect.addEventListener('change', applyTag);
        }

        form.addEventListener('submit', (e) => {
            if (submitting) {
                e.preventDefault();
                return;
            }
            submitting = true;
            setLoading(true);

            setTimeout(() => {
                if (document.body.contains(overlay)) {
                    submitting = false;
                    setLoading(false);
                }
            }, 120000);
        });

        window.addEventListener('pageshow', () => {
            submitting = false;
            setLoading(false);
        });

        applyPaper();
        applyText();
        applyTag();
    })();
</script>
</body>
</html>
