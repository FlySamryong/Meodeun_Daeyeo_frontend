import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../item/item_detail_page.dart';

class ItemListWidget extends StatelessWidget {
  final SizingInformation sizingInformation;

  const ItemListWidget({super.key, required this.sizingInformation});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchItemList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(
                        sizingInformation: sizingInformation,
                      ),
                    ),
                  );
                },
                child: _buildItemCard(items[index]),
              );
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  // 임시 데이터를 반환하는 메서드
  Future<List<Map<String, dynamic>>> _fetchItemList() async {
    await Future.delayed(const Duration(seconds: 1));

    // 임시 데이터 목록 생성
    return List.generate(10, (index) {
      return {
        'title': '아이템 제목 $index',
        'location': '서울',
        'rental_price': '${(index + 1) * 1000}원',
        'deposit': '${(index + 1) * 5000}원',
        'available': index % 2 == 0 ? '대여 가능' : '대여중',
        'image': null,
      };
    });
  }

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
                _buildItemImage(),
                const SizedBox(width: 20),
                _buildItemInfo(item),
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

  Widget _buildItemImage() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Center(child: Text('물품 사진')),
    );
  }

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
