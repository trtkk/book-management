package com.example.book.dao;

import com.example.book.entity.User;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface UserMapper {

    // 根据用户名查询用户（登录用）
    User findByUsernameAndPassword(String username);

    // 根据用户名查询用户
    User findByUsername(String username);

    // 查询所有用户
    List<User> findAll();

    // 分页查询用户
    List<User> findByPage(@Param("offset") int offset, @Param("pageSize") int pageSize);

    // 根据ID查询用户
    User findById(Integer id);

    // 新增用户
    void insert(User user);

    // 更新用户信息
    void update(User user);

    // 更新用户状态
    void updateStatus(@Param("id") Integer id, @Param("status") String status);

    // 删除用户（软删除）
    void deleteUser(Integer id);
    
    // 软删除用户（使用inactive状态表示删除）
    void softDeleteUser(Integer id);

    // 查询活跃用户
    List<User> findActiveUsers();
    
    // 统计用户总数
    int countAllUsers();
}