
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/common/env_config.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/map/map_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/signup/signup_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_type_screen.dart';
import 'package:frontend/services/network_service.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

import 'models/result_model.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // 1. 카카오 자바스크립트 키 초기화
  // 키 데이터는 .env 처럼 관리.
  // 환경별 .env 파일 로드
  // 개발 : .env.development
  // 배포 : .env.production
  // 로컬 : .env.local
  //      .env.load(파일이름: "프로젝트에 존재하는 파일이름")
  await dotenv.load(fileName: ".env.development");

  // 개발 중 상황 확인을 위해 환경정보 출력
  if(EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  /*
    자료형? : 공간 내부가 텅텅 비어있을 때,
    undefined를 호출하여 에러를 발생하는 것이 아니라
    null = 비어있음 상태로 처리하여 에러를 발생시키지 않는 안전 타입.
    ex) String? 변경가능한_데이터를_보관할수있는_공간명칭;
   ------------------------------------------------------------------------
    공간명칭! = NULL 단언 연산자. 이 공간은 절대로 null 이 아님을 보장하는 표기.
              개발자가 null이 아니라고 강제 선언.
               -> 위험한 연산자이지만 현재는 사용할 것.
               // AI : null 이면 빈 문자열 반환하는 방법이 있어요 -- 아래 코드 추천
               // static String get kakaoMAPKey => dotenv.env['KAKAO_MAP_KEY'] ?? '';
               // => but 빈 값이나 강제 대체값 처리보다는 가져와야 하는 키를 무사히 불러올 수 있도록 로직 작성하기.
    ------------------------------------------------------------------------
    ?? : null이면 기본값       ex) name ?? '기본프로필이미지.png'
    ?. : null이면 null 반환    ex) name?.length : 이름이 비어있으면 null
   */
  AuthRepository.initialize(appKey: EnvConfig.kakaoMapKey);
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen()
      ),

      // 2. 지도 경로 스크린 추가 /map
      GoRoute(
          path: '/map',
          builder: (context, state) => const MapScreen()
      ),

      // 로그인 화면
      GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen()
      ),

      // 회원가입 화면
      GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen()
      ),

      // 검사 화면
      GoRoute(
          path: '/test',
          builder: (context, state) {
          final userName = state.extra as String; // 잠시 사용할 이름인데 문자열이에용.
/*
            생성된 객체를 사용할 수는 있으나, 매개변수는 존재하지 않은 상태.
            단순히 화면만 보여주는 형태.
            const TestScreen({super.key});
             */

            return TestScreen(userName: userName);   // TestScreen에서 userName을 userName이라는 변수명으로 사용하세요
          }
      ),

      // 결과 화면
      GoRoute(
          path: '/result',
          builder: (context, state) {
            // final data = state.extra as Map<String, dynamic>;
            final result = state.extra as Result;
            return ResultScreen(
              result: result,
            );
/*
            return ResultScreen(
                userName: data['userName']!,
                resultType: data['resultType']!,
                eScore: data['eScore']!,
                iScore: data['iScore']!,
                sScore: data['sScore']!,
                nScore: data['nScore']!,
                tScore: data['tScore']!,
                fScore: data['fScore']!,
                jScore: data['jScore']!,
                pScore: data['pScore']!,
            );
             */

          }
      ),

      GoRoute(
          path: '/history',
          builder: (context, state) {
            final userName = state.extra as String;  // 메인페이지에서 적은 이름만 가져옴
            // return ResultDetailScreen(userName: state.extra as String,);
            //                        required  final userName
            return ResultDetailScreen(userName: userName,);
          }
      ),

      // MBTI 유형 보기
      GoRoute(
          path: '/types',
          builder: (context, state) => MbtiTypesScreen(),
      )
    ]
);

// MyApp Stateless -> Stateful
// context -> 최상위에서 사용하지 않음 - HomeScreen으로 이동하여 사용하는 것이 맞음.
class MyApp extends StatefulWidget {
  // const MyApp({super.key});

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();


}
class _MyAppState extends State<MyApp> {
  final NetworkService _networkService = NetworkService();

  @override
  void initState() {
    _checkNetwork();
  } // initState() 사용할 것
  // initState() 내부에 아래 기능 로드

  void _checkNetwork() async {
    final status = await _networkService.checkStatus();

    if(mounted && status.contains('x나 연결되지 않았다는 공통된 구문 포함되어 있다면')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status), backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //     Google에서 제공하는 기본 커스텀 CSS 를 사용하며
    //                 특정 경로를 개발자가 하나하나 설정하겠다.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider())
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        // 경로 설정에 대한 것은 : _router 라는 변수를 참고해서 사용하기.
        routerConfig: _router,)

/*
      추후에 라이트테마/댜크테마 만들어서 세팅
      theme
      darkTheme
      themeMode

      home을 사용할 때는 go_router를 사용해 기본 메인 위치를 지정하지 않고,
      home을 기준으로 경로 이동 없이 작성할 때 사용.
      home: const HomeScreen(),
      */


    );
  }
}
