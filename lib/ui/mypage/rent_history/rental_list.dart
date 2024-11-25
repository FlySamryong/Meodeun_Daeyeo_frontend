import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/service/member/member_service.dart';
import 'rental_history_item.dart';

class RentalListWidget extends StatefulWidget {
  const RentalListWidget({super.key});

  @override
  State<RentalListWidget> createState() => _RentalListWidgetState();
}

class _RentalListWidgetState extends State<RentalListWidget> {
  final MemberService _memberService = MemberService();
  late Future<List<dynamic>> _rentalListFuture;

  @override
  void initState() {
    super.initState();
    _rentalListFuture = _memberService.fetchRentalList(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _rentalListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('대여 내역이 없습니다.'));
        }

        final rentalList = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rentalList.length,
          itemBuilder: (context, index) {
            final rental = rentalList[index];
            return RentalHistoryItemWidget(
              title: rental['itemName'],
              location:
                  '${rental['location']['city']} ${rental['location']['district']} ${rental['location']['neighborhood']}',
              period: rental['period'],
              status: rental['status'],
            );
          },
        );
      },
    );
  }
}
