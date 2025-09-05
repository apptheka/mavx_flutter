import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart'; 

class SearchBarIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchBarIcon({super.key, this.onTap, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: IconButton(onPressed: onTap, icon: Image.asset(IconAssets.search, width: 25, height: 25,color: Colors.white,)),
    );
  }
}
