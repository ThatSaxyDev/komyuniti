import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:komyuniti/features/community/controller/communtiy_controller.dart';
import 'package:komyuniti/features/feed/widgets/post_card.dart';
import 'package:komyuniti/features/posts/controller/post_controller.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
          data: (communities) => ref.watch(userPostProvider(communities)).when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                  );
                },
                error:  (error, stackTrace) {
                  if (kDebugMode) print(error);
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
