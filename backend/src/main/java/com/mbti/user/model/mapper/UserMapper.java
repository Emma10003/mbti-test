package com.mbti.user.model.mapper;

import com.mbti.user.model.dto.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {
    // 모든 사용자 조회
    List<User> selectAll();

    // ID로 사용자 조회
    User selectById(int id);

    // 사용자명으로 조회
    User selectByUserName(String userName);

    // 사용자 등록
    int insert(User user);

    // 마지막 로그인 시간 업데이트
    int updateLastLogin(int id);

    // 사용자 삭제
    int delete(int id);

    // 회원가입
    int insertUser(User user);
}
