// GENERATED CODE - DO NOT MODIFY BY HAND

part of models;

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$PostSerializer implements Serializer<Post> {
  @override
  Map<String, dynamic> toMap(Post model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'message', model.message);
    setMapValue(ret, 'likes', model.likes);
    return ret;
  }

  @override
  Post fromMap(Map map) {
    if (map == null) return null;
    final obj = new Post();
    obj.id = map['id'] as String;
    obj.title = map['title'] as String;
    obj.message = map['message'] as String;
    obj.likes = map['likes'] as int;
    return obj;
  }
}

abstract class _$MongoPostSerializer implements Serializer<Post> {
  final _mongoId = const MongoId();
  @override
  Map<String, dynamic> toMap(Post model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, '_id', _mongoId.serialize(model.id));
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'message', model.message);
    setMapValue(ret, 'likes', model.likes);
    return ret;
  }

  @override
  Post fromMap(Map map) {
    if (map == null) return null;
    final obj = new Post();
    obj.id = _mongoId.deserialize(map['_id'] as ObjectId) as String;
    obj.title = map['title'] as String;
    obj.message = map['message'] as String;
    obj.likes = map['likes'] as int;
    return obj;
  }
}
