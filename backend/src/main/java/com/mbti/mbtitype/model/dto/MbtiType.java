package com.mbti.mbtitype.model.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class MbtiType {
    private Long id;
    private String typeCode;
    private String typeName;
    private String description;
    private String characteristics;
    private String strengths;
    private String weaknesses;
    private String createdAt;
}