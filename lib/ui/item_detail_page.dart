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
      home: const ItemDetailScreen(),
    );
  }
}

// StatefulWidget으로 API 호출과 아이템 데이터를 로드하는 화면
class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Future<Map<String, dynamic>> itemDetails;

  @override
  void initState() {
    super.initState();
    itemDetails = _fetchItemDetails();
  }

  // API에서 아이템 세부 정보를 가져오는 함수
  Future<Map<String, dynamic>> _fetchItemDetails() async {
    // 기본 데이터
    return {
      'title': '기본 제목',
      'description': '기본 설명',
      'available': 'N/A',
      'rental_price': '5000',
      'deposit': '10000',
      'location': '서울',
      'lender_nickname': '기본 닉네임',
      'lender_location': '서울',
      'lender_manner_temp': '36.5',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Center(
            child: Container(
              width: 360 *
                  (sizingInformation.screenSize.width / 360).clamp(0.8, 1.2),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildAppTitle(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: itemDetails,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final data = snapshot.data!;
                            return ItemDetailUI(data: data);
                          } else {
                            return const Center(
                                child: Text('No data available'));
                          }
                        },
                      ),
                    ),
                  ),
                  _buildBottomNavBar(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 앱 제목
  Widget _buildAppTitle() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: const Text(
          '뭐든 대여',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'BM Dohyeon',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // 하단 네비게이션 바
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
          _buildNavBarButton('홈', Icons.home),
          _buildNavBarButton('좋아요', Icons.favorite),
          _buildNavBarButton('채팅', Icons.chat),
          _buildNavBarButton('마이페이지', Icons.person),
        ],
      ),
    );
  }

  // 하단 네비게이션 바의 버튼
  Widget _buildNavBarButton(String title, IconData icon) {
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

// StatelessWidget으로 아이템 세부 정보를 보여주는 UI
class ItemDetailUI extends StatelessWidget {
  final Map<String, dynamic> data;

  const ItemDetailUI({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildItemDetailBox(),
          const SizedBox(height: 20),
          _buildLenderInfoBox(),
          const SizedBox(height: 20),
          _buildActionButtons(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // 아이템 세부 정보를 보여주는 박스
  Widget _buildItemDetailBox() {
    return Container(
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
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildItemImage(),
          const SizedBox(height: 20),
          Text(
            data['description'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontFamily: 'BM Dohyeon',
            ),
          ),
          const SizedBox(height: 20),
          _buildItemInfo(),
        ],
      ),
    );
  }

  // 아이템 이미지를 보여주는 자리 표시자
  Widget _buildItemImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Text('물품 사진')),
    );
  }

  // 아이템 정보 세부 사항
  Widget _buildItemInfo() {
    return Column(
      children: [
        _buildDetailText('대여 가능 여부: ${data['available']}'),
        const SizedBox(height: 10),
        _buildDetailText('1일 대여료: ${data['rental_price']}원'),
        const SizedBox(height: 10),
        _buildDetailText('보증금: ${data['deposit']}원'),
        const SizedBox(height: 10),
        _buildDetailText('거래 장소: ${data['location']}'),
      ],
    );
  }

  // 대여자 정보를 보여주는 박스
  Widget _buildLenderInfoBox() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '물품 등록자 정보',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'BM Dohyeon',
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildDetailText('닉네임: ${data['lender_nickname']}'),
          const SizedBox(height: 10),
          _buildDetailText('거주지: ${data['lender_location']}'),
          const SizedBox(height: 10),
          _buildDetailText('매너 온도: ${data['lender_manner_temp']}'),
        ],
      ),
    );
  }

  // 채팅 및 관심 목록 추가 버튼
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          icon: Icons.chat,
          label: '채팅하기',
          color: Colors.yellow,
        ),
        _buildActionButton(
          icon: Icons.favorite_border,
          label: '관심 목록 추가하기',
          color: Colors.red,
        ),
      ],
    );
  }

  // 커스텀 액션 버튼
  Widget _buildActionButton(
      {required IconData icon, required String label, required Color color}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'BM Dohyeon',
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        side: BorderSide(color: const Color(0xFF079702), width: 2),
      ),
    );
  }

  // 박스로 둘러싸인 일반 텍스트
  Widget _buildDetailText(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'BM Dohyeon',
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
