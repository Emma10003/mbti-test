import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/env_config.dart';

class NetworkService {
  /*
  1. 클라이언트가 회원가입 - 게시물 작성할 때 게시물이 계속 업로드 중인 상태이거나
     게임 접속이 안 되거나 느림 -> 어플에 문제가 있구나! 오해할 수 있다.
      => 우리 어플에는 문제가 없고, 데이터가 문제있음을 전달
      
  2. 은행 or 보안 관련 어플은 인증 절차 등의 사용기간에 wifi 사용 못 하게 해야 할 경우가 있음.
     이럴 때 wifi로 접속한 것이 아니라 모바일 데이터로만 접속해야만 ok
     
  3. 어플 다운 / 대용량 다운 / 동영상 재생 설정 -> 스마트폰 기기나 어플에서
     wifi가 연결되어야만 다운되거나, 동영상 자동 재생 처리하도록 설정 가능
     wifi/모바일 데이터 관계없이 실행하겠다 와 같은 서비스 설정 가능.
  */
  
  // 싱글톤으로 private instance 변수 생성
  // static 클래스 레벨 변수 (모든 곳에서 공유)
  // final 한 번 할당되면 변경 불가. -> 1회나 일시적으로 호출할 때 사용.   
  // vs    const -> 메모리 관리하면서 상수로 사용, 주기적으로 호출해야 할 때 사용.
  static final NetworkService _instance = NetworkService._internal();
  // 만약 외부에서 _instance 내부에 존재하는 데이터에 접근하려 하는 경우
  // 기존에 사용했던 방법처럼 NetworkService._instance   -> NetworkService에 존재하는 변수이름
  // 과 같이 직접적으로 접근할 수 없음.
  // 아래처럼 service 라는 객체를 생성하여 NetworkService()를 복제하여 담아서 사용.
  // Java에서 생성자를 사용하는 것이나 Getter, Setter를 이용해 DB에서 가져온 데이터를 사용/저장하는 용도와 비슷.
  // NetworkService service = NetworkService();
  
  // ._internal() : private 생성자.
  
  
  // factory = 항상 새 인스턴스를 만들지 않아도 되는 생성자.
  // 기존 인스턴스를 반환하거나, 조건에 따른 인스턴스 반환 가능.
  // return 을 사용하거나 => 화살표 익명 return 사용.
  factory NetworkService() => _instance;
  NetworkService._internal();
  
  // connectivity_plus에서 제공하는 클래스.
  // wifi, 모바일데이터, 이더넷 등 네트워크 연결 타입을 감지하는 기능.
  final Connectivity _connectivity = Connectivity();
  final Dio _dio = Dio();
  
  
  // 현재 연결 타입 가져오기
  // _connectivity : network_service.dart 에서만 사용 가능한 변수명칭.
  // api_service or main과 같은 외부 .dart 파일은 접근 불가.
  Future<List<ConnectivityResult>> getConnectionType() async {
    return await _connectivity.checkConnectivity();
  }
  
  // wifi 연결 여부
  Future<bool> isWifiConnected() async {
    final results = await getConnectionType();
    return results.contains(ConnectivityResult.wifi);
  }
  
  // 모바일 데이터 연결 여부
  Future<bool> isMobileConnected() async {
    final results = await getConnectionType();
    return results.contains(ConnectivityResult.mobile);
  }
  
  // 네트워크 연결 여부 (wifi 또는 Mobile)
  Future<bool> isConnected() async {
    final results = await getConnectionType();
      return results.contains(ConnectivityResult.wifi)
          || results.contains(ConnectivityResult.mobile)
          || results.contains(ConnectivityResult.ethernet);
  }
  
  // 실제 인터넷 연결 여부 체크 (ping 테스트)
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');  // 보통은 본인 회사 홈페이지 작성하여 접속 확인.
      // 우리는 사이트가 없기 때문에 구글 봐 지는지 테스트
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    };
  }
  
  // 백엔드 서버 연결 체크 (Health Check)
  Future<bool> isServerConnected() async {
    try {
      final res = await _dio.get(
        '${EnvConfig.apiBaseUrl}/health',
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3)
        )
      );
      return res.statusCode == 200;
    } catch (e) {
      print('서버 연결 실패: $e');
      return false;
    }
  }
  
  // 네트워크 변경 감지 스트림
  Future<String> checkStatus() async {
    // 네트워크 연결 체크
    if(!await isConnected()){
      return '네트워크에 연결되어 있지 않습니다.';
    }

    // 인터넷 연결 체크
    if(!await hasInternet()) {
      return '인터넷 연결을 확인해주세요.';
    }

    // 서버 연결 체크
    if(!await isServerConnected()) {
      return '서버에 연결할 수 없습니다. 백엔드가 실행 중인지 확인하세요.';
    }

    return '모든 연결이 정상입니다.';
  }
}