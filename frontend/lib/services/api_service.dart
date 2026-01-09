
import 'dart:convert';

import 'package:frontend/common/constants.dart';
import 'package:frontend/models/answer_model.dart';
import 'package:frontend/models/question_model.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/models/test_request_model.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:frontend/services/network_service.dart';

import '../models/mbti_type_model.dart';
import '../models/user_model.dart';
/*
  final에 비해서 const가 가벼움
  - 단기적으로 값 변경하지 못하도록 상수처리 할 때 = final
  - 장기적으로 전체 공유하는 상수처리 값 = const

  const = 어플 전체적으로 사용되는 상수 명칭
  final = 특정 기능이나 화면에서만 부분적으로 사용되는 상수 명칭
  */

/*
Dio 의 장점 ----------------------------------------
1. 자동으로 JSON 인코딩 / 디코딩 처리
2. Interceptor 를 통한 로깅, 인증 토큰 추가 가능
3. 백엔드 통신 타임아웃 설정이 더 간편
4. FormData, 파일 업로드 지원이 편리
5. 에러처리가 더 구조화되어 있음
6. queryParameters를 쉽게 추가 가능

http와의 차이점 -------------------------------------
- http : json.encode() / json.decode() 필요.
- dio  : 자동으로 처리, response.data로 바로 접근.

- http : Uri.parse() 필요.
- dio  : baseUrl 설정 후 상대경로만 작성.

- http : 에러 처리가 statusCode 기반.
- dio  : DioException으로 다양한 에러 타입 처리 가능.
 */
class ApiService {

  static const String url = ApiConstants.baseUrl;

