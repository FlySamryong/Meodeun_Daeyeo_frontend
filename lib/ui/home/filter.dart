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
  final List<String> _categories = [
    "전자제품",
    "의류",
    "도서",
    "생활용품",
    "가구",
    "스포츠",
    "미용"
  ];
  final Map<String, Map<String, List<String>>> _locations = {
    "서울시": {
      "강남구": ["역삼동", "청담동", "삼성동"],
      "서초구": ["서초동", "방배동", "반포동"],
      "송파구": ["잠실동", "문정동", "가락동"]
    },
    "부산시": {
      "해운대구": ["우동", "재송동", "좌동"],
      "부산진구": ["부암동", "전포동", "당감동"],
      "사하구": ["하단동", "구평동", "다대동"]
    },
    "대구시": {
      "수성구": ["범어동", "지산동", "파동"],
      "달서구": ["월성동", "용산동", "상인동"],
      "중구": ["동인동", "대봉동", "남산동"]
    },
    "인천시": {
      "남동구": ["구월동", "만수동", "서창동"],
      "연수구": ["송도동", "연수동", "동춘동"],
      "부평구": ["부평동", "산곡동", "삼산동"]
    },
    "광주시": {
      "북구": ["문흥동", "운암동", "용봉동"],
      "남구": ["봉선동", "진월동", "주월동"],
      "서구": ["화정동", "치평동", "금호동"]
    },
    "대전시": {
      "유성구": ["봉명동", "노은동", "지족동"],
      "서구": ["둔산동", "갈마동", "월평동"],
      "중구": ["대흥동", "태평동", "문화동"]
    },
    "안양시": {
      "동안구": ["평촌동", "호계동", "범계동"],
      "만안구": ["안양동", "석수동", "박달동"]
    },
    "고양시": {
      "일산동구": ["백석동", "마두동", "장항동"],
      "덕양구": ["화정동", "행신동", "주교동"],
      "일산서구": ["탄현동", "대화동", "주엽동"]
    },
  };

  late String _currentCategory;
  late String _currentCity;
  late String _currentDistrict;
  late String _currentDong;

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.selectedCategory;
    _currentCity = widget.selectedCity;
    _currentDistrict = widget.selectedDistrict;
    _currentDong = widget.selectedDong;
  }

  void _onCityChanged(String newCity) {
    setState(() {
      _currentCity = newCity;
      _currentDistrict = _locations[newCity]?.keys.first ?? '';
      _currentDong = _locations[newCity]?[_currentDistrict]?.first ?? ''; // 초기화
    });
    widget.onCityChanged(newCity);
    widget.onDistrictChanged(_currentDistrict);
    widget.onDongChanged(_currentDong);
  }

  void _onDistrictChanged(String newDistrict) {
    setState(() {
      _currentDistrict = newDistrict;
      _currentDong = _locations[_currentCity]?[newDistrict]?.first ?? ''; // 초기화
    });
    widget.onDistrictChanged(newDistrict);
    widget.onDongChanged(_currentDong);
  }

  void _onDongChanged(String newDong) {
    setState(() {
      _currentDong = newDong;
    });
    widget.onDongChanged(newDong);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildDropdownButton(
            value: _currentCategory,
            items: _categories,
            onChanged: (newValue) {
              setState(() {
                _currentCategory = newValue;
              });
              widget.onCategoryChanged(newValue);
            },
          ),
          const SizedBox(width: 8),
          _buildDropdownButton(
            value: _currentCity,
            items: _locations.keys.toList(),
            onChanged: _onCityChanged,
          ),
          const SizedBox(width: 8),
          _buildDropdownButton(
            value: _currentDistrict,
            items: _locations[_currentCity]?.keys.toList() ?? [],
            onChanged: _onDistrictChanged,
          ),
          const SizedBox(width: 8),
          _buildDropdownButton(
            value: _currentDong,
            items: _locations[_currentCity]?[_currentDistrict] ?? [],
            onChanged: _onDongChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButton<String>(
      value: items.contains(value) ? value : items.first,
      items: items
          .toSet()
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (newValue) {
        if (newValue != null && items.contains(newValue)) {
          onChanged(newValue);
        }
      },
      dropdownColor: Colors.white,
      focusColor: Colors.transparent,
    );
  }
}
