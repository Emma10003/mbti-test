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
    public User getUserById(int id) {
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
    public void deleteUser(int id) {
        log.info("Deleting user with id: {}", id);
        userMapper.delete(id);
    }

    @Override
    public User signup(String userName) {
        log.info("Signup attempt for user: {}", userName);

        // TODO 1: 유효성 검사 - userName이 null이거나 비어있는지 체크
        // 힌트: if (userName == null || userName.trim().isEmpty())
        if (userName == null || userName.trim().isEmpty()) {
            log.warn("Empty username provided for signup");
            throw new IllegalArgumentException("사용자 이름은 필수입니다.");
        }

        // TODO 2: 중복 체크 - 이미 존재하는 사용자인지 확인
        // 힌트: userMapper.selectByUserName(userName)
        // 힌트: 존재하면 IllegalArgumentException 발생
        User existingUser = userMapper.selectByUserName(userName);
        if (existingUser != null) {
            log.warn("Username already exists: {}", userName);
            throw new IllegalArgumentException("이미 존재하는 사용자입니다.");
        }

        // TODO 3: 신규 사용자 등록
        // 힌트: User 객체 생성 -> userName 설정 -> userMapper.insertUser() 호출
        User newUser = new User();
        newUser.setUserName(userName);
        userMapper.insertUser(newUser);
        log.info("New user signed up: {} with id: {}", userName, newUser.getId());

        // TODO 4: 등록된 사용자 정보 반환
        // 힌트: userMapper.selectById(newUser.getId())
        return userMapper.selectById(newUser.getId());
    }
}