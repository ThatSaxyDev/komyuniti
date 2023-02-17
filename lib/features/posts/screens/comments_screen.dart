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
import 'package:komyuniti/shared/app_texts.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';

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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Post',
        ),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    PostCard(post: data),
                    Spc(h: 15.h),
                    if (!isGuest)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: TextField(
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
                      ),
                    ref.watch(getPostCommentsProvider(widget.postId)).when(
                          data: (data) {
                            if (data.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 30.h, horizontal: 24.w),
                                child: const Text(
                                  'No comments here yet, be the first to comment!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                              );
                            }
                            return Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
                              child: Column(
                                children: data
                                    .map((e) => CommentCard(comment: e))
                                    .toList(),
                              ),
                            );
                            // return ListView.builder(
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   // physics: const AlwaysScrollableScrollPhysics(
                            //   //     parent: BouncingScrollPhysics()),
                            //   itemCount: data.length,
                            //   itemBuilder: (context, index) {
                            //     final comment = data[index];
                            //     return CommentCard(comment: comment);
                            //   },
                            // );
                          },
                          error: (error, stackTrace) {
                            if (kDebugMode) print(error);
                            return ErrorText(error: error.toString());
                          },
                          loading: () => const Loader(),
                        ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
