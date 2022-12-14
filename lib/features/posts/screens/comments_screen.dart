// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/features/feed/widgets/post_card.dart';

import 'package:komyuniti/features/posts/controller/post_controller.dart';
import 'package:komyuniti/features/posts/widgets/comment_card.dart';
import 'package:komyuniti/models/post_model.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  if (!isGuest)
                  TextField(
                    onSubmitted: (val) => addComment(data),
                    controller: commentController,
                    decoration: InputDecoration(
                        hintText: 'What are your thoughts?',
                        hintStyle: TextStyle(fontSize: 13.sp),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.all(18.w)),
                    // maxLength: 21,
                    // maxLines: 3,
                  ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final comment = data[index];
                                return CommentCard(comment: comment);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) {
                          if (kDebugMode) print(error);
                          return ErrorText(error: error.toString());
                        },
                        loading: () => const Loader(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
