package com.mbti.user.model.service;

import com.mbti.user.model.dto.User;

import java.util.List;

public interface UserService {
    // 로그인
    User login(String userName);

    // ID로 사용자 조회
    User getUserById(Long id);

    // 사용자명으로 조회
    User getUserByUserName(String userName);

    // 모든 사용자 조회
    List<User> getAllUsers();

    // 사용자 삭제
    void deleteUser(Long id);
}
