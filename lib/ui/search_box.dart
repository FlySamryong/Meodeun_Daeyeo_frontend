import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearch;

  const SearchBox({
    required this.hintText,
    required this.onSearch,
    super.key,
  });

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF079702).withOpacity(0.95)),
        ),
        child: Row(
          children: [
            _buildTextField(),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  /// TextField 빌드 함수
  Widget _buildTextField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  /// 검색 버튼 빌드 함수
  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: IconButton(
        icon: const Icon(Icons.search, size: 24, color: Color(0xFF079702)),
        onPressed: () => widget.onSearch(_controller.text), // Trigger search
      ),
    );
  }
}
