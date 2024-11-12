import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final String selectedCategory;
  final String selectedCity;
  final String selectedDistrict;
  final String selectedDong;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onDistrictChanged;
  final ValueChanged<String> onDongChanged;

  const FilterWidget({
    required this.selectedCategory,
    required this.selectedCity,
    required this.selectedDistrict,
    required this.selectedDong,
    required this.onCategoryChanged,
    required this.onCityChanged,
    required this.onDistrictChanged,
    required this.onDongChanged,
    Key? key,
  }) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  /// 카테고리 및 위치 데이터를 FilterWidget 내부에서 직접 정의
  final List<String> _categories = ["전자제품", "의류", "도서"];
  final Map<String, Map<String, List<String>>> _locations = {
    "서울시": {
      "강남구": ["역삼동", "청담동"],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildDropdownButton(
            value: widget.selectedCategory,
            items: _categories,
            onChanged: widget.onCategoryChanged,
          ),
          const SizedBox(width: 8),
          _buildDropdownButton(
            value: widget.selectedCity,
            items: _locations.keys.toList(),
            onChanged: widget.onCityChanged,
          ),
          const SizedBox(width: 8),
          _buildDropdownButton(
            value: widget.selectedDistrict,
            items: _locations[widget.selectedCity]?.keys.toList() ?? [],
            onChanged: widget.onDistrictChanged,
          ),
          const SizedBox(width: 8),
          _buildDropdownButton(
            value: widget.selectedDong,
            items:
                _locations[widget.selectedCity]?[widget.selectedDistrict] ?? [],
            onChanged: widget.onDongChanged,
          ),
        ],
      ),
    );
  }

  /// 공통적인 DropdownButton 생성 함수
  Widget _buildDropdownButton({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      dropdownColor: Colors.white,
      focusColor: Colors.transparent,
    );
  }
}
