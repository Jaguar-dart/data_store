library models;

import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_serializer_mongo/jaguar_serializer_mongo.dart';
import 'package:jaguar_data_store/jaguar_data_store.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'model.jser.dart';

class Post implements Idied<String> {
  String id;

  String title;

  String message;

  int likes;

  Post();

  Post.build(this.id, this.title, this.message, this.likes);

  Post.buildNoId(this.title, this.message, this.likes);

  String toString() =>
      "Post(id: $id, title: $title, message: $message, likes: $likes)";

  bool operator ==(object) {
    if (object is! Post) return false;

    final Post post = object as Post;

    if (id != post.id) return false;
    if (title != post.title) return false;
    if (message != post.message) return false;
    if (likes != post.likes) return false;

    return true;
  }
}

@GenSerializer()
class PostSerializer extends Serializer<Post> with _$PostSerializer {}

@GenSerializer(fields: const {
  'id': const EnDecode(alias: '_id', processor: const MongoId())
})
class MongoPostSerializer extends Serializer<Post> with _$MongoPostSerializer {}

final PostSerializer serializer = new PostSerializer();

final MongoPostSerializer mongoSerializer = new MongoPostSerializer();
