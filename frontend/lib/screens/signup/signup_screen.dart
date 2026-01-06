import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 이름 입력필드 제어를 위한 컨트롤러
  final TextEditingController _nameController = TextEditingController();

  // 유효성 검사 에러메세지 저장
  String? _errorText;

  // 회원가입 진행 중 상태 관리
  bool _isLoading = false;

  bool _validateName() {
    String name = _nameController.text.trim();

    // 1. 빈 값 체크
    if(name.isEmpty) {
      setState(() {
        _errorText = "이름을 입력해주세요";
      });
      return false;
    }

    // 2. 최소 글자 수 체크 (2글자 이상)
    if(name.length < 2) {
      setState(() {
        _errorText = "이름은 최소 2글자 이상이어야 합니다.";
      });
      return false;
    }

    // 3. 한글/영문만 허용 (특수문자, 숫자 불가)
    if(!RegExp(r'^[가-힣a-zA-Z]').hasMatch(name)) {
      setState(() {
        _errorText = "한글 또는 영문만 입력 가능합니다.\n(특수문자, 숫자 불가)";
      });
      return false;
    }

    setState(() {
      _errorText = null;
    });

    return true;
  }

  // 백엔드와 주고받는 기능, Future<>를 작성하지 않아도 문제는 발생하지 않음.
  // 프론트엔드와 백엔드가 데이터를 주고받을 때 중간에 언젠가 문제가 발생할 여지가 있기 때문에
  // 백엔드와 주고받는 기능이다 선언과 같이 Future를 작성해주기!
  Future<void> _handleSignup() async {
    // 백엔드 회원가입 API 호출
    // 성공 -> 자동 로그인과 함께 검사화면 이동
    // 실패 -> 에러메세지 로딩 해제
    if(!_validateName()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String name = _nameController.text.trim();
      final user = await ApiService.signup(name);

      if(mounted) {
        // Provider에 로그인 정보 저장.
        await context.read<AuthProvider>().login(user);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${user.userName}님, 회원가입이 완료되었습니다.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          )
        );

        context.go('/test', extra: name);
      }
    } catch(e) {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        leading: IconButton(
            onPressed: () => context.go('/'),
            icon: Icon(Icons.arrow_back),
        ),
      ),
      // SingleChildScrollView(
      //  child:Center(
      //    child:Container(
      //      child:Column(
      //        children: [회원가입에 필요한 UI]
      //      )
      //    )
      //  )
      body: SingleChildScrollView(
        child: Center(
          child: Container(  // Container 가 오면 가로/세로/패딩값 주기
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(   // Column 이 오면 mainAxisAlignment 반드시 사용
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add, size: 50, color: Colors.green),
                SizedBox(height: 50),

                Text(
                  'MBTI 검사 데이터 저장을 위해\n회원가입해주세요',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40),

                // 테두리를 만들 때 Container / SizedBox 사용
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameController,
                    enabled: !_isLoading, // 로딩 중에는 작성 불가 (활성화: true/false -> disabled 효과 적용)
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력해주세요.',
                      border: OutlineInputBorder(),
                      errorText: _errorText,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // 정규식으로 입력값 검증
                        // 만약 숫자가 보이면 -> '숫자는 입력할 수 없습니다.'
                        // 만약 한글/영어 이외 입력 -> '한글과 영어만 입력 가능합니다.'
                        if(RegExp(r'[0-9]').hasMatch(value)) {
                          _errorText = "숫자는 입력할 수 없습니다.";
                          // 가-힣 : 자음/모음 형태의 글자는 사용 불가.
                          // ㄱ-힇 : 자음부터 모든 한글 사용 가능.
                          // ㅎ 을 작성했을 때는 우리 회사가 원하는 한글이 아님. '홍'과 같이 자모음 조합으로 이루어진 한글만 취급하겠다.
                        } else if(RegExp(r'[^가-힣a-zA-Z]').hasMatch(value)) {
                          _errorText = "한글과 영어만 입력 가능합니다.";
                        } else {
                          _errorText = null;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),

                // 회원가입 버튼
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup, // 로딩 중에는 버튼 비활성화 처리하여 여러 번 클릭과 같은 작업 미리 방지
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[400],
                    ),

                    child: _isLoading
                    ? SizedBox(
                      width:20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      '회원가입하기',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // 로그인 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('이미 계정이 있으신가요?'),
                    TextButton(
                        onPressed: _isLoading ? null : () => context.go('/login'),
                        child: Text('로그인하기'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 위젯 제거 시 리소스 해제
/// TextEditingController 메모리 누수 방지
@override
void dispose() {
  // TODO: TextEditingController 해제
  // 힌트: _nameController.dispose();
  // super.dispose();
}
