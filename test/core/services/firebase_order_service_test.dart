import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';

import 'firebase_order_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late FirebaseOrderService service;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDoc = MockDocumentReference<Map<String, dynamic>>();
    mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    service = FirebaseOrderService(mockFirestore);

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
  });

  group('FirebaseOrderService Mockito Tests - 100% Coverage', () {
    const tOrderId = 'order_123';
    const tData = {'userId': 'user_1', 'deviceToken': 'token_abc'};

    test('getUserDataByOrderId success path', () async {
      when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn(tData);

      final result = await service.getUserDataByOrderId(tOrderId);

      expect(result, tData);
      verify(mockDoc.get()).called(1);
    });

    test(
      'getUserDataByOrderId returns null on failure (catch block)',
      () async {
        when(mockDoc.get()).thenThrow(FirebaseException(plugin: 'firestore'));

        final result = await service.getUserDataByOrderId(tOrderId);

        expect(result, isNull);
      },
    );

    test('uploadTrackingOrder calls set with correct parameters', () async {
      when(mockDoc.set(any, any)).thenAnswer((_) async => Future.value());

      await service.uploadTrackingOrder(tOrderId, tData);

      verify(mockDoc.set(tData, argThat(isA<SetOptions>()))).called(1);
    });

    test(
      'getTrackingOrderById returns null if document does not exist',
      () async {
        when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(false);

        final result = await service.getTrackingOrderById(tOrderId);

        expect(result, isNull);
      },
    );

    test('getTrackingOrderById returns model if exists', () async {
      final tModelData = {'id': tOrderId, 'lat': 30.0, 'lng': 31.0};

      when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn(tModelData);

      final result = await service.getTrackingOrderById(tOrderId);

      expect(result, isNotNull);
      expect(result, isA<OrderTrackingFirebaseModel>());
    });

    test('updateOrderLocation calls update correctly', () async {
      when(mockDoc.update(any)).thenAnswer((_) async => Future.value());

      await service.updateOrderLocation(tOrderId, tData);

      verify(mockDoc.update(tData)).called(1);
    });
  });
}
