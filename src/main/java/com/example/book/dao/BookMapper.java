package com.example.book.dao;

import com.example.book.entity.Book;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface BookMapper {

    // 查询所有图书
    List<Book> findAll();

    // 根据ID查询图书
    Book findById(Integer id);

    // 根据条件搜索图书
    List<Book> findByCondition(@Param("title") String title,
                               @Param("author") String author,
                               @Param("category") String category);

    // 分页查询图书
    List<Book> findByPage(@Param("offset") int offset, 
                          @Param("pageSize") int pageSize);
    
    // 分页搜索图书
    List<Book> searchByPage(@Param("title") String title,
                            @Param("author") String author,
                            @Param("category") String category,
                            @Param("offset") int offset,
                            @Param("pageSize") int pageSize);

    // 新增图书
    void insert(Book book);

    // 更新图书信息
    void update(Book book);

    // 删除图书
    void delete(Integer id);

    // 更新库存数量
    void updateAvailableCopies(@Param("id") Integer id,
                               @Param("count") Integer count);

    // 检查ISBN是否已存在
    int countByIsbn(@Param("isbn") String isbn);
    
    // 统计图书总数
    int countAllBooks();
    
    // 统计可借阅图书总数
    int countAvailableBooks();
    
    // 统计搜索结果总数
    int countByCondition(@Param("title") String title,
                         @Param("author") String author,
                         @Param("category") String category);
}