import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  runApp(const RentalApp());
}

class RentalApp extends StatelessWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Scaffold(
            body: Center(
              child: MainPage(sizingInformation: sizingInformation),
            ),
          );
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final SizingInformation sizingInformation;

  const MainPage({required this.sizingInformation});

  static const double baseWidth = 360;

  @override
  Widget build(BuildContext context) {
    final double scaleWidth =
        (sizingInformation.screenSize.width / baseWidth).clamp(0.8, 1.2);

    return Center(
      child: Container(
        width: baseWidth * scaleWidth,
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 10),
            _buildSearchBox(),
            const SizedBox(height: 15),
            _buildItemListContent(),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  // 헤더 및 필터 버튼 빌드
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '뭐든 대여',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'BM Dohyeon',
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              _buildFilterButton('거주지'),
              const SizedBox(width: 10),
              _buildFilterButton('카테고리'),
            ],
          ),
        ],
      ),
    );
  }

  // 필터 버튼 빌드
  Widget _buildFilterButton(String title) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF079702).withOpacity(0.95),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'BM Dohyeon',
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // 검색 창 빌드
  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF079702).withOpacity(0.95),
          ),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '검색',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.search, size: 24, color: Color(0xFF079702)),
            ),
          ],
        ),
      ),
    );
  }

  // 아이템 리스트 빌드
  Widget _buildItemListContent() {
    return const Expanded(
      child: SingleChildScrollView(
        child: ItemListPage(),
      ),
    );
  }

  // 하단 네비게이션 바 빌드
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF079702).withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton('홈', Icons.home),
          _buildNavButton('좋아요', Icons.favorite),
          _buildNavButton('채팅', Icons.chat),
          _buildNavButton('마이페이지', Icons.person),
        ],
      ),
    );
  }

  // 네비게이션 버튼 빌드
  static Widget _buildNavButton(String title, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Colors.white),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// 아이템 리스트 페이지
class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  late Future<List<Map<String, dynamic>>> itemList;

  @override
  void initState() {
    super.initState();
    itemList = _fetchItemList();
  }

  // 더미 데이터를 이용해 아이템 리스트를 가져오는 함수
  Future<List<Map<String, dynamic>>> _fetchItemList() async {
    return List.generate(10, (index) {
      return {
        'title': '아이템 제목 $index',
        'location': '서울',
        'rental_price': '5000원',
        'deposit': '10000원',
        'available': index % 2 == 0 ? '대여 가능' : '대여중',
        'image': null,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: itemList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final items = snapshot.data!;
          return _buildItemList(items);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  // 아이템 리스트 빌드
  Widget _buildItemList(List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemCard(item);
        },
      ),
    );
  }

  // 각 아이템 카드 빌드
  Widget _buildItemCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                _buildItemImage(), // 이미지 박스 크기를 넓게 조정
                const SizedBox(width: 20), // 텍스트와 이미지 사이의 간격 증가
                _buildItemInfo(item), // 텍스트를 더 오른쪽으로 배치
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: _buildItemAvailability(item['available']),
            ),
          ],
        ),
      ),
    );
  }

  // 아이템 이미지 빌드
  Widget _buildItemImage() {
    return Container(
      width: 110, // 기존보다 가로 크기 증가
      height: 110, // 세로 크기도 조정
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Center(child: Text('물품 사진')),
    );
  }

  // 아이템 정보 빌드
  Widget _buildItemInfo(Map<String, dynamic> item) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title'],
            style: const TextStyle(
              fontFamily: 'BM Dohyeon',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text('대여 장소: ${item['location']}'),
          const SizedBox(height: 5),
          Text('1일 대여료: ${item['rental_price']}'),
          const SizedBox(height: 5),
          Text('보증금: ${item['deposit']}'),
        ],
      ),
    );
  }

  // 아이템 대여 가능 여부 표시
  Widget _buildItemAvailability(String availability) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: availability == '대여 가능' ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        availability,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
