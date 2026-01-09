/*
폴더 구조
config
  common
      .dart 파일
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static String get appName => dotenv.env['APP_NAME'] ?? 'MBTI';
  static String get kakaoMapKey => dotenv.env['KAKAO_MAP_KEY'] ?? '빈 값 처리하거나 임의용 키 추가';
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isLocal => environment == 'local';

  static void printEnvInfo() {
    print("========= 환경설정 =========");
    print("environment: $environment");
    print("API Base URL: $apiBaseUrl");
    print("APP NAME: $appName");
    print("KAKAO Map Key: ${kakaoMapKey.isNotEmpty ? '설정됨' : '미설정'}");
  }
}