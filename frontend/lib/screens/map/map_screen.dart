import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:geolocator/geolocator.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 변수, 함수 선언 공간

  // 자료형으로 KakaoMapController 자료형을 사용할 것이며
  // 변수명 : _mapController 를 사용할 것이다.
  // 이 변수 내부에는 데이터가 존재하지 않으면 null(=?) 값으로 허용하겠다.
  // 에러 발생 방지.
  KakaoMapController? _mapController;
  // 위도, 경도로 나의 위치 private 변수로 가지고 있기.
  // 자료형으로 LatLng 객체를 사용할 것이며, 내부 데이터가 없으면 null 값으로 사용.
  LatLng? _currentPosition;


  @override
  void initState() {
    super.initState();
    _determinePosition();  // 우리가 만들 기능 - 화면을 시작할 때 위치 가져오기 자동 로딩.
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;  // 기기의 GPS가 켜져있는지 확인하는 기능을 담기 위해 준비한 변수 -> true/false
    LocationPermission permission;  // 우리 어플이 위치 정보를 봐도 되는 권한이 있는지 저장

    // Geolocator.isLocationServiceEnabled 에서 기기가 켜져있는지에 대한 여부를 저장.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // GPS 가 꺼져있으므로 나의 위치 가져오기 기능을 더 이상 진행 불가하여 후퇴
    if(!serviceEnabled) return;

    // 현재 우리 어플이 위치 권한을 가지고 있는지 상태 확인.
    // 허용됨, 거부됨, 이번만 허용, 어플이 실행 중일 때만 허용 등등...
    permission = await Geolocator.checkPermission();

    // 만약 권한이 거부 상태라면(denied)
    if(permission == LocationPermission.denied) {
      // requestPermission -> 사용자에게 위치 권한을 허용하시겠습니까? 시스템 팝업 띄우기 기능
      permission = await Geolocator.requestPermission();
      // 팝업창에서 사용자가 거부를 눌렀다면, 좌표 정보를 읽어올 수 없으므로 함수 종료.
      if(permission == LocationPermission.denied) return;
    }

    // GPS 접근 가능한 권한이 존재한다면 아래 코드 실행
    // 실제 위도와 경도 데이터를 가져옴, 가져온 위치를 position 이라는 변수공간 내부에 저장.
    // position = {"latitude" : 39.3242342, "longitude : 34.2322929, ...} 와 같은 데이터들이 내부에 저장될 것.
    Position position = await Geolocator.getCurrentPosition();
    print("position: $position");

    setState(() {
      // 위도 경도 객체로 변환하여 저장.
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold = .html 과 같이 한 페이지, 한 위젯을 나타냄.
    return Scaffold(
      appBar: AppBar(
        title: Text("내 위치 확인하기"),
      ),
      body: _currentPosition == null
        ? Center(child: CircularProgressIndicator())  // 위치 정보 가져오는 중
        : KakaoMap(
        onMapCreated: (controller) {
          _mapController = controller;
      },
         center: _currentPosition,  // 현재 위치를 중심으로 지도 열기
        markers: [
          Marker(markerId: 'my_location', latLng: _currentPosition!)
        ],
      )
    );
  }
}
