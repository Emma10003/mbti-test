import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:go_router/go_router.dart';

// 상태에 따른 화면 변화가 일어날 예정.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeScreen 내부에서 사용할 변수명, 함수명 작성 공간
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

  String? _errorText;  // 에러 메세지를 담을 변수, ? = 변수공간에 null값이 들어갈 수 있다.

  // 유효성 검사 함수
  bool _validateName() {
    String name = _nameController.text.trim();

    // 1. 빈 값 체크
    if(name.isEmpty) {
      setState(() {
        _errorText = '이름을 입력해주세요.';
      });
      return false;
    }

    // 2. 글자 수 체크 (2글자 미만)
    if(name.length < 2) {
      setState(() {
        _errorText = '이름은 최소 2글자 이상이어야 합니다.';
      });
      return false;
    }

    // 3. 한글/영문 이외 특수문자나 숫자 포함 체크 여부 (정규식)
    //    만약 숫자도 허용하려면 r'^[가-힣-a-zA-Z0-9]+$' 로 변경
    if(!RegExp(r'^[가-힣-a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = '한글 또는 영문만 입력 가능합니다. (특수문자, 숫자 불가)';
      });
      return false;
    }

    // 통과 시 에러 메세지 비움
    setState(() {
      _errorText = null;
    });
    return true;
  }


  // UI 화면
  /*
  키보드를 모바일 화면에서 사용해야 하는 경우
  화면이 가려지는 것을 방지하기 위해 스크롤 가능하게 처리.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: /*const*/ Text("MBTI 유형 검사")
      ),
      body:
      SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology, size: 100, color: Colors.blue),
                SizedBox(height: 30),
                Text('나의 성격을 알아보는 ${AppConstants.totalQuestions}가지 질문',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 40),
                /**
                 * [ 유효성검사 ]
                 * 방법 1번 : TextField 에 입력할 때 마다 표기
                 * 방법 2번 : ElevatedButton 을 클릭할 때 표기
                 */
                SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '이름',
                        hintText: '이름을 입력하세요.',
                        border: OutlineInputBorder(),
                        errorText: _errorText,
                      ),
                      onChanged: (value) {
                        if(_errorText != null) {
                          setState(() {
                            _errorText = null;
                          });
                        }
                      },
                    )
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text.trim();

                      if(name.isEmpty) {
                        // 이름이 비어있을 경우 비어있음에 대한 안내 후 돌려보내기
                        return;
                      }

                      // 검사 화면으로 이동 (이름 전달)
                      context.go('/test', extra:name);
                    },
                    child: Text('검사 시작하기', style: TextStyle(fontSize: 16),),
                  ),
                ),
                /*
            div 와 성격이 같은 SizedBox 를 이용해서
            이전 결과 보기 버튼을 생성할 수 있다.
            굳이 SizedBox 를 사용하여 버튼을 감쌀 필요는 없지만,
            상태 관리나 디자인을 위해서 SizedBox로 감싼 다음에 버튼을 작성하는 것도 방법!
             */

                SizedBox(height: 20),
                SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          String name = _nameController.text.trim();

                          if(name.isEmpty) {
                            return;
                          }

                          // 작성한 이름 유저의 mbti 결과 확인
                          context.go("/history", extra: name);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                        ),
                        child: Text("이전 결과 보기")
                    )
                ),

                SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () => context.go('/types'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                          foregroundColor: Colors.black87
                      ),
                      child: Text("MBTI 유형 보기")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
