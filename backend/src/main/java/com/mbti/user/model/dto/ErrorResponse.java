package com.mbti.user.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ErrorResponse {
    private String error;
    private String userName;

    // 에러 메시지만 사용하는 생성자
    public ErrorResponse(String error) {
        this.error = error;
    }
}
