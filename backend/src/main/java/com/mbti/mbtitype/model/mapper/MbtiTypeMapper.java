package com.mbti.mbtitype.model.mapper;

import com.mbti.mbtitype.model.dto.MbtiType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MbtiTypeMapper {
    List<MbtiType> selectAll();
    MbtiType selectById(@Param("id") Long id);
    MbtiType selectByTypeCode(@Param("typeCode") String typeCode);
    int insert(MbtiType mbtiType);
    int update(MbtiType mbtiType);
    int delete(@Param("id") Long id);
}
