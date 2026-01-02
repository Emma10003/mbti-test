import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/widgets/score_bar.dart';
import 'package:go_router/go_router.dart';

// result 스크린에서 채팅을 하거나, 숫자값을 추가하는 등
// 실질적으로 화면 자체에서 변경되는 데이터는 없으므로
// StatelessWidget으로 사용하는 것도 가능하다.
// SingleChildScrollView -> 화면은 움직이는 화면이기 때문에 less 사용 불가

// 과제 : 로딩중 화면 메세지 없이 import 하여 개발자가 원하는 방식대로 추가
class ResultScreen extends StatefulWidget {
  final Result result;
  // final String userName;
  // final String resultType;
  // final int eScore;
  // final int iScore;
  // final int sScore;
  // final int nScore;
  // final int tScore;
  // final int fScore;
  // final int jScore;
  // final int pScore;

  const ResultScreen({
    super.key,
    required this.result,
    // required this.userName,
    // required this.resultType,
    // required this.eScore,
    // required this.iScore,
    // required this.sScore,
    // required this.nScore,
    // required this.tScore,
    // required this.fScore,
    // required this.jScore,
    // required this.pScore,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isLoading = true;

  // [기능] 링크 복사 함수 생성
  void _copyResultLink() {
    String shareUrl = 'https://나의도메인주소.com/result/${widget.result.id}';
    Clipboard.setData(ClipboardData(text: shareUrl));

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "나의 결과 링크가 복사되었습니다.",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),       // 2초 동안 보여주기
          behavior: SnackBarBehavior.floating,  // 둥둥 떠있는 스타일
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검사 결과'),
        automaticallyImplyLeading: false,  // 뒤로가기 버튼 숨김
      ),
      body: Center(
        /*
        SingleChildScrollVies -> ListView 교체
         */
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration,
                size: 100,
                color: Colors.amber,
              ),
              Text(
                '검사완료',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 40),
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text('${widget.result.userName}님의 MBTI는'),
                    SizedBox(height: 10),
                    Text(
                      widget.result.resultType,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text('입니다'),
                  ],
                ),
              ),
              SizedBox(height: 60),
              /*
              패딩 상하좌우 20
              글자색상 회색[50]
              모서리 둥글기 15
              실선 회색 300 계열
              Column은 crossAxisAlignment start
               */
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('상세 점수'),
                    SizedBox(height: 16,),
                    ScoreBar(
                      label1: 'E (외향)',
                      label2: 'I (내향)',
                      score1: widget.result.eScore,
                      score2: widget.result.iScore,
                    ),
                    ScoreBar(
                      label1: 'S (감각)',
                      label2: 'N (직관)',
                      score1: widget.result.sScore,
                      score2: widget.result.nScore,
                    ),
                    ScoreBar(
                      label1: 'T (사고)',
                      label2: 'F (감정)',
                      score1: widget.result.tScore,
                      score2: widget.result.fScore,
                    ),
                    ScoreBar(
                      label1: 'J (판단)',
                      label2: 'P (인식)',
                      score1: widget.result.jScore,
                      score2: widget.result.pScore,
                    ),
                  ],
                )
              ),

              SizedBox(height: 20),
              SizedBox(
                width: 300,
                height: 50,
                /*
                // 아이콘이나 글자가 child에 위치
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: Text('결과 링크 복사하기'),
                )

                // 글자와 아이콘을 사용하는 버튼 형식
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  icon: Icon(Icons.share),
                  label: Text('결과 링크 복사하기'),
                )
                 */
                child: ElevatedButton.icon(
                  // 생성자가 onPressed, icon, label이 required
                  // 나머지는 this - 필수로 작성하지 않아도 되는 생성자
                  onPressed: () => _copyResultLink(),
                  icon: Icon(Icons.share),
                  label: Text('결과 링크 복사하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black87,
                  )
                ),
              ),

              SizedBox(height: 20),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(onPressed: () => context.go('/'), child: Text('처음으로')),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}