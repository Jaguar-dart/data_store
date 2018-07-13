library mongo_data_store.adapter;

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar_data_store/jaguar_data_store.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

class MongoDataStore<ModelType extends Idied<String>>
    extends DataStore<String, ModelType> {
  final String collectionName;

  final Serializer<ModelType> serializer;

  final mgo.Db db;

  final mgo.DbCollection collection;

  final mgo.WriteConcern writeConcern;

  MongoDataStore(this.serializer, this.collectionName, this.db,
      {this.writeConcern: mgo.WriteConcern.ACKNOWLEDGED})
      : collection = db.collection(collectionName);

  mgo.SelectorBuilder get _w => mgo.where;

  mgo.ObjectId _toOId(String id) => mgo.ObjectId.parse(id);

  mgo.SelectorBuilder _wId(String id) => _w.id(_toOId(id));

  Stream<ModelType> getAll() =>
      collection.find().map((Map doc) => serializer.fromMap(doc));

  Future<ModelType> getById(String id) async {
    final Map doc = await collection.findOne(_wId(id));
    return serializer.fromMap(doc);
  }

  Future<String> insert(ModelType object) async {
    final String id = new mgo.ObjectId().toHexString();
    object.id = id;
    await collection.insert(serializer.toMap(object),
        writeConcern: writeConcern);
    return id;
  }

  Future<int> updateById(String id, ModelType object) async {
    final Map rep = await collection.update(_wId(id), serializer.toMap(object),
        writeConcern: writeConcern);
    return rep["n"];
  }

  Future<int> updateMapById(String id, Map map) async {
    final upd = mgo.modify;
    map.forEach((k, v) {
      upd.set(k, v);
    });
    final Map rep =
        await collection.update(_wId(id), upd, writeConcern: writeConcern);
    return rep["n"];
  }

  Future<int> upsertById(String id, ModelType object) async {
    final Map rep = await collection.update(_wId(id), serializer.toMap(object),
        writeConcern: writeConcern, upsert: true);
    return rep["n"];
  }

  Future<int> removeById(String id) async {
    final Map rep =
        await collection.remove(_wId(id), writeConcern: writeConcern);
    return rep["n"];
  }

  Future<int> removeAll() async {
    final Map rep = await collection.remove(<String, dynamic>{});
    return rep["n"];
  }
}
