import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '../../conf_project/util.dart';

class RestaurantesRecord extends FirestoreRecord {
  RestaurantesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "desc" field.
  String? _desc;
  String get desc => _desc ?? '';
  bool hasDesc() => _desc != null;

  // "img" field.
  String? _img;
  String get img => _img ?? '';
  bool hasImg() => _img != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _desc = snapshotData['desc'] as String?;
    _img = snapshotData['img'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('restaurantes');

  static Stream<RestaurantesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RestaurantesRecord.fromSnapshot(s));

  static Future<RestaurantesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RestaurantesRecord.fromSnapshot(s));

  static RestaurantesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RestaurantesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RestaurantesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RestaurantesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RestaurantesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RestaurantesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRestaurantesRecordData({
  String? nome,
  String? desc,
  String? img,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'desc': desc,
      'img': img,
    }.withoutNulls,
  );

  return firestoreData;
}

class RestaurantesRecordDocumentEquality
    implements Equality<RestaurantesRecord> {
  const RestaurantesRecordDocumentEquality();

  @override
  bool equals(RestaurantesRecord? e1, RestaurantesRecord? e2) {
    return e1?.nome == e2?.nome && e1?.desc == e2?.desc && e1?.img == e2?.img;
  }

  @override
  int hash(RestaurantesRecord? e) =>
      const ListEquality().hash([e?.nome, e?.desc, e?.img]);

  @override
  bool isValidKey(Object? o) => o is RestaurantesRecord;
}
