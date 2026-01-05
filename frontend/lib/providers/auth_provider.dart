import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  // Getter
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  
  // 로그인 처리 관련 함수
  Future<void> login(User user) async {
    _user = user;
    _isLoading = false;
    
    // SharedPreferences 에 사용자 정보 저장.
    // 어플을 재시작 시에도 로그인이 유지되도록 할 수 있는 모듈.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id);
    await prefs.setString('userName', user.userName);
    
    notifyListeners();  // UI 업데이트
  }

  // 로그아웃 처리
  Future<void> logout() async {
    _user = user;

    // SharedPreferences 에 사용자 정보 삭제.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');  // userId 변수공간 이름에 내장된 데이터 지우기
    await prefs.remove('userName');  // userName 변수공간 이름에 내장된 데이터 지우기

    notifyListeners();  // UI 업데이트
  }

  // 어플 시작 시 저장된 로그인 상태 복원 (나의 핸드폰에 내장되어 있는 데이터로 복원)
  Future<void> loadSavedUser(User user) async {
    _isLoading = true;
    notifyListeners();  // UI 업데이트

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId'); // userId 변수공간 이름에 내장된 데이터 가져오기
      final userName = prefs.getString('userName'); // userName 변수공간 이름에 내장된 데이터 가져오기
      if(userId != null && userName != null) {
        _user = User(
          id: userId,
          userName: userName,
          createdAt: null,
          lastLogin: null,
        );
      }
    } catch(e) {
      print('Error loading saved User : $e');
    } finally {
      _isLoading = false;
      notifyListeners();  // UI 업데이트
    }

    notifyListeners();  // UI 업데이트
  }

  // 로딩 상태 설정
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();  // UI 업데이트
  }
}