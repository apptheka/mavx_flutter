import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool readOnly;

  const SearchBarWidget({super.key, this.onTap, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: AppTextField(
        readOnly: readOnly,
        onTap: onTap,
        hintText: 'Search projects',
        prefixIcon: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Image.asset(
              IconAssets.searchBlack,
              color: Colors.black,
              width: 18,
              height: 18,
            ),
          ),
      ),
    );
  }
}
