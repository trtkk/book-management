package com.example.book.controller;

import com.example.book.entity.User;
import com.example.book.service.UserService;
import com.example.book.util.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    // 检查用户是否已登录且为管理员
    private boolean isAdminUser(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        return currentUser != null && "ADMIN".equals(currentUser.getRole());
    }

    // 重定向到无权限页面或登录页面
    private String redirectToUnauthorized(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        } else {
            return "redirect:/dashboard";
        }
    }

    @GetMapping("/list")
    public String userList(@RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size,
                          HttpSession session, Model model) {
        if (!isAdminUser(session)) {
            return redirectToUnauthorized(session);
        }

        PageInfo<User> pageInfo = userService.getUsersByPage(page, size);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("currentUser", (User) session.getAttribute("currentUser"));
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "user/list";
    }

    @GetMapping("/add")
    public String showAddForm(HttpSession session, Model model) {
        if (!isAdminUser(session)) {
            return redirectToUnauthorized(session);
        }
        
        model.addAttribute("user", new User());
        model.addAttribute("currentUser", (User) session.getAttribute("currentUser"));
        return "user/form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, HttpSession session, Model model) {
        if (!isAdminUser(session)) {
            return redirectToUnauthorized(session);
        }

        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        model.addAttribute("currentUser", (User) session.getAttribute("currentUser"));
        return "user/form";
    }

    @PostMapping("/add")
    public String addUser(User user, HttpSession session) {
        if (!isAdminUser(session)) {
            return redirectToUnauthorized(session);
        }

        userService.addUser(user);
        return "redirect:/user/list";
    }

    @PostMapping("/update")
    public String updateUser(User user, HttpSession session) {
        if (!isAdminUser(session)) {
            return redirectToUnauthorized(session);
        }

        // 管理员不能修改自己的信息，防止权限丢失
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser.getId().equals(user.getId())) {
            // 如果是管理员试图修改自己的信息，重定向到用户列表
            return "redirect:/user/list";
        }

        userService.updateUser(user);
        return "redirect:/user/list";
    }

    @PostMapping("/disable/{id}")
    @ResponseBody
    public String disableUser(@PathVariable Integer id, HttpSession session) {
        if (!isAdminUser(session)) {
            return "error";
        }

        // 管理员不能禁用自己
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser.getId().equals(id)) {
            return "error: 不能禁用当前登录的管理员账户";
        }

        userService.disableUser(id);
        return "success";
    }

    @PostMapping("/enable/{id}")
    @ResponseBody
    public String enableUser(@PathVariable Integer id, HttpSession session) {
        if (!isAdminUser(session)) {
            return "error";
        }

        userService.enableUser(id);
        return "success";
    }
    
    @PostMapping("/delete/{id}")
    @ResponseBody
    public String deleteUser(@PathVariable Integer id, HttpSession session) {
        if (!isAdminUser(session)) {
            return "error";
        }

        // 管理员不能删除自己
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser.getId().equals(id)) {
            return "error: 不能删除当前登录的管理员账户";
        }

        try {
            userService.deleteUser(id);
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "error: " + e.getMessage();
        }
    }
}