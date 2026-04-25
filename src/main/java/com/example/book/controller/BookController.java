package com.example.book.controller;

import com.example.book.entity.Book;
import com.example.book.entity.User;
import com.example.book.service.BookService;
import com.example.book.util.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.beans.propertyeditors.CustomDateEditor;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/book")
public class BookController {

    @Autowired
    private BookService bookService;

    // 添加日期格式化绑定
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }

    // 检查用户是否为管理员
    private boolean isAdmin(User user) {
        return user != null && "ADMIN".equals(user.getRole());
    }

    @GetMapping("/list")
    public String bookList(@RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size,
                          HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        PageInfo<Book> pageInfo = bookService.getBooksByPage(page, size);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("user", user);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "book/list";
    }

    @GetMapping("/search")
    public String searchBooks(@RequestParam(required = false) String title,
                              @RequestParam(required = false) String author,
                              @RequestParam(required = false) String category,
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "10") int size,
                              HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        PageInfo<Book> pageInfo = bookService.searchBooksByPage(title, author, category, page, size);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("user", user);
        model.addAttribute("searchTitle", title);
        model.addAttribute("searchAuthor", author);
        model.addAttribute("searchCategory", category);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "book/list";
    }

    @GetMapping("/add")
    public String showAddForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        
        // 只有管理员可以添加图书
        if (!isAdmin(user)) {
            return "redirect:/book/list";
        }
        
        // 初始化一个空的图书对象
        model.addAttribute("book", new Book());
        model.addAttribute("user", user);
        return "book/form";
    }

    @PostMapping("/add")
    public String addBook(Book book, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        // 只有管理员可以添加图书
        if (!isAdmin(user)) {
            return "redirect:/book/list";
        }

        bookService.addBook(book);
        return "redirect:/book/list";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        // 只有管理员可以编辑图书
        if (!isAdmin(user)) {
            return "redirect:/book/list";
        }

        Book book = bookService.getBookById(id);
        if (book == null) {
            // 如果图书不存在，重定向到图书列表
            return "redirect:/book/list";
        }
        
        model.addAttribute("book", book);
        model.addAttribute("user", user);
        return "book/form";
    }

    @PostMapping("/update")
    public String updateBook(Book book, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        // 只有管理员可以更新图书
        if (!isAdmin(user)) {
            return "redirect:/book/list";
        }

        // 检查图书是否存在
        Book existingBook = bookService.getBookById(book.getId());
        if (existingBook == null) {
            return "redirect:/book/list";
        }

        bookService.updateBook(book);
        return "redirect:/book/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteBook(@PathVariable Integer id, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        // 只有管理员可以删除图书
        if (!isAdmin(user)) {
            return "redirect:/book/list";
        }

        // 检查图书是否存在
        Book existingBook = bookService.getBookById(id);
        if (existingBook == null) {
            return "redirect:/book/list";
        }

        // 使用新的删除方法，同时删除相关借阅记录
        bookService.deleteBookAndRelatedRecords(id);
        return "redirect:/book/list";
    }
}