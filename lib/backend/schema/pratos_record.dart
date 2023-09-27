import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '../../conf_project/util.dart';

class PratosRecord extends FirestoreRecord {
  PratosRecord._(
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

  // "preco" field.
  double? _preco;
  double get preco => _preco ?? 0.0;
  bool hasPreco() => _preco != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    _desc = snapshotData['desc'] as String?;
    _img = snapshotData['img'] as String?;
    _preco = castToType<double>(snapshotData['preco']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('pratos')
          : FirebaseFirestore.instance.collectionGroup('pratos');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('pratos').doc();

  static Stream<PratosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PratosRecord.fromSnapshot(s));

  static Future<PratosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PratosRecord.fromSnapshot(s));

  static PratosRecord fromSnapshot(DocumentSnapshot snapshot) => PratosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PratosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PratosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PratosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PratosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPratosRecordData({
  String? nome,
  String? desc,
  String? img,
  double? preco,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'desc': desc,
      'img': img,
      'preco': preco,
    }.withoutNulls,
  );

  return firestoreData;
}

class PratosRecordDocumentEquality implements Equality<PratosRecord> {
  const PratosRecordDocumentEquality();

  @override
  bool equals(PratosRecord? e1, PratosRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.desc == e2?.desc &&
        e1?.img == e2?.img &&
        e1?.preco == e2?.preco;
  }

  @override
  int hash(PratosRecord? e) =>
      const ListEquality().hash([e?.nome, e?.desc, e?.img, e?.preco]);

  @override
  bool isValidKey(Object? o) => o is PratosRecord;
}
