package com.example.book.service;

import com.example.book.entity.Book;
import com.example.book.util.PageInfo;
import java.util.List;

public interface BookService {

    // 获取所有图书
    List<Book> getAllBooks();

    // 根据ID获取图书
    Book getBookById(Integer id);

    // 搜索图书
    List<Book> searchBooks(String title, String author, String category);

    // 分页获取图书
    PageInfo<Book> getBooksByPage(int currentPage, int pageSize);
    
    // 分页搜索图书
    PageInfo<Book> searchBooksByPage(String title, String author, String category, int currentPage, int pageSize);

    // 添加图书
    void addBook(Book book);

    // 更新图书
    void updateBook(Book book);

    // 删除图书
    void deleteBook(Integer id);

    // 检查图书是否可借
    boolean isBookAvailable(Integer bookId);
    
    // 统计图书总数
    int getTotalBookCount();
    
    // 统计可借阅图书数量
    int getAvailableBookCount();
    
    // 删除图书及其相关借阅记录
    void deleteBookAndRelatedRecords(Integer id);
}