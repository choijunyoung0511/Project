package kopo.readingletter.controller;

import jakarta.servlet.http.HttpSession;
import kopo.readingletter.dto.UserDTO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(HttpSession session, Model model) {
        UserDTO user = (UserDTO) session.getAttribute("loginUser");
        model.addAttribute("user", user);
        return "home"; // /WEB-INF/views/home.jsp 만들면 됨
    }
}
