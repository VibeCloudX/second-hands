import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '물품 목록',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '물품 목록'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> _items = [
    {'name': '노트북', 'description': '고성능 휴대용 컴퓨터'},
    {'name': '스마트폰', 'description': '다기능 모바일 기기'},
    {'name': '무선 이어폰', 'description': '편리한 블루투스 이어폰'},
    {'name': '스마트워치', 'description': '시계 기능과 건강 관리를 하나로'},
    {'name': '보조배터리', 'description': '이동 중에도 기기 충전'},
    {'name': '블루투스 스피커', 'description': '풍부한 사운드의 휴대용 스피커'},
    {'name': '외장하드', 'description': '대용량 파일 저장 장치'},
    {'name': '키보드', 'description': '인체공학적 디자인의 기계식 키보드'},
    {'name': '마우스', 'description': '정밀한 컨트롤이 가능한 게이밍 마우스'},
    {'name': '태블릿', 'description': '엔터테인먼트와 작업을 위한 대화면 기기'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  item['name']![0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                item['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['description']!),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 아이템 탭 시 동작 (예: 상세 페이지로 이동)
              },
            ),
          );
        },
      ),
    );
  }
}
