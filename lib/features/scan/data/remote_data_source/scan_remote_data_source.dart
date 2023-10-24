import 'package:boycott_pro/common/helper/date_time.dart';
import 'package:boycott_pro/common/services/firebase_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IScanRemoteDataSource {
  Future<DocumentReference<Map<String, dynamic>>> newProducts(
      String productName, String fcm);
}

class ScanRemoteDataSource implements IScanRemoteDataSource {
  @override
  Future<DocumentReference<Map<String, dynamic>>> newProducts(
          String productName, String fcm) async =>
      await FirebaseCollections.instance.addProductFR
          .add(
            {
              'FCM': fcm,
              'productName': productName,
              'createAt': parseDateTimeToString(DateTime.now()),
            },
          )
          .then((DocumentReference<Map<String, dynamic>> value) => value)
          .catchError((e) => throw e);
}
