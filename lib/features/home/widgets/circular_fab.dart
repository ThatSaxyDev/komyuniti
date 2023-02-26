import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class CircularFAB extends ConsumerStatefulWidget {
  const CircularFAB({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CircularFABState();
}

const double buttonSize = 65.0;

void navigateToType(BuildContext context, String type) {
  Routemaster.of(context).push('/add-post/$type');
}

class _CircularFABState extends ConsumerState<CircularFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Icon getIcon(String name) {
    late Icon icon;
    switch (name) {
      case 'pen':
        if (controller.value != 1) {
          icon = const Icon(PhosphorIcons.pen);
        } else {
          icon = const Icon(PhosphorIcons.x);
        }
        break;

      case 'image':
        icon = const Icon(PhosphorIcons.image);
        break;

      case 'text':
        icon = const Icon(PhosphorIcons.textAa);
        break;

      case 'link':
       icon = const Icon(PhosphorIcons.linkSimpleHorizontal);
        break;
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(
        controller: controller,
      ),
      children: fabs.map(
        (e) {
          return buildFAB(
            getIcon(e.name),
            () {
              switch (e.name) {
                case 'image':
                  controller.reverse();
                  navigateToType(context, 'image');
                  break;

                case 'text':
                  controller.reverse();
                  navigateToType(context, 'text');
                  break;

                case 'link':
                  controller.reverse();
                  navigateToType(context, 'link');
                  break;

                case 'pen':
                  if (controller.status == AnimationStatus.completed) {
                    controller.reverse();
                  } else {
                    controller.forward();
                  }
                  break;
              }
            },
          );
        },
      ).toList(),
    );
  }

  Widget buildFAB(
    Icon icon,
    void Function()? onPressed,
  ) {
    final currenTheme = ref.watch(themeNotifierProvider);
    return SizedBox(
      height: buttonSize,
      width: buttonSize,
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: currenTheme.textTheme.bodyMedium!.color!,
        onPressed: onPressed,
        // () {
        //   if (controller.status == AnimationStatus.completed) {
        //     controller.reverse();
        //   } else {
        //     controller.forward();
        //   }
        // },
        elevation: 0,
        child: icon,
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;

  const FlowMenuDelegate({required this.controller})
      : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;

    final n = context.childCount;

    for (int i = 0; i < n; i++) {
      final isLastItem = i == context.childCount - 1;
      final setValue = (value) => isLastItem ? 0.0 : value;

      double theta = i * pi * 0.5 / (n - 2);
      double radius = 100.0 * controller.value;
      final x = xStart - setValue(radius * cos(theta));
      final y = yStart - setValue(radius * sin(theta));
      context.paintChild(
        i,
        transform: Matrix4.identity()
          ..translate(x, y, 0)
          ..translate(buttonSize / 2, buttonSize / 2)
          ..rotateZ(isLastItem ? 0.0 : 180 * (1 - controller.value) * pi / 100)
          ..scale(isLastItem ? 1.0 : max(controller.value, 0.5))
          ..translate(-buttonSize / 2, -buttonSize / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }
}

class FAB {
  final Icon icon;
  final String name;

  FAB(this.icon, this.name);
}

List<FAB> fabs = [
  FAB(const Icon(PhosphorIcons.image), 'image'),
  FAB(const Icon(PhosphorIcons.textAa), 'text'),
  FAB(const Icon(PhosphorIcons.linkSimpleHorizontal), 'link'),
  FAB(const Icon(PhosphorIcons.pen), 'pen'),
];
