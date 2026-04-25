package com.example.book.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * 密码工具类
 */
public class PasswordUtil {
    
    /**
     * 生成BCrypt密码哈希
     * @param plainPassword 明文密码
     * @return BCrypt哈希值
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }
    
    /**
     * 验证密码
     * @param plainPassword 明文密码
     * @param hashedPassword 哈希密码
     * @return 验证结果
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 生成测试用户的BCrypt哈希值
     * @param args 命令行参数
     */
    public static void main(String[] args) {
        String adminPassword = "admin123";
        String userPassword = "user123";
        
        String adminHash = hashPassword(adminPassword);
        String userHash = hashPassword(userPassword);
        
        System.out.println("管理员密码 '" + adminPassword + "' 的BCrypt哈希值:");
        System.out.println(adminHash);
        System.out.println();
        
        System.out.println("用户密码 '" + userPassword + "' 的BCrypt哈希值:");
        System.out.println(userHash);
        System.out.println();
        
        // 验证
        System.out.println("验证管理员密码: " + checkPassword(adminPassword, adminHash));
        System.out.println("验证用户密码: " + checkPassword(userPassword, userHash));
    }
}