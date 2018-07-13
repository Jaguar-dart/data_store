# jaguar_data_store

A data store is a DB agnostic abstraction of CURD for a specific model/document/table. 

This library defines the abstract interfaces that must be implemented by the DB specific adapters.

## Examples

### Data store

```dart
main() async {
  // Create and open a connection to mongo
  final db = new mgo.Db(kMongoUrl);
  await db.open();

  // Create a mongo store
  MongoDataStore<Post> store =
      new MongoDataStore<Post>(mongoSerializer, "posts", db);

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
```

### Resource client

```dart
import 'dart:io';
import 'dart:async';
import 'package:jaguar_mongo_data_store/resource.dart';
import '../common/post/post.dart';
import 'package:jaguar/jaguar.dart' hide Post;
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_data_store/client.dart';
import 'package:http/http.dart' as http;

final String kMongoUrl = "mongodb://localhost:27017/example";

@Api(path: '/api')
class ExampleApi {
  @IncludeApi(path: '/post')
  final MongoResource s =
      new MongoResource(kMongoUrl, 'posts', serializer, mongoSerializer);
}

Future<Null> server() async {
  final server = new Jaguar();
  server.addApi(reflect(new ExampleApi()));
  await server.serve();
}

const String kAuthority = 'http://localhost:8080';

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
```