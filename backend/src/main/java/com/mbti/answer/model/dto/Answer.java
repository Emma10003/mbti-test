package com.mbti.answer.model.dto;


import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Answer {
    private Long id;
    private Long resultId;
    private Long questionId;
    private String selectedOption; // 'A' or 'B'
    private String selectedType; // E, I, S, N, T, F, J, P
    private String createdAt;
}
