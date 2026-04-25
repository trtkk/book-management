package com.example.book.controller;

import com.example.book.entity.User;
import com.example.book.service.BookService;
import com.example.book.service.BorrowRecordService;
import com.example.book.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

@Controller
public class PageController {
    
    @Autowired
    private BookService bookService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private BorrowRecordService borrowRecordService;

    @GetMapping("/")
    public String index() {
        return "redirect:/login";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        System.out.println("=== DEBUG: 访问仪表板 ===");

        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            System.out.println("=== DEBUG: 用户未登录，重定向到登录页面 ===");
            return "redirect:/login";
        }

        System.out.println("=== DEBUG: 用户已登录: " + user.getUsername() + " ===");
        
        // 获取统计数据
        int totalBooks = bookService.getTotalBookCount();
        int availableBooks = bookService.getAvailableBookCount();
        int totalUsers = userService.getTotalUserCount();
        int currentBorrows = borrowRecordService.getCurrentBorrowCount();
        
        model.addAttribute("user", user);
        model.addAttribute("totalBooks", totalBooks);
        model.addAttribute("availableBooks", availableBooks);
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("currentBorrows", currentBorrows);
        return "dashboard";
    }
}