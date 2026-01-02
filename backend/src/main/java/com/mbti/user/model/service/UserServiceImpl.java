package com.mbti.user.model.service;

import com.mbti.user.model.dto.User;
import com.mbti.user.model.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;

    /**
     * 로그인 (사용자 등록 또는 마지막 로그인 시간 업데이트)
     */
    @Transactional
    @Override
    public User login(String userName) {
        log.info("Login attempt for user: {}", userName);

        // 기존 사용자 확인
        User existingUser = userMapper.selectByUserName(userName);

        if (existingUser != null) {
            // 기존 사용자 - 마지막 로그인 시간 업데이트
            userMapper.updateLastLogin(existingUser.getId());
            log.info("Existing user logged in: {}", userName);
            return userMapper.selectById(existingUser.getId());
        } else {
            // 신규 사용자 - 등록
            User newUser = new User();
            newUser.setUserName(userName);
            userMapper.insert(newUser);
            log.info("New user registered: {}", userName);
            return userMapper.selectById(newUser.getId());
        }
    }

    /**
     * ID로 사용자 조회
     */
    @Override
    public User getUserById(Long id) {
        log.info("Fetching user with id: {}", id);
        return userMapper.selectById(id);
    }

    /**
     * 사용자명으로 조회
     */
    @Override
    public User getUserByUserName(String userName) {
        log.info("Fetching user with userName: {}", userName);
        return userMapper.selectByUserName(userName);
    }

    /**
     * 모든 사용자 조회
     */
    @Override
    public List<User> getAllUsers() {
        log.info("Fetching all users");
        return userMapper.selectAll();
    }

    /**
     * 사용자 삭제
     */
    @Transactional
    @Override
    public void deleteUser(Long id) {
        log.info("Deleting user with id: {}", id);
        userMapper.delete(id);
    }
}