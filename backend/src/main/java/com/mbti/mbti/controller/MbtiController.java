package com.mbti.mbti.controller;


import com.mbti.mbti.model.service.MbtiService;
import com.mbti.mbtitype.model.dto.MbtiType;
import com.mbti.question.model.dto.Question;
import com.mbti.result.model.dto.Result;
import com.mbti.result.model.dto.TestRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/mbti")
@RequiredArgsConstructor
// @CrossOrigin(origins = "*")
@Slf4j
public class MbtiController {

    private final MbtiService mbtiService;

    /**
     * 모든 질문 조회
     * GET /api/mbti/questions
     */
    @GetMapping("/questions")
    public ResponseEntity<List<Question>> getAllQuestions() {
        log.info("GET /api/mbti/questions - Fetching all questions");
        try {
            List<Question> questions = mbtiService.getAllQuestions();
            return ResponseEntity.ok(questions);
        } catch (Exception e) {
            log.error("Error fetching questions", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 특정 질문 조회
     * GET /api/mbti/questions/{id}
     */
    @GetMapping("/questions/{id}")
    public ResponseEntity<Question> getQuestionById(@PathVariable Long id) {
        log.info("GET /api/mbti/questions/{} - Fetching question", id);
        try {
            Question question = mbtiService.getQuestionById(id);
            if (question == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(question);
        } catch (Exception e) {
            log.error("Error fetching question with id: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 검사 제출 및 결과 반환
     * POST /api/mbti/submit
     */
    @PostMapping("/submit")
    public ResponseEntity<Result> submitTest(@RequestBody TestRequest request) {
        log.info("POST /api/mbti/submit - Submitting test for user: {}", request.getUserName());
        try {
            // 입력 검증
            if (request.getAnswers() == null || request.getAnswers().isEmpty()) {
                log.warn("No answers provided in request");
                return ResponseEntity.badRequest().build();
            }

            Result result = mbtiService.submitTest(request);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("Error submitting test", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 결과 조회 (ID로)
     * GET /api/mbti/result/{id}
     */
    @GetMapping("/result/{id}")
    public ResponseEntity<Result> getResultById(@PathVariable Long id) {
        log.info("GET /api/mbti/result/{} - Fetching result", id);
        try {
            Result result = mbtiService.getResultById(id);
            return ResponseEntity.ok(result);
        } catch (RuntimeException e) {
            log.error("Result not found with id: {}", id);
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            log.error("Error fetching result with id: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 사용자별 결과 조회
     * GET /api/mbti/results?userName={userName}
     */
    @GetMapping("/results")
    public ResponseEntity<List<Result>> getResultsByUserName(
            @RequestParam String userName) {
        log.info("GET /api/mbti/results - Fetching results for user: {}", userName);
        try {
            List<Result> results = mbtiService.getResultsByUserName(userName);
            return ResponseEntity.ok(results);
        } catch (Exception e) {
            log.error("Error fetching results for user: {}", userName, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 모든 MBTI 유형 조회
     * GET /api/mbti/types
     */
    @GetMapping("/types")
    public ResponseEntity<List<MbtiType>> getAllMbtiTypes() {
        log.info("GET /api/mbti/types - Fetching all MBTI types");
        try {
            List<MbtiType> types = mbtiService.getAllMbtiTypes();
            return ResponseEntity.ok(types);
        } catch (Exception e) {
            log.error("Error fetching MBTI types", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 특정 유형 조회
     * GET /api/mbti/types/{typeCode}
     */
    @GetMapping("/types/{typeCode}")
    public ResponseEntity<MbtiType> getMbtiTypeByCode(@PathVariable String typeCode) {
        log.info("GET /api/mbti/types/{} - Fetching MBTI type", typeCode);
        try {
            MbtiType type = mbtiService.getMbtiTypeByCode(typeCode);
            if (type == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(type);
        } catch (Exception e) {
            log.error("Error fetching MBTI type: {}", typeCode, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 결과 삭제
     * DELETE /api/mbti/result/{id}
     */
    @DeleteMapping("/result/{id}")
    public ResponseEntity<Void> deleteResult(@PathVariable Long id) {
        log.info("DELETE /api/mbti/result/{} - Deleting result", id);
        try {
            mbtiService.deleteResult(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("Error deleting result with id: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Health Check
     * GET /api/mbti/health
     */
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("MBTI API is running!");
    }
}