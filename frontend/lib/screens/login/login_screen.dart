import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
/*
로그인한 유저 이름이 테스트로 넘어가는지 확인
signup
스크린 생성
main route 추가
 */
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();

  String? _errorText;
  bool _isLoading = false;

  bool _validateName() {
    String name = _nameController.text.trim();

    if(name.isEmpty) {
      setState(() {
        _errorText = "이름을 입력해주세요.";
      });
      return false;
    }

    if(name.length < 2) {
      setState(() {
        _errorText = "이름은 최소 2글자 이상이어야 합니다.";
      });
      return false;
    }

    if(!RegExp(r'^[가-힣a-zA-Z]_$').hasMatch(name)) {
      setState(() {
        _errorText = "한글 또는 영문만 입력 가능합니다\n(특수문자, 숫자 불가).";
      });
    }

    setState(() {
      _errorText = null;
    });
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
        leading: IconButton(
            onPressed: () => context.go('/'),
            icon: Icon(Icons.arrow_back)
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 100, color: Colors.blue),

                SizedBox(height: 30),

                Text(
                  'MBTI 검사를 위해\n로그인해주세요',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40),

                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력해주세요.',
                      border: OutlineInputBorder(),
                      errorText: _errorText,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if(RegExp(r'[0-9]').hasMatch(value)) {
                          _errorText = '숫자는 입력할 수 없습니다.';
                        } else if(RegExp(r'[^가-힣a-zA-Z]').hasMatch(value)) {
                          _errorText = '한글과 영어만 입력 가능합니다.';
                        } else {
                          _errorText = null;
                        }
                      });
                    },
                  )
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_validateName()) {
                        String name = _nameController.text.trim();
                        context.go('/test', extra: name);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('로그인하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        )
      ),
    );
  }
}
