package com.example.book.service;

import com.example.book.dao.BookMapper;
import com.example.book.dao.BorrowRecordMapper;
import com.example.book.entity.Book;
import com.example.book.util.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class BookServiceImpl implements BookService {

    @Autowired
    private BookMapper bookMapper;
    
    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Override
    public List<Book> getAllBooks() {
        return bookMapper.findAll();
    }

    @Override
    public Book getBookById(Integer id) {
        return bookMapper.findById(id);
    }

    @Override
    public List<Book> searchBooks(String title, String author, String category) {
        return bookMapper.findByCondition(title, author, category);
    }

    @Override
    public PageInfo<Book> getBooksByPage(int currentPage, int pageSize) {
        // 计算偏移量
        int offset = (currentPage - 1) * pageSize;
        
        // 查询数据
        List<Book> books = bookMapper.findByPage(offset, pageSize);
        
        // 查询总数
        int totalCount = bookMapper.countAllBooks();
        
        // 创建分页信息对象
        return new PageInfo<>(currentPage, pageSize, totalCount, books);
    }
    
    @Override
    public PageInfo<Book> searchBooksByPage(String title, String author, String category, int currentPage, int pageSize) {
        // 计算偏移量
        int offset = (currentPage - 1) * pageSize;
        
        // 查询数据
        List<Book> books = bookMapper.searchByPage(title, author, category, offset, pageSize);
        
        // 查询总数
        int totalCount = bookMapper.countByCondition(title, author, category);
        
        // 创建分页信息对象
        return new PageInfo<>(currentPage, pageSize, totalCount, books);
    }

    @Override
    public void addBook(Book book) {
        // 设置初始可借数量等于总数量
        book.setAvailableCopies(book.getTotalCopies());
        book.setCreateTime(new Date());
        bookMapper.insert(book);
    }

    @Override
    public void updateBook(Book book) {
        // 更新时保持可借数量逻辑
        Book existingBook = bookMapper.findById(book.getId());
        if (existingBook != null) {
            // 如果总数量增加，相应增加可借数量
            int diff = book.getTotalCopies() - existingBook.getTotalCopies();
            if (diff > 0) {
                book.setAvailableCopies(existingBook.getAvailableCopies() + diff);
            } else {
                // 如果总数量减少，确保可借数量不超过总数量
                book.setAvailableCopies(Math.min(existingBook.getAvailableCopies(), book.getTotalCopies()));
            }
        }
        bookMapper.update(book);
    }

    @Override
    public void deleteBook(Integer id) {
        bookMapper.delete(id);
    }

    @Override
    public boolean isBookAvailable(Integer bookId) {
        Book book = bookMapper.findById(bookId);
        return book != null && book.getAvailableCopies() > 0;
    }
    
    @Override
    public int getTotalBookCount() {
        return bookMapper.countAllBooks();
    }
    
    @Override
    public int getAvailableBookCount() {
        return bookMapper.countAvailableBooks();
    }
    
    @Override
    public void deleteBookAndRelatedRecords(Integer id) {
        // 先删除相关的借阅记录
        borrowRecordMapper.deleteByBookId(id);
        
        // 然后删除图书
        bookMapper.delete(id);
    }
}