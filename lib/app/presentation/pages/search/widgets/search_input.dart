import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart' as search;
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';

class SearchInput extends GetView<search.SearchPageController> {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: AppTextField( 
        onChanged: controller.setQuery,
        hintText: 'Search by title, company, location or tag',
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