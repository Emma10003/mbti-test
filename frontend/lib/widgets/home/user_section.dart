import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserSection extends StatefulWidget {
  const UserSection({super.key});

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {
  // 유효성 검사 함수
  // 기능 중에 일부라도 문법상 문제가 생기면 기능 자체가 작동 중지.
  /*
  만약에 Input 이나 Textarea를 사용할 경우에는 사용자들이 작성한 값(value)을 읽고
  읽은 value 데이터를 가져오기 위해 기능을 작성해야 함. (React의 경우)
  -> dart에서는 TextEditingController 객체를 미리 만들어놓았음.

  [ 사용방법 ]
  1. 컨트롤러 상태를 담을 변수공간 설정 -> private 설정을 안 해도 되지만 보통은 private으로 선언.
      final TextEditingController _nameController = TextEditingController();

  2. TextField에 연결
      TextField(
        controller: _nameController 와 같은 형태로 내부에서 작성된 value를 연결
      )

  3. 값을 가져와서 확인하거나 사용하기
      String name = _nameController.text;
   */
  final TextEditingController _nameController = TextEditingController();

  // 에러 메세지를 담을 변수, ? = 변수공간에 null값이 들어갈 수 있다.
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.user?.userName; // ? -> 없으면 에러 뜨기보다는 null로 상태 유지.
    return Column(
      children: [
        /// 000 님 표기
        SizedBox(
          child: Text(
              // '${widget.userName} 님',
              '$userName 님',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              )
          ),
        ),
        SizedBox(height: 25),

        // 3. /map 내 위치 지도 보기로 잠시 사용
        SizedBox(
          width: 300,
          height: 50,
          // child: Text("내 주변 10km 다른 유저의 MBTI 확인하기"),
          child: ElevatedButton(
            onPressed: () => context.go('/map'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              foregroundColor: Colors.brown
            ),
            child: Text("내 위치 지도 보기", style: TextStyle(fontSize: 16),),
          )
        ),
        SizedBox(height: 10),

        // 이전 결과 보기 버튼
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              print("버튼 눌림");
              // 이름 내부 한 번 더 상태 확인
              // if (_validateName()) { -> input 창에 데이터가 존재해야만 검사 결과로 이동할 수 있기 때문에
              // 위의 조건문으로는 버튼을 눌렀을 때 이동할 수 없음.
              if (userName != null) {
                print("검사 결과");
                String name = _nameController.text.trim();
                // 작성한 이름 유저의 mbti 결과 확인
                print("기록으로 이동하는 주소 위");
                context.go("/history", extra: userName);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100],
              foregroundColor: Colors.black87,
            ),
            child: Text("이전 결과 보기", style: TextStyle(fontSize: 16),),
          ),
        ),

      ],
    );
  }
}
