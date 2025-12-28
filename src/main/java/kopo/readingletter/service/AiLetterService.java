package kopo.readingletter.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class AiLetterService {

    @Value("${openai.api-key:}")
    private String apiKey;

    @Value("${openai.model:gpt-5}")
    private String model;

    private final ObjectMapper om = new ObjectMapper();

    /* =========================
       1️⃣ 서버 시작 시 키 로딩 확인
       ========================= */
    @PostConstruct
    public void checkApiKeyLoaded() {
        System.out.println("==================================");
        System.out.println("[AI] AiLetterService loaded");
        System.out.println("[AI] API KEY loaded? : " + (apiKey != null && !apiKey.isBlank()));
        System.out.println("[AI] API KEY length : " + (apiKey == null ? 0 : apiKey.length()));
        System.out.println("[AI] Model          : " + model);
        System.out.println("==================================");
    }

    /* =========================
       2️⃣ 실제 AI 호출 메서드
       ========================= */
    public String generateLetter(String prompt, String writingStyle) {

        System.out.println("[AI] generateLetter() called");
        System.out.println("[AI] writingStyle = " + writingStyle);
        System.out.println("[AI] prompt length = " + (prompt == null ? 0 : prompt.length()));

        String styleGuide = switch (writingStyle) {
            case "FORMAL" -> "정중한 존댓말로, 격식을 갖춘 편지로 작성해.";
            case "EMOTIONAL" -> "감정이 풍부하고 따뜻한 말투로 작성해.";
            case "SHORT" -> "짧고 핵심만 6~10문장으로 작성해.";
            case "LONG" -> "조금 길게, 진심이 느껴지게 상세히 작성해.";
            default -> "친근하고 자연스러운 말투로 작성해.";
        };

        /* =========================
           3️⃣ API 키 없을 때
           ========================= */
        if (apiKey == null || apiKey.isBlank()) {
            System.out.println("[AI] ❌ API KEY is empty → dummy response");
            return "(API KEY 없음) 테스트용 더미\n\n" + prompt;
        }

        /* =========================
           4️⃣ 요청 바디 구성 로그
           ========================= */
        Map<String, Object> body = new HashMap<>();
        body.put("model", model);
        body.put("instructions",
                "너는 한국어 편지 대필 전문가야. 편지 본문만 작성해.\n" +
                        "- 메타설명 금지\n- 과한 이모지 금지\n- 마지막은 마무리 인사 1줄\n\n" +
                        "[문체]\n" + styleGuide
        );
        body.put("input", "상황/요청:\n" + prompt);

        System.out.println("[AI] Request body prepared");
        System.out.println("[AI] Calling OpenAI /v1/responses ...");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        HttpEntity<Map<String, Object>> req = new HttpEntity<>(body, headers);
        RestTemplate rt = new RestTemplate();

        try {
            /* =========================
               5️⃣ OpenAI 호출
               ========================= */
            ResponseEntity<String> res = rt.postForEntity(
                    "https://api.openai.com/v1/responses",
                    req,
                    String.class
            );

            System.out.println("[AI] OpenAI HTTP Status = " + res.getStatusCode());
            System.out.println("[AI] Raw response length = " +
                    (res.getBody() == null ? 0 : res.getBody().length()));

            JsonNode root = om.readTree(res.getBody());
            String text = extractAssistantText(root);

            if (text == null || text.isBlank()) {
                System.out.println("[AI] ❌ Parsing failed (no text found)");
                return "AI 응답 파싱 실패";
            }

            System.out.println("[AI] ✅ AI response parsed successfully");
            System.out.println("[AI] Response length = " + text.length());

            return text.trim();

        } catch (HttpStatusCodeException e) {
            System.out.println("[AI] ❌ OpenAI HTTP Error");
            System.out.println("[AI] Status = " + e.getStatusCode());
            System.out.println("[AI] Body   = " + e.getResponseBodyAsString());

            return "OpenAI 호출 실패 (" + e.getStatusCode() + ")\n"
                    + e.getResponseBodyAsString();

        } catch (Exception e) {
            System.out.println("[AI] ❌ Exception occurred");
            e.printStackTrace();
            return "OpenAI 호출/파싱 예외: " + e.getMessage();
        }
    }

    /* =========================
       6️⃣ 응답 파싱 로직
       ========================= */
    private String extractAssistantText(JsonNode root) {

        // 1) output_text shortcut
        JsonNode outText = root.get("output_text");
        if (outText != null && !outText.isNull()) {
            System.out.println("[AI] output_text found");
            return outText.asText();
        }

        // 2) OpenAI error
        JsonNode errMsg = root.path("error").path("message");
        if (!errMsg.isMissingNode()) {
            System.out.println("[AI] OpenAI error message found");
            return "OpenAI 오류: " + errMsg.asText();
        }

        // 3) output[] -> content[] -> output_text
        JsonNode output = root.path("output");
        if (output.isArray()) {
            StringBuilder sb = new StringBuilder();
            for (JsonNode item : output) {
                for (JsonNode part : item.path("content")) {
                    if ("output_text".equals(part.path("type").asText())) {
                        sb.append(part.path("text").asText()).append("\n");
                    }
                }
            }
            if (sb.length() > 0) {
                System.out.println("[AI] output[] content parsed");
                return sb.toString();
            }
        }

        System.out.println("[AI] ❌ No usable text in response");
        return null;
    }
}
