library example.data_store.simple;

import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar_mongo_data_store/jaguar_mongo_data_store.dart';
import '../../example/common/model.dart';

import 'package:test/test.dart';

final String kMongoUrl = "mongodb://localhost:27018/example";

main() async {
  group("MongoDataStore", () {
    mgo.Db db;
    setUpAll(() async {
      // Create and open a connection to mongo
      db = new mgo.Db(kMongoUrl);
      await db.open();
    });

    tearDownAll(() async {
      await db.close();
      db = null;
    });

    test("Insert & GetAll", () async {
      // Create a mongo store
      MongoDataStore<Post> store =
          new MongoDataStore<Post>(mongoSerializer, "posts", db);

      // Start fresh by deleting all previous documents
      await store.removeAll();

      expect(await (await store.getAll()).toList(), hasLength(0));

      // Insert a post and receive the ID of the inserted document
      final String post1Id =
          await store.insert(new Post.buildNoId("title1", "message1", 5));

      // Insert another post and receive the ID of the inserted document
      final String post2Id =
          await store.insert(new Post.buildNoId("title2", "message2", 10));

      // Get all posts in collection
      final List<Post> posts = await (await store.getAll()).toList();
      expect(posts, hasLength(2));
      expect(posts[0], new Post.build(post1Id, "title1", "message1", 5));
      expect(posts[1], new Post.build(post2Id, "title2", "message2", 10));
    });

    test("GetById", () async {
      // Create a mongo store
      MongoDataStore<Post> store =
          new MongoDataStore<Post>(mongoSerializer, "posts", db);

      // Start fresh by deleting all previous documents
      await store.removeAll();

      expect(await (await store.getAll()).toList(), hasLength(0));

      // Insert a post and receive the ID of the inserted document
      final String post1Id =
          await store.insert(new Post.buildNoId("title1", "message1", 5));

      // Insert another post and receive the ID of the inserted document
      final String post2Id =
          await store.insert(new Post.buildNoId("title2", "message2", 10));

      // Get a post by ID
      final post1 = await store.getById(post1Id);
      expect(post1, new Post.build(post1Id, "title1", "message1", 5));

      // Get a post by ID
      final post2 = await store.getById(post2Id);
      expect(post2, new Post.build(post2Id, "title2", "message2", 10));
    });

    test("Update", () async {
      // Create a mongo store
      MongoDataStore<Post> store =
          new MongoDataStore<Post>(mongoSerializer, "posts", db);

      // Start fresh by deleting all previous documents
      await store.removeAll();

      expect(await (await store.getAll()).toList(), hasLength(0));

      // Insert a post and receive the ID of the inserted document
      final String post1Id =
          await store.insert(new Post.buildNoId("title1", "message1", 5));

      // Insert another post and receive the ID of the inserted document
      final String post2Id =
          await store.insert(new Post.buildNoId("title2", "message2", 10));

      // Get a post by ID
      final post1 = await store.getById(post1Id);
      expect(post1, new Post.build(post1Id, "title1", "message1", 5));

      // Update a post
      post1.likes = 25;
      await store.updateById(post1Id, post1);

      // Get the changed a post
      final post1Changed = await store.getById(post1Id);
      expect(post1Changed, new Post.build(post1Id, "title1", "message1", 25));

      // Get a post by ID
      final post2 = await store.getById(post2Id);
      expect(post2, new Post.build(post2Id, "title2", "message2", 10));
    });

    test("DeleteById", () async {
      // Create a mongo store
      MongoDataStore<Post> store =
          new MongoDataStore<Post>(mongoSerializer, "posts", db);

      // Start fresh by deleting all previous documents
      await store.removeAll();

      expect(await (await store.getAll()).toList(), hasLength(0));

      // Insert a post and receive the ID of the inserted document
      final String post1Id =
          await store.insert(new Post.buildNoId("title1", "message1", 5));

      // Insert another post and receive the ID of the inserted document
      final String post2Id =
          await store.insert(new Post.buildNoId("title2", "message2", 10));

      // Get all posts in collection
      final List<Post> posts = await (await store.getAll()).toList();
      expect(posts, hasLength(2));
      expect(posts[0], new Post.build(post1Id, "title1", "message1", 5));
      expect(posts[1], new Post.build(post2Id, "title2", "message2", 10));

      // Delete a post
      await store.removeById(post2Id);

      // Get all posts in collection
      final List<Post> postsAfterDelete = await (await store.getAll()).toList();
      expect(postsAfterDelete, hasLength(1));
      expect(postsAfterDelete[0],
          new Post.build(post1Id, "title1", "message1", 5));
    });

    test("DeleteAll", () async {
      // Create a mongo store
      MongoDataStore<Post> store =
          new MongoDataStore<Post>(mongoSerializer, "posts", db);

      // Start fresh by deleting all previous documents
      await store.removeAll();

      expect(await (await store.getAll()).toList(), hasLength(0));

      // Insert a post and receive the ID of the inserted document
      final String post1Id =
          await store.insert(new Post.buildNoId("title1", "message1", 5));

      // Insert another post and receive the ID of the inserted document
      final String post2Id =
          await store.insert(new Post.buildNoId("title2", "message2", 10));

      // Get all posts in collection
      final List<Post> posts = await (await store.getAll()).toList();
      expect(posts, hasLength(2));
      expect(posts[0], new Post.build(post1Id, "title1", "message1", 5));
      expect(posts[1], new Post.build(post2Id, "title2", "message2", 10));

      // Delete a post
      await store.removeAll();

      // Get all posts in collection
      final List<Post> postsAfterDelete = await (await store.getAll()).toList();
      expect(postsAfterDelete, hasLength(0));
    });
  });
}
