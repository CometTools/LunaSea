import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'indexer.g.dart';

/// Hive database object containing all information on an indexer
@HiveType(typeId: 1, adapterName: 'IndexerHiveObjectAdapter')
class IndexerHiveObject extends HiveObject {
    /// Create a new [IndexerHiveObject] object with all fields set to empty values('', false, 0, {}, etc.)
    factory IndexerHiveObject.empty() => IndexerHiveObject(
        displayName: '',
        host: '',
        key: '',
        headers: {},
    );

    /// Create a new [IndexerHiveObject] from another [IndexerHiveObject] (deep-copy).
    factory IndexerHiveObject.fromIndexerHiveObject(IndexerHiveObject indexer) => IndexerHiveObject(
        displayName: indexer.displayName,
        host: indexer.host,
        key: indexer.key,
        headers: indexer.headers,
    );

    /// Create a new [IndexerHiveObject] from a map where the keys map 1-to-1.
    /// 
    /// - Does _not_ do type checking, and will throw an error if the type is invalid.
    /// - If the key is null, sets to the "empty" value
    factory IndexerHiveObject.fromMap(Map indexer) => IndexerHiveObject(
        displayName: indexer['displayName'] ?? '',
        host: indexer['host'] ?? '',
        key: indexer['key'] ?? '',
        headers: indexer['headers'] ?? {},
    );

    IndexerHiveObject({
        @required this.displayName,
        @required this.host,
        @required this.key,
        @required this.headers,
    });

    @override
    String toString() => toMap().toString();

    Map<String, dynamic> toMap() => {
        "displayName": displayName ?? '',
        "host": host ?? '',
        "key": key ?? '',
        "headers": headers ?? {},
    };

    @HiveField(0)
    String displayName;
    @HiveField(1)
    String host;
    @HiveField(2)
    String key;
    @HiveField(3)
    Map headers;
}
