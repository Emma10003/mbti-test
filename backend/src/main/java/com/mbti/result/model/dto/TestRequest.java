package com.mbti.result.model.dto;

import com.mbti.answer.model.dto.TestAnswer;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class TestRequest {
    private String userName;
    private List<TestAnswer> answers;
}
