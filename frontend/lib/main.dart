import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_type_screen.dart';
import 'package:go_router/go_router.dart';

import 'models/result_model.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen()
      ),

      // 검사 화면
      GoRoute(
          path: '/test',
          builder: (context, state) {
            final userName = state.extra as String;  // 잠시 사용할 이름인데 문자열이에용.
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //     Google에서 제공하는 기본 커스텀 CSS 를 사용하며
    //                 특정 경로를 개발자가 하나하나 설정하겠다.
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // 경로 설정에 대한 것은 : _router 라는 변수를 참고해서 사용하기.
      routerConfig: _router,
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