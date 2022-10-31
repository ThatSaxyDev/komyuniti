// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';

class BButton extends StatelessWidget {
  final double height;
  final double width;
  // final double padding;
  final double radius;
  final void Function()? onTap;
  final Color color;
  final Widget item;
  const BButton({
    Key? key,
    required this.height,
    required this.width,
    // required this.padding,
    required this.radius,
    required this.onTap,
    required this.color,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: color,
        ),
        child: Center(
          child: item,
        ),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  final double height;
  final double padding;
  final void Function()? onTap;
  final Color color;
  final Widget child;
  const TransparentButton({
    Key? key,
    required this.height,
    required this.padding,
    required this.onTap,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: color,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5.r),
              ),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
              vertical: padding,
            )),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class GButton extends ConsumerWidget {
  // final double height;
  // final double width;
  final double padding;
  // final double radius;
  // final void Function()? onTap;
  final Color color;
  final Widget item;
  const GButton({
    Key? key,
    // required this.height,
    // required this.width,
    this.padding = 30,
    // required this.radius,
    // required this.onTap,
    required this.color,
    required this.item,
  }) : super(key: key);

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 60,
      // width: width,
      child: ElevatedButton(
        onPressed: () => signInWithGoogle(context, ref),
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: padding),
        ),
        child: Center(
          child: item,
        ),
      ),
    );
  }
}
