package com.example.book.controller;

import com.example.book.entity.User;
import com.example.book.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session, Model model) {
        try {
            User user = userService.login(username, password);
            if (user != null) {
                if ("INACTIVE".equals(user.getStatus())) {
                    model.addAttribute("error", "账户已被禁用");
                    return "login";
                }
                
                if ("DELETED".equals(user.getStatus())) {
                    model.addAttribute("error", "账户已被删除");
                    return "login";
                }

                // 如果用户状态是PENDING(待激活)，则更新为ACTIVE(激活)
                if ("PENDING".equals(user.getStatus())) {
                    user.setStatus("ACTIVE");
                    userService.updateUser(user);
                }

                session.setAttribute("currentUser", user);
                return "redirect:/dashboard";
            } else {
                model.addAttribute("error", "用户名或密码错误");
                return "login";
            }
        } catch (Exception e) {
            model.addAttribute("error", "系统错误，请稍后再试");
            e.printStackTrace(); // 在实际生产环境中应该使用日志记录而不是直接打印
            return "login";
        }
    }
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(User user, Model model) {
        boolean success = userService.register(user);
        if (success) {
            model.addAttribute("message", "注册成功，请登录");
            return "login";
        } else {
            model.addAttribute("error", "用户名已存在");
            return "register";
        }
    }
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}