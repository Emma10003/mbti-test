package com.mbti.question.model.dto;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Question {
    private Long id;
    private Integer questionNumber;
    private String questionText;
    private String dimension;
    private String optionA;
    private String optionB;
    private String optionAType;
    private String optionBType;
    private String createdAt;
}
