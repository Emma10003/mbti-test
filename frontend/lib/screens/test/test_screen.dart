import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:go_router/go_router.dart';

import '../../models/question_model.dart';

class TestScreen extends StatefulWidget {
  final String userName;
  const TestScreen({super.key, required this.userName});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // 변수 선언
  // 데이터 선언
  // 기능 선언
  List<Question> questions = [];  // 백엔드에서 가져온 질문들이 들어갈 배열
  int currentQuestion = 0;       // 인덱스가 0부터 시작하기 때문에 0으로 설정
  Map<int, String> answers = {}; // 답변 저장 {질문번호: 'A' or 'B'}
  bool isLoading = true;         // 백엔드 데이터를 가지고 올 동안 잠시 대기하는 로딩중

  // ctrl + O
  @override
  void initState() {
    super.initState();
    // 화면이 보이자마자 세팅할 것인데 백엔드 데이터 질문 가져오기
    loadQuestions();
  }

  // 질문 백엔드에서 불러오는 기능
  void loadQuestions() async {
    try {
      final data = await ApiService.getQuestions();
          setState(() {
            questions = data;
            isLoading = false;
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }


  /*
  // API로 교체.
  final List<Map<String, String>> questions = [
    {
      'text': '친구들과 노는 것이 좋다.',
      'optionA': '매우 그렇다 (E)',
      'optionB': '혼자 있는 게 좋다 (I)',
    },
    {
      'text': '계획을 세우는 것을 좋아한다.',
      'optionA': '계획적이다 (J)',
      'optionB': '즉흥적이다 (P)',
    }
  ];
*/

  // selectAnswer(String option)
  // 선택한 답변 저장
  // 다음 질문으로 넘어가고 12문제가 끝나면 결과 화면으로 이동
  void selectAnswer(String option) {
    setState(() {
      answers[questions[currentQuestion].id] = option;  // 답변 저장

      // DB에 존재하는 총 길이의 -1 까지의 수 보다 작을 경우
      // (index는 0부터 존재하기 때문에 총 길이의 -1 까지가 DB 데이터.)
      if(currentQuestion < questions.length - 1) {
        // 다음 질문으로 넘어가고
        currentQuestion++;
      }
      else {
        submitTest();
        // 결과 화면으로 이동
        // _showResult();  // 잠시 결과화면을 보여주는 함수 호출
        // screens 에 /result/result_screen 이라는 명칭으로
        // 폴더와 파일 생성 후, main에서 router 설정해준 다음에
        // _showResult() 대신 context.go("/result") 로 이동 설정할 수 있음.
        // main에서는 builder에 answers 결과까지 함께 전달.
      }
    });
  }

  // 결과를 백엔드에 저장하기
  void submitTest() async {
    try {
      final result = await ApiService.submitTest(widget.userName, answers);

      // mounted : 화면이 존재한다면 가능
      if(mounted) {
        context.go("/result", extra: {
          'userName': widget.userName,
          'resultType': result.resultType,
        });
      }
/*
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:Text('검사 완료'),
            content: Text(
              '${widget.userName}님음 ${result['resultType']} 입니다.'
            ),
            actions: [
              TextButton(
                  onPressed: () => context.go('/'),
                  child: Text('처음으로')
              )
            ],
          ));
*/

    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제출 실패했습니다.'))
      );
    }
  }

  // 결과 확인
  // void showResult(){}
  // 검사완료 후 검사결과 처음으로 이동하는 로직 작성.
  // 결과화면을 Go_Router 설정할 수도 있고,
  // 함수 호출을 이용하여 임시적으로 결과에 대한 창을 띄울 수 있다.
  // _showResult : private 함수로, 외부에서 사용할 수 없음.
  void _showResult() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('검사 완료'),
              content: Text(
                '${widget.userName}님의 답변: \n ${answers.toString()}'
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      context.go('/');  // 처음으로
                    },
                    child: Text('처음으로'))
              ]
        )
    );
  }



  // UI
  @override
  Widget build(BuildContext context) {
    // 백엔드에서 데이터를 가져오는 중인 경우 로딩 화면 보여주기
    if(isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('불러오는 중...')),
        body: Center(child: CircularProgressIndicator())
      );
    }


    int questionIndex = currentQuestion - 1;

    if(questionIndex >= questions.length) {
      questionIndex = questions.length - 1;
    }
    var q = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 검사'),
        leading: IconButton(
            onPressed: () => context.go('/'),
            icon: Icon(Icons.arrow_back),
        ),
      ),
      body:
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 진행도
              // ${변수명.내부속성명} -> 중괄호 사용
              // $변수명            -> 중괄호 사용 X
              Text(
                '질문 ${currentQuestion + 1} / ${questions.length}',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 20),

              // 진행 바
              LinearProgressIndicator(
                value: (currentQuestion + 1) / questions.length,
                minHeight: 10,
              ),
              SizedBox(height: 20),

              // 질문
              Text(
                /*
                만약에 데이터가 없을 경우에는 '질문 없음' 이라는 표기를 Text 내부에 사용
                questions[questionIndex]['text'] ?? '질문 없음',

                questions[questionIndex]['text']!,
                -> 'data가 null이 아니고 반드시 존재한다' 라는 표기를 작성

                questions[questionIndex]['text'] as String,
                 */
                q.questionText,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    onPressed: () => selectAnswer('A'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      q.optionA,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    onPressed: () => selectAnswer('B'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      q.optionB,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              )
            ],
          )
        )
    );
  }
}
