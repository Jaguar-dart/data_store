library mongo_data_store.resource;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_data_store/jaguar_data_store.dart';
import 'mongo_data_store.dart';

@Controller()
class MongoResource<ModelType extends Idied<String>> {
  final MongoPool pool;

  final String collectionName;

  final Serializer<ModelType> jsonSerializer;

  final Serializer<ModelType> mongoSerializer;

  MongoDataStore<ModelType> createStore(mgo.Db db) =>
      MongoDataStore<ModelType>(mongoSerializer, collectionName, db);

  MongoResource(this.collectionName, this.jsonSerializer, this.mongoSerializer,
      {this.pool});

  Future<mgo.Db> _getDb(Context ctx) async {
    if (pool == null) {
      return ctx.getVariable<mgo.Db>();
    } else {
      return await pool.injectInterceptor(ctx);
    }
  }

  @Get()
  Future<Response<String>> getAll(Context ctx) async {
    mgo.Db db = await _getDb(ctx);
    final data = await createStore(db)
        .getAll()
        .map((ModelType m) => jsonSerializer.toMap(m))
        .toList();
    return Response.json(data);
  }

  @Get(path: '/:id')
  Future<Response<String>> getById(Context ctx) async {
    mgo.Db db = await _getDb(ctx);
    String id = ctx.pathParams['id'];
    final ModelType m = await createStore(db).getById(id);
    return Response.json(jsonSerializer.toMap(m));
  }

  @Post()
  Future<Response<String>> create(Context ctx) async {
    mgo.Db db = await _getDb(ctx);
    Map data = await ctx.bodyAsJsonMap();
    final ModelType m = jsonSerializer.fromMap(data);
    return Response.json(await createStore(db).insert(m));
  }

  @Put()
  Future<int> update(Context ctx) async {
    mgo.Db db = await _getDb(ctx);
    Map data = await ctx.bodyAsJsonMap();
    final ModelType m = jsonSerializer.fromMap(data);
    return await createStore(db).updateById(m.id, m);
  }

  @Put(path: '/:id')
  Future<int> updateMapById(Context ctx) async {
    mgo.Db db = await _getDb(ctx);
    final Map data = await ctx.bodyAsJsonMap();
    final String id = ctx.pathParams['id'];
    return await createStore(db).updateMapById(id, data);
  }

  @Delete(path: '/:id')
  Future<int> removeById(Context ctx) async =>
      createStore(await _getDb(ctx)).removeById(ctx.pathParams['id']);

  @Delete()
  Future<int> removeAll(Context ctx) async =>
      createStore(await _getDb(ctx)).removeAll();
}
