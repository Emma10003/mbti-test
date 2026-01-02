import 'package:flutter/material.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/loading_view.dart';
/*
* 과제: StatelessWidget 로 변경하기
*      ErrorView 추가, errorMessage = "검사 기록을 불러오는데 실패했습니다." or null
* */
class ResultDetailScreen extends StatefulWidget {
  /*
    GoRoute(
          path: '/history',
          builder: (context, state) {
            final userName = state.extra as String;
            return ResultDetailScreen(userName: userName,); <-- 여기서 userName을 넘겨줌
          }
      ),
      /history 라는 명칭으로 ResultDetailScreen widget 화면을 보려고 할 때,
      메인에서 작성한 명칭의 유저 MBTI를 확인하고자 함.
      그러나 const ResultDetailScreen({super.key}); 와 같이 작성할 경우에는
      기본 생성자이며, 매개변수 데이터를 전달받는 생성자가 아니기 때문에
      main.dart 에서 작성한 사용자명을 전달받지 못하는 상황.

      Java와 다르게, 생성자를 기본생성자/매개변수생성자 등 다수의 생성자를 만들 경우
      반드시 생성자마다 명칭을 다르게 설정한다.
      보통은 클래스이름.기본생성자({super.key});
            클래스이름.매개변수생성자({super.key}, required this.전달받아_사용할_변수명});
   */
  //
  final String userName;  // main에서 전달받을 매개변수를 이 스크린에서 미리 상수로 선언.
  const ResultDetailScreen({super.key, required this.userName});

  @override  // 화면상태와 화면에서 상태 변경을 위한 위젯을 구분하여 만든 후 사용.
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  // 변수 선언, 기능 선언을 주로 작성.
  List<Result> results = [];
  bool isLoading = true;

  @override  // 기본적으로 초기 상태를 생성하면서, 추가적으로 호출할 기능도 함께 작성하기 위해 ovverride.
  void initState() {
    super.initState();
    loadResults();
  }

  // 유저 이름에 따른 결과
  void loadResults() async {
    // apiService 에서 만든 기능 호출하여 백엔드 결과를 가져오는 기능.
    try {
      // 그냥 userName XXX, ResultDetailScreen extends StatefulWidget(즉 위젯)에서 작성한 userName!!
      // data : 지역변수 -> loadResults() 안에서만 사용할 수 있는 변수. (함수 밖에서는 소멸)
      final data = await ApiService.getResultsByUserName(widget.userName);

      setState(() {
        // results : 전역변수로, Widget build 에 접근할 수 있는 변수공간.
        results = data;  // 백엔드에서 가져온 데이터를 전역변수에 담아서 변수 상태 변경
        isLoading = false;
      });
    } catch(e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결과를 불러오지 못했습니다.')),
      );
    }
  }


  // 변수 사용 가능, 선언 가능하지만 되도록이면 화면에 해당하는 UI 작성.
  // 상태 변경이 필요한 변수 사용.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 검사 기록'),
        leading: IconButton(
            onPressed: () => context.go('/'),
            icon: Icon(Icons.arrow_back)),
      ),
      body: isLoading
        ?  LoadingView(message: '결과를 불러오는 중입니다.')
        : results.isEmpty
          ? Center(
              child: Text('검사 기록이 없습니다.', style: TextStyle(fontSize: 18))
            )
          : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final r = results[index];
              return Card(
                child: ListTile(
                  // ex) 숙소 메인 이미지
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(r.resultType, style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // ex) 숙소이름
                  title: Text(r.resultType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  // ex) 예약 상세정보
                  subtitle: Text('E:${r.eScore} S:${r.sScore} T:${r.tScore} J:${r.jScore}\n'
                      'I:${r.iScore} N:${r.nScore} F:${r.fScore} P:${r.pScore}'),
                  // 아이콘은 단순히 클릭하면 보인다는 걸 표시하는 모형
                  trailing: Icon(Icons.arrow_forward_ios),
                  // 한 줄의 어떤 곳을 선택하더라도 세부 정보를 확인할 수 있는 모달팝업 띄우기
                  // ex) 예약 세부내용이 담긴 모달창
                  // 공유하기와 같은 세부 기능을 넣을 수 있지만
                  // 되도록이면 위젯으로 따로 생성 후 기능 설정하기
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(r.resultType),
                          content: Text('${r.typeName ?? r.resultType} \n\n ${r.description ?? "정보없음"}'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('닫기'),
                            ),
                          ],
                        )
                    );
                  },
                ),
              );
            }
          )
      );
  }
}

/*
개발자가 하나하나 직접적으로 목록을 작성해야 할 경우 사용.
-> 목차, 목록 리스트, 네비게이션 리스트 등.
ListView(
        children: [
          Text('ABCD'),
          Text('EFGH'),
          Text('IJKL'),
        ],

개발자가 DB에서 데이터를 동적으로 가져올 때는
ListView.builder(
  itemCount: 총 개수,
  itmeBuilder: (context, index){
    return Text('항목 $index');
  }
)

// ---------------------------------------------------------------
RangeError (length): Invalid value: Not in inclusive range 0..3: 4
-> 검사 기록이 비어있는지 확인해야 함.

// ListView.builder 는 itemCount가 없으면
// 내부 목록 리스트를 몇 개 만들어야 하는지 예상할 수 없으므로
// RangeError 발생.

->  검사기록이 0개인 경우에도 발생할 것.
    isEmpty인 경우도 해결 UI를 넣어줘야 한다.
 */