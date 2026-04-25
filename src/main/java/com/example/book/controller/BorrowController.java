package com.example.book.controller;

import com.example.book.entity.BorrowRecord;
import com.example.book.entity.User;
import com.example.book.service.BorrowRecordService;
import com.example.book.service.UserService;
import com.example.book.util.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/borrow")
public class BorrowController {

    @Autowired
    private BorrowRecordService borrowRecordService;

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public String borrowList(@RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "10") int size,
                            HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        PageInfo<BorrowRecord> pageInfo = borrowRecordService.getAllBorrowRecordsByPage(page, size);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("user", user);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "borrow/list";
    }

    @PostMapping("/add")
    @ResponseBody
    public Map<String, Object> borrowBook(@RequestParam Integer bookId,
                                          @RequestParam Integer days,
                                          HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        boolean success = borrowRecordService.borrowBook(bookId, currentUser.getId(), days);
        result.put("success", success);
        result.put("message", success ? "借阅成功" : "借阅失败，图书可能已被借完");
        return result;
    }

    @PostMapping("/return/{id}")
    @ResponseBody
    public Map<String, Object> returnBook(@PathVariable Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        // 需要检查用户是否有权限归还这本书
        BorrowRecord record = borrowRecordService.getBorrowRecordById(id);
        if (record == null) {
            result.put("success", false);
            result.put("message", "借阅记录不存在");
            return result;
        }

        // 普通用户只能归还自己的书，管理员可以归还所有书
        if (!"ADMIN".equals(currentUser.getRole()) && !record.getUserId().equals(currentUser.getId())) {
            result.put("success", false);
            result.put("message", "您没有权限归还这本书");
            return result;
        }

        boolean success = borrowRecordService.returnBook(id);
        result.put("success", success);
        result.put("message", success ? "归还成功" : "归还失败");
        return result;
    }

    @GetMapping("/my")
    public String myBorrows(@RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "10") int size,
                           HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        PageInfo<BorrowRecord> pageInfo = borrowRecordService.getBorrowRecordsByUserByPage(currentUser.getId(), page, size);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("user", currentUser);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "borrow/my";
    }
}