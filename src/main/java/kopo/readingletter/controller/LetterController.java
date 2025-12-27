package kopo.readingletter.controller;

import jakarta.servlet.http.HttpSession;
import kopo.readingletter.dto.LetterDTO;
import kopo.readingletter.dto.UserDTO;
import kopo.readingletter.service.LetterService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/letter")
@RequiredArgsConstructor
public class LetterController {

    private final LetterService letterService;

    // ✅ 내 편지함 리스트 (scope: all/public/private)
    @GetMapping("/list")
    public String letterList(
            @RequestParam(value="scope", defaultValue="all") String scope,
            HttpSession session,
            Model model) {

        UserDTO user = (UserDTO) session.getAttribute("loginUser"); // ✅ 인터셉터랑 키 맞추기
        Long userId = user.getId();

        List<LetterDTO> letters = letterService.getMyLetters(userId, scope);

        model.addAttribute("letters", letters);
        model.addAttribute("scope", scope);

        return "letter/letterList";
    }


    // ✅ 편지 상세
    @GetMapping("/detail/{id}")
    public String letterDetail(
            @PathVariable("id") Long id,
            @RequestParam(value = "scope", defaultValue = "all") String scope,
            HttpSession session,
            Model model) {

        UserDTO user = (UserDTO) session.getAttribute("loginUser");
        if (user == null) return "redirect:/auth/login";

        Long userId = user.getId();

        LetterDTO letter = letterService.getLetterDetail(id, userId); // (없으면 null)
        if (letter == null) {
            return "redirect:/letter/list?scope=" + scope;
        }

        model.addAttribute("letter", letter);
        model.addAttribute("scope", scope);

        return "letter/letterDetail";
    }
}
