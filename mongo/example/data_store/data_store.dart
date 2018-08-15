library example.data_store.simple;

import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar_mongo_data_store/jaguar_mongo_data_store.dart';
import '../common/model.dart';

final String kMongoUrl = "mongodb://localhost:27018/example";

main() async {
  // Create and open a connection to mongo
  final db = new mgo.Db(kMongoUrl);
  await db.open();

  // Create a mongo store
  final store = MongoDataStore<Post>(mongoSerializer, "posts", db);

  // Start fresh by deleting all previous documents
  await store.removeAll();

  // Insert a post and receive the ID of the inserted document
  final String post1Id =
      await store.insert(new Post.buildNoId("title1", "message1", 5));
  print(post1Id);

  // Insert another post and receive the ID of the inserted document
  final String post2Id =
      await store.insert(new Post.buildNoId("title2", "message2", 10));
  print(post2Id);

  // Get all posts in collection
  final List<Post> posts = await (await store.getAll()).toList();
  print(posts);

  // Get a post by ID
  final post1 = await store.getById(post1Id);
  print(post1);

  // Get another post by ID
  final post2 = await store.getById(post2Id);
  print(post2);

  // Update a post
  post1.likes = 25;
  await store.updateById(post1Id, post1);

  // Get a changed a post
  final post1Changed = await store.getById(post1Id);
  print(post1Changed);

  // Update a post
  await store.updateMapById(post1Id, {'likes': 55});

  // Get a changed a post
  final post1Changed2 = await store.getById(post1Id);
  print(post1Changed2);

  // Delete a post
  await store.removeById(post2Id);

  //Posts after delete
  final List<Post> postsAfterDelete = await (await store.getAll()).toList();
  print(postsAfterDelete);

  exit(0);
}
