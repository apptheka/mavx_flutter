import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseGetView<T> extends GetView<T> {
  const BaseGetView({super.key});

  @override
  Widget build(BuildContext context) {
    return myBuild(context);
  }

  Widget myBuild(BuildContext context);
} 