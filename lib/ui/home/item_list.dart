import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../service/item/item_search_service.dart';
import '../item/detail/item_detail_page.dart';

class ItemListWidget extends StatefulWidget {
  final SizingInformation sizingInformation;
  final String category;
  final String city;
  final String district;
  final String neighborhood;
  final String keyword;

  const ItemListWidget({
    required this.sizingInformation,
    required this.category,
    required this.city,
    required this.district,
    required this.neighborhood,
    required this.keyword,
    super.key,
  });

  @override
  _ItemListWidgetState createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  final ItemService _itemService = ItemService();
  List<Map<String, dynamic>> _items = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    /// 초기 데이터 로드
    _fetchMoreItems();
  }

  @override
  void didUpdateWidget(covariant ItemListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 필터 값이나 검색어가 변경된 경우 새 데이터를 로드하도록 설정
    if (_shouldFetchData(oldWidget)) {
      _items.clear(); // 기존 데이터 초기화
      _currentPage = 0;
      _hasMore = true;
      _fetchMoreItems(); // 새 데이터 로드
    }
  }

  /// 필터 값 또는 검색어가 변경된 경우 새 데이터를 로드하도록 조건 체크
  bool _shouldFetchData(ItemListWidget oldWidget) {
    return oldWidget.category != widget.category ||
        oldWidget.city != widget.city ||
        oldWidget.district != widget.district ||
        oldWidget.neighborhood != widget.neighborhood ||
        oldWidget.keyword != widget.keyword;
  }

  /// 아이템 목록을 더 로드하는 함수
  Future<void> _fetchMoreItems() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });

    final result = await _itemService.fetchItems(
      context: context,
      page: _currentPage,
      category: widget.category,
      location: '${widget.city},${widget.district},${widget.neighborhood}',
      keyword: widget.keyword,
    );

    setState(() {
      _isLoading = false;
      if (result['items'] is List) {
        final List<Map<String, dynamic>> items =
            List<Map<String, dynamic>>.from(result['items']);
        if (items.isEmpty) {
          _hasMore = false; // 더 이상 데이터가 없으면 로딩 종료
        } else {
          _items.addAll(items); // 새 아이템을 기존 목록에 추가
          _currentPage++; // 페이지 번호 증가
        }
      } else {
        _hasMore = false; // 아이템이 없으면 로딩 종료
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (_shouldLoadMore(scrollInfo)) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _fetchMoreItems();
          });
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _items.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            // 로딩 상태를 숨기려면 빈 위젯 반환
            return const SizedBox.shrink();
          }
          return GestureDetector(
            onTap: () {
              _navigateToItemDetailPage(index);
            },
            child: _buildItemCard(_items[index]),
          );
        },
      ),
    );
  }

  /// 스크롤이 끝에 도달했을 때 더 많은 데이터를 로드할 조건
  bool _shouldLoadMore(ScrollNotification scrollInfo) {
    return scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
        !_isLoading &&
        _hasMore;
  }

  /// 아이템 상세 페이지로 이동하는 함수
  void _navigateToItemDetailPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(
          sizingInformation: widget.sizingInformation,
          itemId: _items[index]['id'],
        ),
      ),
    );
  }

  /// 아이템 카드를 구성하는 함수
  Widget _buildItemCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: _itemCardDecoration(), // 카드 스타일
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemImage(item['imageUrl']), // 이미지 부분
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItemTitleAndBadge(item), // 제목과 뱃지 부분
                    const SizedBox(height: 10),
                    _buildItemInfo(item), // 상세 정보
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 제목과 대여 가능 여부 뱃지를 한 줄에 배치하는 함수
  Widget _buildItemTitleAndBadge(Map<String, dynamic> item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          // 제목을 가로 공간에 맞춰 확장
          child: Text(
            item['name'] ?? 'Unknown Item',
            style: const TextStyle(
              fontFamily: 'BM Dohyeon',
              fontSize: 16,
              color: Colors.black,
            ),
            maxLines: 2, // 최대 2줄까지 표시
            overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 생략
          ),
        ),
        const SizedBox(width: 8),
        _buildItemAvailability(item['status']), // 대여 가능 여부 뱃지
      ],
    );
  }

  /// 아이템 정보를 표시하는 함수
  Widget _buildItemInfo(Map<String, dynamic> item) {
    final location = item['location'] as Map<String, dynamic>? ?? {};
    final city = location['city'] ?? '알 수 없는 도시';
    final district = location['district'] ?? '알 수 없는 구';
    final neighborhood = location['neighborhood'] ?? '알 수 없는 동';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('대여 장소: $city $district $neighborhood'),
        const SizedBox(height: 5),
        Text('1일 대여료: ${item['fee'] ?? '정보 없음'}'),
        const SizedBox(height: 5),
        Text('보증금: ${item['deposit'] ?? '정보 없음'}'),
      ],
    );
  }

  /// 아이템 대여 가능 여부를 표시하는 함수
  Widget _buildItemAvailability(String? available) {
    final String status = available ?? 'Unknown';
    final colorAndText = _getAvailabilityStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: colorAndText['color'],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        colorAndText['text'],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12, // 크기 조정
        ),
      ),
    );
  }

  /// 카드 스타일을 설정하는 함수
  BoxDecoration _itemCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          offset: const Offset(0, 2),
          blurRadius: 5,
        ),
      ],
    );
  }

  /// 아이템 이미지 빌더
  Widget _buildItemImage(String? imageUrl) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? const Center(
              child: Text('물품 사진', style: TextStyle(color: Colors.grey)))
          : null,
    );
  }

  /// 아이템의 대여 가능 상태에 따라 색상과 텍스트를 설정하는 함수
  Map<String, dynamic> _getAvailabilityStatus(String status) {
    switch (status) {
      case 'AVAILABLE':
        return {'color': Colors.green, 'text': '대여 가능'};
      case 'RENTED':
        return {'color': Colors.orange, 'text': '대여 중'};
      case 'UNAVAILABLE':
        return {'color': Colors.red, 'text': '대여 불가'};
      default:
        return {'color': Colors.grey, 'text': 'Unknown'};
    }
  }
}
