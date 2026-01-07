import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
/*
초기에 만들어진 게스트 섹션은 input 입력창이 존재하지 않은 상태에서 만들었기 때문에
StatelessWidget이었지만,
현재는 input창이 생성되었고, 화면은 클라이언트가 작성하는 명칭을 기준으로 변환되기 때문에
StatefulWidget이 되어야 한다.
 */
class GuestSection extends StatefulWidget {
  const GuestSection({super.key});

  @override
  State<GuestSection> createState() => _GuestSectionState();
}

class _GuestSectionState extends State<GuestSection> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;

  bool _validateName() {
    String name = _nameController.text.trim();

    // 1. 빈 값 체크
    if (name.isEmpty) {
      setState(() {
        _errorText = '이름을 입력해주세요.';
      });
      return false;
    }

    // 2. 글자 수 체크 (2글자 미만)
    if (name.length < 2) {
      setState(() {
        _errorText = '이름은 최소 2글자 이상이어야 합니다.';
      });
      return false;
    }

    // 3. 한글/영문 이외 특수문자나 숫자 포함 체크 여부 (정규식)
    //    만약 숫자도 허용하려면 r'^[가-힣a-zA-Z0-9]+$' 로 변경
    //    - : 어디서부터 어디까지 표현
    //    가-힣 : '가'에서부터 '힣'까지, (힣-a : '힣'에서 'a'까지는 잘못된 문법. 정규식 동작 X)
    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = '한글 또는 영문만 입력 가능합니다.\n(특수문자, 숫자 불가)';
      });
      return false;
    }

    // 통과 시 에러 메세지 비움
    setState(() {
      _errorText = null;
    });
    return true;
  }

  /*
  참고 : Dart는 이중 주석 가능.
  /시작 주석
    /시작 주석
    종료주석/
  종료주석/

  가능한데 시작 주석과 종료 주석의 개수가 동일할 때만 가능.
   */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

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
              // 모든 상태 실시간 변경은 setState((){}) 내부에 작성.
              // setState() 로 감싸지 않은 if-else 문은 변수 값만 변경.
              // => 변수값은 변화하지만 화면에 업데이트 되지 않음.
              // setState() 로 감싼 if-else 문은
              // 화면이 자동으로 업데이트 되도록 상태 변경.
              setState(() {
                if (RegExp(r'[0-9]').hasMatch(value)) {
                  _errorText = '숫자는 입력할 수 없습니다.';
                } else if (RegExp(
                  r'[^가-힣a-zA-Z]',
                ).hasMatch(value)) {
                  _errorText = '한글과 영어만 입력 가능합니다.';
                } else {
                  _errorText = null;
                }
              });
            },

            /*
                      _validateName() 을 아래 onChanged 에서는 사용하지 않음.
                      '글자를 입력하면 무조건 에러 메세지를 비워라'
                      1111을 입력하는 순간에도 계속 에러 메세지를 지워버리기 때문에
                      정상적으로 _errorText는 작동하나 마치 작동하지 않는 것처럼 보임.
                      onChanged: (value) {
                        if(_errorText != null) {
                          setState(() {
                            _errorText = null;
                          });
                        }
                      },
                      */
          ),
        ),
        SizedBox(height: 20),

        // 로그인 버튼
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            child: Text('로그인하기', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20),

        /*
            div 와 성격이 같은 SizedBox 를 이용해서
            이전 결과 보기 버튼을 생성할 수 있다.
            굳이 SizedBox 를 사용하여 버튼을 감쌀 필요는 없지만,
            상태 관리나 디자인을 위해서 SizedBox로 감싼 다음에 버튼을 작성하는 것도 방법!
         */
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
              if (_validateName()) {
                print("검사 결과");
                String name = _nameController.text.trim();
                // 작성한 이름 유저의 mbti 결과 확인
                print("기록으로 이동하는 주소 위");
                context.go("/history", extra: name);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100],
              foregroundColor: Colors.black87,
            ),
            child: Text("이전 결과 보기"),
          ),
        ),
        SizedBox(height: 20),

        // 회원가입 버튼
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go('/signup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black87,
            ),
            child: Text("회원가입하기", style: TextStyle(fontSize: 16),),
          ),
        ),
      ],
    );
  }
}