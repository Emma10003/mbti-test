import 'package:flutter/material.dart';
import 'package:frontend/models/mbti_type_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/loading_view.dart';
import 'package:go_router/go_router.dart';

/*
* 과제: StatelessWidget 로 변경하기
*      ErrorView 추가, errorMessage = "유형 정보를 불러오는데 실패했습니다." or null
* */
class MbtiTypesScreen extends StatefulWidget {
  const MbtiTypesScreen({super.key});

  @override
  State<MbtiTypesScreen> createState() => _MbtiTypesScreenState();
}

class _MbtiTypesScreenState extends State<MbtiTypesScreen> {
  List<MbtiType> types = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTypes();
  }

  void loadTypes() async {
    try {
      final data = await ApiService.getAllMbtiTypes();
      setState(() {
        types = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MBTI 16가지 유형'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading
          ? LoadingView(message: '유형을 불러오는 중입니다.')
          : types.isEmpty
          ? Center(child: Text('유형 정보가 없습니다'))
          : GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2열 그리드
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          return Card(
            elevation: 3,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('${type.typeCode} - ${type.typeName}'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (type.description != null) ...[
                            Text('설명', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(type.description!),
                            SizedBox(height: 10),
                          ],
                          if (type.characteristics != null) ...[
                            Text('특징', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(type.characteristics!),
                            SizedBox(height: 10),
                          ],
                          if (type.strengths != null) ...[
                            Text('강점', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(type.strengths!),
                            SizedBox(height: 10),
                          ],
                          if (type.weaknesses != null) ...[
                            Text('약점', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(type.weaknesses!),
                            SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('닫기'),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      type.typeCode,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      type.typeName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
