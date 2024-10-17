import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meodeundaeyeo/ui/favorite/favorite_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'bottom_nav_action.dart';

class FavoriteNavAction implements BottomNavAction {
  final SizingInformation sizingInformation;

  FavoriteNavAction(this.sizingInformation);

  @override
  void onTap(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FavoritesPage(sizingInformation: sizingInformation),
      ),
    );
  }
}
