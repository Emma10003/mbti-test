package com.mbti.mbti.model.service;

import com.mbti.answer.model.dto.Answer;
import com.mbti.answer.model.dto.TestAnswer;
import com.mbti.answer.model.mapper.AnswerMapper;
import com.mbti.mbtitype.model.dto.MbtiType;
import com.mbti.mbtitype.model.mapper.MbtiTypeMapper;
import com.mbti.question.model.dto.Question;
import com.mbti.question.model.mapper.QuestionMapper;
import com.mbti.result.model.dto.Result;
import com.mbti.result.model.dto.TestRequest;
import com.mbti.result.model.mapper.ResultMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class MbtiServiceImpl implements MbtiService {

    private final QuestionMapper questionMapper;
    private final ResultMapper resultMapper;
    private final AnswerMapper answerMapper;
    private final MbtiTypeMapper mbtiTypeMapper;

    /**
     * 모든 질문 조회
     */
    public List<Question> getAllQuestions() {
        log.info("Fetching all questions");
        return questionMapper.selectAll();
    }

    /**
     * 특정 질문 조회
     */
    public Question getQuestionById(Long id) {
        log.info("Fetching question with id: {}", id);
        return questionMapper.selectById(id);
    }

    /**
     * 검사 제출 및 결과 계산
     */
    @Transactional
    public Result submitTest(TestRequest request) {
        log.info("Submitting test for user: {}", request.getUserName());

        // 1. 점수 계산
        Map<String, Integer> scores = calculateScores(request.getAnswers());

        // 2. MBTI 유형 결정
        String mbtiType = determineMbtiType(scores);
        log.info("Calculated MBTI type: {}", mbtiType);

        // 3. 결과 저장
        Result result = new Result();
        result.setUserName(request.getUserName());
        result.setResultType(mbtiType);
        result.setEScore(scores.get("E"));
        result.setIScore(scores.get("I"));
        result.setSScore(scores.get("S"));
        result.setNScore(scores.get("N"));
        result.setTScore(scores.get("T"));
        result.setFScore(scores.get("F"));
        result.setJScore(scores.get("J"));
        result.setPScore(scores.get("P"));

        resultMapper.insert(result);
        log.info("Saved result with id: {}", result.getId());

        // 4. 답변 저장
        List<Answer> answers = new ArrayList<>();
        for (TestAnswer testAnswer : request.getAnswers()) {
            Question question = questionMapper.selectById(testAnswer.getQuestionId());

            Answer answer = new Answer();
            answer.setResultId(result.getId());
            answer.setQuestionId(testAnswer.getQuestionId());
            answer.setSelectedOption(testAnswer.getSelectedOption());

            // 선택한 옵션에 따라 유형 결정
            String selectedType = testAnswer.getSelectedOption().equals("A")
                    ? question.getOptionAType()
                    : question.getOptionBType();
            answer.setSelectedType(selectedType);

            answers.add(answer);
        }

        // 배치로 답변 저장
        if (!answers.isEmpty()) {
            answerMapper.insertBatch(answers);
            log.info("Saved {} answers", answers.size());
        }

        // 5. 유형 정보와 함께 결과 반환
        return getResultById(result.getId());
    }

    /**
     * 점수 계산
     */
    public Map<String, Integer> calculateScores(List<TestAnswer> answers) {
        Map<String, Integer> scores = new HashMap<>();
        scores.put("E", 0); scores.put("I", 0);
        scores.put("S", 0); scores.put("N", 0);
        scores.put("T", 0); scores.put("F", 0);
        scores.put("J", 0); scores.put("P", 0);

        for (TestAnswer answer : answers) {
            Question question = questionMapper.selectById(answer.getQuestionId());

            String selectedType = answer.getSelectedOption().equals("A")
                    ? question.getOptionAType()
                    : question.getOptionBType();

            scores.put(selectedType, scores.get(selectedType) + 1);
        }

        return scores;
    }

    /**
     * MBTI 유형 결정
     */
    public String determineMbtiType(Map<String, Integer> scores) {
        StringBuilder mbtiType = new StringBuilder();

        // E vs I
        mbtiType.append(scores.get("E") >= scores.get("I") ? "E" : "I");

        // S vs N
        mbtiType.append(scores.get("S") >= scores.get("N") ? "S" : "N");

        // T vs F
        mbtiType.append(scores.get("T") >= scores.get("F") ? "T" : "F");

        // J vs P
        mbtiType.append(scores.get("J") >= scores.get("P") ? "J" : "P");

        return mbtiType.toString();
    }

    /**
     * 결과 조회 (유형 정보 포함)
     */
    public Result getResultById(Long id) {
        log.info("Fetching result with id: {}", id);
        Result result = resultMapper.selectByIdWithType(id);

        if (result == null) {
            throw new RuntimeException("Result not found with id: " + id);
        }

        // 답변 목록 추가
        List<Answer> answers = answerMapper.selectByResultId(id);
        result.setAnswers(answers);

        return result;
    }

    /**
     * 사용자별 결과 조회
     */
    public List<Result> getResultsByUserName(String userName) {
        log.info("Fetching results for user: {}", userName);
        return resultMapper.selectByUserName(userName);
    }

    /**
     * 모든 MBTI 유형 조회
     */
    public List<MbtiType> getAllMbtiTypes() {
        log.info("Fetching all MBTI types");
        return mbtiTypeMapper.selectAll();
    }

    /**
     * 특정 유형 조회
     */
    public MbtiType getMbtiTypeByCode(String typeCode) {
        log.info("Fetching MBTI type: {}", typeCode);
        return mbtiTypeMapper.selectByTypeCode(typeCode);
    }

    /**
     * 결과 삭제
     */
    @Transactional
    public void deleteResult(Long id) {
        log.info("Deleting result with id: {}", id);

        // 답변 먼저 삭제 (외래키 제약)
        answerMapper.deleteByResultId(id);

        // 결과 삭제
        resultMapper.delete(id);
    }
}