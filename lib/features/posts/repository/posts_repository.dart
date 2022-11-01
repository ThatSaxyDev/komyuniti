import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:komyuniti/core/constants/firebase_constants.dart';
import 'package:komyuniti/core/failure.dart';
import 'package:komyuniti/core/providers/firebase_provider.dart';
import 'package:komyuniti/core/type_defs.dart';
import 'package:komyuniti/models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
