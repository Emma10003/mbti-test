package com.mbti.answer.model.mapper;

import com.mbti.answer.model.dto.Answer;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AnswerMapper {
    List<Answer> selectAll();
    Answer selectById(@Param("id") Long id);
    List<Answer> selectByResultId(@Param("resultId") Long resultId);
    int insert(Answer answer);
    int insertBatch(List<Answer> answers);
    int update(Answer answer);
    int delete(@Param("id") Long id);
    int deleteByResultId(@Param("resultId") Long resultId);
}
