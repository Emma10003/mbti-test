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

    // TODO: 회원가입용 메서드 추가
    // 힌트: insert와 유사하지만 중복 체크가 필요
    // 메서드명: insertUser
    // 반환타입: int (영향받은 행 수)
    // 매개변수: User user
    int insertUser(User user);
}
