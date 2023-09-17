import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/post_model.dart';

class HomeFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PostModel> fetchPost(String postID) async {
    final post = await _firestore.collection('posts').doc(postID).get();

    final productIDs = post['products'];

    final products = await _firestore.collection("products").where("id", whereIn: productIDs).get();

    final productModelList = products.docs.map((e) => ProductModel.fromJson(e.data())).toList();

    return PostModel.fromJson(post.data()!, productModelList);
  }
}
