import 'dart:async';
import 'package:jaguar_common/jaguar_common.dart';

abstract class DataStore<IdType, ModelType extends Idied<IdType>> {
  /// Returns a stream of all records
  FutureOr<Stream<ModelType>> getAll();

  /// Returns a single record by id [id]
  FutureOr<ModelType> getById(IdType id);

  /// Inserts a new record [object]
  FutureOr<IdType> insert(ModelType object);

  /// Updates the record with id [id] with the data [object]
  FutureOr<int> updateById(IdType id, ModelType object);

  /// Updates the record with id [id] with the data [object]
  FutureOr<int> updateMapById(IdType id, Map map);

  /// Deletes a record by id [id]
  FutureOr<int> removeById(IdType id);

  FutureOr<int> removeAll();
}

abstract class DataStoreOffsetPaginated<IdType, ModelType extends Idied<IdType>>
    implements DataStore<IdType, ModelType> {
  /// Returns a stream of maximum [count] number of records after the offset [offset]
  Stream<ModelType> getPaginated(int offset, int count);
}

abstract class DataStoreIdPaginated<IdType, ModelType extends Idied<IdType>>
    implements DataStore<IdType, ModelType> {
  /// Returns a Stream of maximum [count] number of records after the id [after]
  Stream<ModelType> getPaginated(IdType after, int count);
}
