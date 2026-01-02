package com.mbti.user.controller;

import com.mbti.user.model.dto.LoginRequest;
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
@CrossOrigin(origins = "*")
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
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
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
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        log.info("DELETE /api/users/{} - Deleting user", id);
        try {
            userService.deleteUser(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("Error deleting user with id: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}