package com.mbti.question.model.mapper;

import com.mbti.question.model.dto.Question;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface QuestionMapper {
    List<Question> selectAll();
    Question selectById(@Param("id") Long id);
    List<Question> selectByDimension(@Param("dimension") String dimension);
    int insert(Question question);
    int update(Question question);
    int delete(@Param("id") Long id);
}
