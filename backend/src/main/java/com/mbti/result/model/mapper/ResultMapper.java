package com.mbti.result.model.mapper;

import com.mbti.result.model.dto.Result;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ResultMapper {
    List<Result> selectAll();
    Result selectById(@Param("id") Long id);
    Result selectByIdWithType(@Param("id") Long id);
    List<Result> selectByUserName(@Param("userName") String userName);
    int insert(Result result);
    int update(Result result);
    int delete(@Param("id") Long id);
}