  // Dio 인스턴스 생성
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-type' : 'application/json',
      },
    ),
  );

  // ==================== 사용자 관련 API ====================
  // 회원가입
  static Future<User> signup(String userName) async {
    final res = await _dio.post(
      '${ApiConstants.userUrl}/signup',
      data: {'userName': userName}
    );

    // 회원가입의 경우 200과 201 사용.
    // 200 : 요청 성공 (주로 GET, PUT, PATCH에서 사용)
    // 201 : 리소스 생성 성공 (POST에서 사용) - 회원가입, 게시물 작성
    // 204 : No content, 성공했으나 응답 본문 없음 (DELETE에서 사용)
    if(res.statusCode == 200 || res.statusCode == 201) {
      Map<String, dynamic> jsonData = res.data;
      return User.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 로그인
  static Future<User> login(String userName) async {
    final res = await _dio.post(
        '${ApiConstants.userUrl}/login',
        data: {'userName': userName}
    );

    if(res.statusCode == 200) {
      return User.fromJson(res.data);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 사용자명으로 사용자 조회
  static Future<User?> getUserByUserName(String userName) async {
    final res = await _dio.get('${ApiConstants.userUrl}/name/$userName');

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = res.data;
      return User.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 모든 사용자 조회
  static Future<List<User>> getAllUsers() async {
    final res = await _dio.get(ApiConstants.userUrl);

    if(res.statusCode == 200) {
      List<dynamic> jsonData = res.data;
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // ==================== 질문 관련 API ====================
  // 질문 가져오기
  static NetworkService _networkService = NetworkService();
  static Future<List<Question>> getQuestions() async {
    if(!await _networkService.isConnected()) {
      throw Exception('네트워크에 연결되어 있지 않습니다.');
    }

    // 백엔드와 연결되어 있는지 확인 후 아래 기능 수행


    final res = await _dio.get('${ApiConstants.mbtiUrl}/questions');

    if(res.statusCode == 200) {
      List<dynamic> jsonList = res.data;
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // ==================== 검사 제출 API ====================
  // 결과 제출하기 post
  static Future<Result> submitTest(String userName, Map<int, String> answers) async {
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();

    TestRequest request = TestRequest(userName: userName, answers: answerList);

    final res = await _dio.post(
        ApiConstants.submit,
        data: request.toJson(),
    );
    if(res.statusCode == 200){
      return Result.fromJson(res.data);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 모든 MBTI 유형 조회
  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await _dio.get(ApiConstants.types);

    if(res.statusCode == 200) {
      List<dynamic> jsonList = res.data;
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 특정 MBTI 유형 조회
  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await _dio.get('${ApiConstants.types}/$typeCode');

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = res.data;
      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }


  // 사용자별 결과 조회
  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await _dio.get(
        ApiConstants.results,
        queryParameters: {'userName': userName}
    );

    if(res.statusCode == 200) {
      List<dynamic> jsonList = res.data;
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // ID로 결과 조회
  static Future<Result> getResultById(int id) async {
    final res = await _dio.get('$url${ApiConstants.result}/$id');

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = res.data;
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 결과 삭제
  static Future<void> deleteResult(int id) async {
    final res = await _dio.delete('$url${ApiConstants.result}/$id');

    if(res.statusCode != 200) {
      throw Exception('삭제에 실패했습니다.');
    }
  }


  // Health Check = 백엔드 상태 관리용 api
  static Future<Result> healthCheck() async{
    final res = await _dio.get(ApiConstants.health);

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = res.data;
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.serverError);
    }
  }
}








/*
class HttpApiService {

  // 상태 관리가 된 url 주소를 호출
  static const String url = ApiConstants.baseUrl;

  // ==================== 사용자 관련 API ====================
  // 로그인
  static Future<User> login(String userName) async {
    final res = await http.post(
      Uri.parse('$url${ApiConstants.userUrl}'),
      headers: {'Content-Type' : 'application/json'},
      body: json.encode({'userName': userName})
    );

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 사용자명으로 사용자 조회
  static Future<User?> getUserByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.userUrl}/name/$userName'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 모든 사용자 조회
  static Future<List<User>> getAllUsers() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.userUrl}'));

    if(res.statusCode == 200) {
      List<dynamic> jsonData = json.decode(res.body);
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 회원가입
  static Future<User> signup(String userName) async {
    final res = await http.post(
        Uri.parse('$url${ApiConstants.userUrl}'),
        headers: {'Content-Type' : 'application/json'},
        body: json.encode({'userName': userName})
    );

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }


  // ==================== 질문 관련 API ====================
  // 질문 가져오기
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/mbti/questions'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // ==================== 검사 제출 API ====================
  // 결과 제출하기 post
  static Future<Result> submitTest(String userName, Map<int, String> answers) async {
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();

    TestRequest request = TestRequest(userName: userName, answers: answerList);

    final res = await http.post(
      // http://localhost:8080/api/mbti/submit
        Uri.parse('$url${ApiConstants.submit}'),
        headers: {'Content-Type':'application/json'},
        body: json.encode(request.toJson())
    );
    if(res.statusCode == 200){
      Map<String, dynamic> jsonData = json.decode(res.body);
      // return json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 모든 MBTI 유형 조회
  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.types}'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 특정 MBTI 유형 조회
  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.types}/$typeCode'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }


  // 사용자별 결과 조회
  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.results}?userName=$userName'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // ID로 결과 조회
  // GET /api/mbti/result/{id}
  // method = getResultById(int id)
  // http.get
  // Map<String, dynamic>
  static Future<Result> getResultById(int id) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.result}/$id'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 결과 삭제
  // GET /api/mbti/result/{id}
  // method = deleteResult(int id)
  // http.delete
  // final res
  // Future 예상결과로 백엔드에서 진행한 결과에 대한 return 없이 기능만 수행.
  static Future<void> deleteResult(int id) async {
    final res = await http.delete(Uri.parse('$url${ApiConstants.result}/$id'));

    if(res.statusCode != 200) {
      throw Exception('삭제에 실패했습니다.');
    }
  }


  // Health Check = 백엔드 상태 관리용 api
  // GET /api/mbti/health
  // method = healthCheck
  // final res
  // 개발 회사 상태 확인용 API
  static Future<Result> healthCheck() async{
    final res = await http.get(Uri.parse('$url${ApiConstants.health}'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.serverError);
    }
  }

  /*
  final               res -> http.Response 라는 타입으로 자동 지정.
  final http.Response res ->

  final         res  : 타입 명시를 하지 않아 Dart에서 자동으로 반환타입 파악.
  final String  res  : 타입을 명확히 지정
  final int     res  : 타입을 명확히 지정

  final a = 1;  // int로 자동 타입 확인.
  개발자가 만든 자료형이나 클래스형 자료형은 필히 타입을 작성해줄 것.
   */
}


// models 에 작성한 자료형, 변수명을 활용하여 데이터 타입 지정.
class ModelsApiService {

  static const String url = 'http://localhost:8080/api/mbti';

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 을 사용
  // - 특정 자료형을 감싸서 사용
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));

    /*
    http://localhost:8080/api/mbti 로 접속했을 때 나오는 데이터
      res.body = 백엔드에서 위 주소로 전달받은 JSON 문자열 -> 주소로 가져오는 데이터는 한 줄로 가져온다.
      ‘[{ “id” : 1, “questionText” : “질문1”,  “optionA” : “A”,  “optionB” : “B” }, { “id” : 2, “questionText” : “질문2”,  “optionA” : “A”,  “optionB” : “B” }, { “id” : 3, “questionText” : “질문3”,  “optionA” : “A”,  “optionB” : “B” },]’

     json.decode()                            = 한 줄로 되어있는 JSON 문자열 데이터를 Dart 형식의 객체로 변환해서 사용.
     .map((json) => Question.fromJson(json))  = 변환을 할 때 각 데이터 하나씩 json 이라는 변수명에 담아서
                                                         Question 객체로 변환하는 작업을 첫 데이터부터 마지막 데이터까지 모두 수행.
     .toList()                                = map 으로 출력된 결과를 List 목록 형태로 변환하여 사용.
     */
    
    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('불러오기 실패');
    }
  }

  // 결과 제출하기 post
  /*
  Dart = JavaScript + Java + C++ + SQL

  Map<int, String> answers = 소비자가 작성한 원본 데이터가 존재.
                             Map<int, String> answers = {
                                1: 'A',
                                2: 'B',
                                3: 'A',
                                ...
                             }

  answers.entries         = Map을 MapEntry 리스트로 변환한 것.
                     결과 = [
                              MapEntry(key: 1, value: 'A'),
                              MapEntry(key: 2, value: 'B'),
                              MapEntry(key: 3, value: 'A'),
                              ...
                            ]
  .map((en) {                      = 각 MapEntry를 TestAnswer로 변환
      return TestAnswer(
        questionId: en.key,          // 1, 2, 3
        selectedOption: en.value     // 'A', 'B', 'A'
      );
    })
  .toList()                       = 최종 결과로 List 형태로 변환

  MapEntry : Map의 키-값 쌍을 나타내는 객체.
  entries  : entry의 반복문 형태
  
  현재 우리가 작성한 백엔드에서 위와 같은 형식을 유지하고 있기 때문에
  만약에 TestAnswer와 같은 응답 전용 객체를 Java에서 사용하지 않는다면 
  entries 작업까지 할 필요는 없음.
  -----------------------------------------
  [ Entry = DB 하나의 컬럼에 존재하는 데이터. ]
  사전 한 권     = Map
  사전의 각 항목 = Entry

  // 책 사전 내부에 존재하는 예시 데이터
  키         값
  apple  -> 사과      = entry 1개
  banana -> 바나나    = entry 1개
  cherry -> 체리      = entry 1개
  총 entry 개체 : 3개

  [ Entries = 모든 entry 항목 종합 ]
  모든 키-값 쌍들
  전화번호부 한 줄 :
    이름(key) : 홍길동
    전화번호(value) : 010-1234-5678

  -> entry 1개 = 객체 1개의 데이터.

   */
  static Future<Result> submitTest(String userName, Map<int, String> answers) async {
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();

    TestRequest request = TestRequest(userName: userName, answers: answerList);

    final res = await http.post(
        Uri.parse('$url/submit'),
        headers: {'Content-Type':'application/json'},
        body: json.encode(request.toJson())
    );
    if(res.statusCode == 200){
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception('제출 실패');
    }
  }

  // 모든 MBTI 유형 조회
  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await http.get(Uri.parse('$url/types'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception('MBTI 유형 불러오기 실패');
    }
  }

// 특정 MBTI 유형 조회
  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await http.get(Uri.parse('$url/types/$typeCode'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception('MBTI 유형 조회 실패');
    }
  }


  // 사용자별 결과 조회 - ㅇㅇㅇ 이름에 해당하는 모든 데이터 목록 조회
  /*
  사용자별 결과 조회
  GET /api/mbti/results?userName={userName}

  Dart 는 변수명 뒤에 하위변수나 하위 기능이 존재하지 않을 경우
  - $변수명 - 중괄호{} 없이 작성 가능.
  변수명.세부변수명 / 변수명.세부기능() 과 같이 존재할 경우
  - ${변수명.세부변수명} / ${변수명.세부기능()} - 중괄호{}로 감싸서 작성.
   */
  //
  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url/results?userName=$userName'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      // constants 에서 지정한 에러 타입으로 교체
      throw Exception('MBTI 유형 불러오기 실패');
    }
  }



}


/*
  Map<String, dynamic> jsonData = json.decode(res.body);
  String = 키 명칭들은 문자열로 확정!
  <String      ,  dynamic>
  "id"               1,             // int
  "userName"       "홍길동",         // String
  "resultType"     "ENFP",          // String
  "isActive"        true,           // boolean
  "createdAt"       null,           // null
  "scores"       [2, 3, 1, ...],    // List

  Q. dynamic 대신에 Object 사용하면 안 되나요?
  A. 안 됨.
     Object 는 null 불가능!
        └───── Dart에서 Object 타입은 null 불가능, 컴파일에서는 연산 불가. (2.1.2 부터 null 사용 금지이고 dynamic 써라 권장)
        └───── Java에서 Object 타입은 null 가능 ^-^...
     dynamic은 null 가능!
        └───── 컴파일에서는 우선 타입이 무엇인지 ???? 상태로 일단 OK
            └───── 실행하면서 타입이 맞지 않으면 에러 발생.
 */


// -----------------------------------------------------------------------------
class DynamicApiService {

  static const String url = 'http://localhost:8080/api/mbti';

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 을 사용
  // - 특정 자료형을 감싸서 사용
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));

    if(res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('불러오기 실패');
    }
  }

  // 결과 제출하기 post
  static Future<Map<String,dynamic>> submitTest(String userName, Map<int, String> answers) async {
    List<Map<String, dynamic>> answerList = [];
    answers.forEach((questionId, option) {
      answerList.add({
        'questionId' : questionId,
        'selectedOption':option
      });
    });
    final res = await http.post(
        Uri.parse('$url/submit'),
        headers: {'Content-Type':'application/json'},
        body: json.encode({
          'userName':userName,
          'answers':answerList
        })
    );
    if(res.statusCode == 200 ){
      return json.decode(res.body);
    } else {
      throw Exception('제출 실패');
    }
  }
}


 */