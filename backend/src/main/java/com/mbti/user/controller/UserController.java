package com.mbti.user.controller;

import com.mbti.user.model.dto.ErrorResponse;
import com.mbti.user.model.dto.LoginRequest;
import com.mbti.user.model.dto.SignupRequest;
import com.mbti.user.model.dto.User;
import com.mbti.user.model.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
/**
 * 단순 get method는 가볍게
 * @CrossOrigin(origins = "*") 사용 가능하지만
 * get 이외의 메서드는 추가 CORS 설정 필요.
 * @CrossOrigin(origins = "*", allowedHeaders = "*")
 * 제일 좋은 방법은 WebConfig 세팅하는 것.
 * WebConfig.java 세팅하는 순간 부터는 @CrossOrigin() 사용 금지.
 * 이중으로 웹 연결 설정을 할 경우 환경설정 로직이 내부에서 중첩되어 코드가 꼬일 수 있음.
 *
 * A 부서 : WebConfig로 프론트엔드 연결 가능한 주소 세팅
 * B 부서 : @CrossOrigin으로 프론트엔드 연결 가능한 주소 세팅
 * => 외부에서 봤을 때는 A 부서와 B 부서가 대화가 안 된 상태이고, 어떤 부서가 만든 프론트엔드 허용 로직을 사용해야 하는지
 *    알 수 없는 상태가 됨.
 * 본인이 개별적으로 코드를 작성해놓고 부서 두 가지로 팀을 나누어 겨루는 상황과 비슷.
 * 팀 내에서도 소통 불능으로 인하여 프론트엔드 연결 설정을 모두 따로 작업했다 표기하는 것과 같음.
 * 반드시 WebConfig로 프론트엔드 주소를 세팅하거나 @CrossOrigin으로 주소 세팅.
 * (근데 주로 WebConfig를 사용하길 권장함.)
 */
// CrossOrigin을 WebConfig로 변경하여 사용
// 회원가입 성공되었습니다 까지 확인하기.
// @CrossOrigin(origins = "*", allowedHeaders = "*")
@Slf4j
public class UserController {

    private final UserService userService;

    /**
     * 로그인 (신규 등록 또는 기존 사용자)
     * POST /api/users/login
     */
    @PostMapping("/login")
    public ResponseEntity<User> login(@RequestBody LoginRequest request) {
        log.info("POST /api/users/login - User: {}", request.getUserName());

        try {
            if (request.getUserName() == null || request.getUserName().trim().isEmpty()) {
                log.warn("Empty username provided");
                return ResponseEntity.badRequest().build();
            }

            User user = userService.login(request.getUserName().trim());
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            log.error("Error during login", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 모든 사용자 조회
     * GET /api/users
     */
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        log.info("GET /api/users - Fetching all users");
        try {
            List<User> users = userService.getAllUsers();
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            log.error("Error fetching users", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * ID로 사용자 조회
     * GET /api/users/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable int id) {
        log.info("GET /api/users/{} - Fetching user", id);
        try {
            User user = userService.getUserById(id);
            if (user == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            log.error("Error fetching user with id: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 사용자명으로 조회
     * GET /api/users/name/{userName}
     */
    @GetMapping("/name/{userName}")
    public ResponseEntity<User> getUserByUserName(@PathVariable String userName) {
        log.info("GET /api/users/name/{} - Fetching user", userName);
        try {
            User user = userService.getUserByUserName(userName);
            if (user == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            log.error("Error fetching user with userName: {}", userName, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 사용자 삭제
     * DELETE /api/users/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable int id) {
        log.info("DELETE /api/users/{} - Deleting user", id);
        try {
            userService.deleteUser(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("Error deleting user with id: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 회원가입
     * POST /api/users/signup
     */
    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignupRequest request) {
        log.info("POST /api/users/signup - User: {}", request.getUserName());

        try {
            if (request.getUserName() == null || request.getUserName().trim().isEmpty()) {
                log.warn("Empty username provided for signup");
                ErrorResponse error = new ErrorResponse("사용자 이름은 필수입니다.");
                return ResponseEntity.badRequest().body(error);
            }

            User user = userService.signup(request.getUserName().trim());

            return ResponseEntity.status(HttpStatus.CREATED).body(user);

        } catch (IllegalArgumentException e) {
            log.warn("Signup failed: {}", e.getMessage());
            ErrorResponse error = new ErrorResponse(e.getMessage(), request.getUserName());

            if (e.getMessage().contains("이미 존재")) {
                return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
            } else {
                return ResponseEntity.badRequest().body(error);
            }
        } catch (Exception e) {
            // TODO 5: 기타 예외 처리
            log.error("Error during signup", e);
            // 힌트: InternalServerError(500) 응답
            log.error("Error during signup", e);
            ErrorResponse error = new ErrorResponse("서버 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
}