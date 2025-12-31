import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// result 스크린에서 채팅을 하거나, 숫자값을 추가하는 등
// 실질적으로 화면 자체에서 변경되는 데이터는 없으므로
// StatelessWidget으로 사용하는 것도 가능하다.
class ResultScreen extends StatelessWidget {
  final String userName;
  final String resultType;

  const ResultScreen({
    super.key,
    required this.userName,
    required this.resultType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검사 결과'),
        automaticallyImplyLeading: false,  // 뒤로가기 버튼 숨김
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration,
                size: 100,
                color: Colors.amber,
              ),

              SizedBox(height: 30),

              Text(
                '검사완료',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 40),
              
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text('$userName님의 MBTI는'),
                    SizedBox(height: 10),
                    Text(
                      resultType,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text('입니다'),
                  ],
                ),
              ),
              SizedBox(height: 60),

              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(onPressed: () => context.go('/'), child: Text('처음으로')),
              )

            ],
          ),
        ),
      ),
    );
  }
}