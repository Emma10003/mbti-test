package com.mbti.answer.model.dto;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class TestAnswer {
    private Long questionId;
    private String selectedOption; // 'A' or 'B'
}