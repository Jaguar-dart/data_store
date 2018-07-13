library example.data_store.simple;

import 'dart:io';
import 'dart:async';
import 'package:jaguar_mongo_data_store/resource.dart';
import 'common/model.dart';
import 'package:jaguar/jaguar.dart' hide Post;
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_data_store/client.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar_mongo/jaguar_mongo.dart';

final pool = MongoPool("mongodb://localhost:27017/example");

@Controller(path: '/api')
class ExampleApi {
  @IncludeHandler(path: '/post')
  final MongoResource s =
      new MongoResource('posts', serializer, mongoSerializer, pool: pool);
}

Future<Null> server() async {
  final server = Jaguar(port: 10000);

  server.add(reflect(ExampleApi()));

  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}

const String kAuthority = 'http://localhost:10000';

Future<Null> client() async {
  final client = new http.Client();
  final ResourceClient<String, Post> rC = new ResourceClient<String, Post>(
      client, serializer,
      authority: kAuthority, path: '/api/post');

  // Start fresh by deleting all previous documents
  print(await rC.removeAll());

  // Insert a post and receive the ID of the inserted document
  final String post1Id =
      await rC.insert(new Post.buildNoId("title1", "message1", 5));
  print(post1Id);

  // Insert another post and receive the ID of the inserted document
  final String post2Id =
      await rC.insert(new Post.buildNoId("title2", "message2", 10));
  print(post2Id);

  // Get all posts in collection
  final List<Post> posts = await rC.getAll();
  print(posts);

  // Get a post by ID
  final post1 = await rC.getById(post1Id);
  print(post1);

  // Get another post by ID
  final post2 = await rC.getById(post2Id);
  print(post2);

  // Update a post
  post1.likes = 25;
  await rC.update(post1);

  // Get a changed a post
  final post1Changed = await rC.getById(post1Id);
  print(post1Changed);

  // Update a post
  await rC.update(post1);

  // Get a changed a post
  final post1Changed2 = await rC.getById(post1Id);
  print(post1Changed2);

  // Delete a post
  await rC.removeById(post2Id);

  //Posts after delete
  final List<Post> postsAfterDelete = await rC.getAll();
  print(postsAfterDelete);
}

main() async {
  await server();
  await client();
  exit(0);
}
