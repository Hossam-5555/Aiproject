import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  // 1. جعل الكلاس Singleton لسهولة الاستدعاء من أي مكان
  FirestoreServices._();
  static final FirestoreServices instance = FirestoreServices._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة مستند بـ ID عشوائي
  Future<DocumentReference<Map<String, dynamic>>> postdata(
    String collectionName,
    Map<String, dynamic> data,
  ) async {
    try {
      // إضافة await لضمان إتمام العملية
      return await _firestore.collection(collectionName).add(data);
    } catch (e) {
      rethrow;
    }
  }

  /// حذف مستند عبر الـ ID
  Future<void> delete(String collectionName, String id) async {
    try {
      // إضافة await
      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// تحديث بيانات مستند معين
  Future<void> update(
    String collectionName,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collectionName).doc(id).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// جلب مستند واحد بواسطة الـ ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getdatabyid(
    String collectionName,
    String id,
  ) async {
    try {
      return await _firestore.collection(collectionName).doc(id).get();
    } catch (e) {
      rethrow;
    }
  }

  /// حفظ مستند مع تحديد الـ ID بنفسك (مثل الـ UID للمستخدم)
  Future<void> setdatabyid(
    String collectionName,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collectionName).doc(id).set(data);
    } catch (e) {
      rethrow;
    }
  }

  /// جلب كافة المستندات داخل Collection معين
 Stream<List<Map<String, dynamic>>> getdata(String collectionName) {
  return _firestore
      .collection(collectionName)
      .snapshots()
      .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
}
}