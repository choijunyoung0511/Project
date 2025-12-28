package kopo.readingletter.controller;

import jakarta.servlet.http.HttpSession;
import kopo.readingletter.dto.LetterDTO;
import kopo.readingletter.dto.UserDTO;
import kopo.readingletter.service.AiLetterService;
import kopo.readingletter.service.LetterService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@RequestMapping("/letter")
public class AiLetterController {

    private final AiLetterService aiLetterService;
    private final LetterService letterService;

    private static final String SESSION_KEY = "loginUser";

    // 1) 입력 폼
    @GetMapping("/ai")
    public String aiForm(HttpSession session) {
        UserDTO user = (UserDTO) session.getAttribute(SESSION_KEY);
        if (user == null) {
            return "redirect:/auth/login";
        }
        return "letter/aiForm";
    }

    // 2) AI 생성
    @PostMapping("/ai/generate")
    public String generate(
            @RequestParam String tag,
            @RequestParam int isPublic,
            @RequestParam String paperType,
            @RequestParam String writingStyle,
            @RequestParam String prompt,
            Model model,
            HttpSession session
    ) {
        UserDTO user = (UserDTO) session.getAttribute(SESSION_KEY);
        if (user == null) {
            return "redirect:/auth/login";
        }

        String generatedContent;
        try {
            generatedContent = aiLetterService.generateLetter(prompt, writingStyle);
        } catch (Exception e) {
            // ✅ 실패해도 화면은 유지 + 사용자에게 메시지
            model.addAttribute("tag", tag);
            model.addAttribute("isPublic", isPublic);
            model.addAttribute("paperType", paperType);
            model.addAttribute("writingStyle", writingStyle);
            model.addAttribute("aiPrompt", prompt);

            model.addAttribute("generatedContent", "");
            model.addAttribute("errorMsg", "AI 생성 실패: " + e.getMessage());

            return "letter/aiResult"; // 또는 "letter/aiForm"으로 보내도 됨
        }

        model.addAttribute("tag", tag);
        model.addAttribute("isPublic", isPublic);
        model.addAttribute("paperType", paperType);
        model.addAttribute("writingStyle", writingStyle);
        model.addAttribute("aiPrompt", prompt);
        model.addAttribute("generatedContent", generatedContent);

        return "letter/aiResult";
    }


    // 3) 저장
    @PostMapping("/ai/save")
    public String save(
            @RequestParam String tag,
            @RequestParam int isPublic,
            @RequestParam String paperType,
            @RequestParam String writingStyle,
            @RequestParam String content,
            @RequestParam(required = false) String aiPrompt,
            HttpSession session
    ) {
        UserDTO user = (UserDTO) session.getAttribute(SESSION_KEY);
        if (user == null) {
            return "redirect:/auth/login";
        }

        long userId = user.getId();

        LetterDTO dto = new LetterDTO();
        dto.setUserId(userId);
        dto.setTag(tag);
        dto.setIsPublic(isPublic);
        dto.setContent(content);
        dto.setPaperType(paperType);
        dto.setWritingStyle(writingStyle);
        dto.setIsAiGenerated(1);
        dto.setAiPrompt(aiPrompt);

        letterService.insertLetter(dto);

        String scope = (isPublic == 1) ? "public" : "private";
        return "redirect:/letter/list?scope=" + scope;
    }
}
