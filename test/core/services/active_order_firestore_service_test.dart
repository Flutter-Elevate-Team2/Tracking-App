import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';

import 'active_order_firestore_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late ActiveOrderFirestoreService service;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDoc = MockDocumentReference<Map<String, dynamic>>();
    mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    service = ActiveOrderFirestoreService(mockFirestore);

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
  });

  group('ActiveOrderFirestoreService Tests', () {
    const driverId = 'driver_123';
    const orderId = 'order_456';

    test('saveActiveOrder should call set with correct data', () async {
      when(mockDoc.set(any)).thenAnswer((_) async => {});

      await service.saveActiveOrder(driverId, orderId);

      verify(mockCollection.doc(driverId)).called(1);
      verify(mockDoc.set({'orderId': orderId})).called(1);
    });

    test(
      'getActiveOrder should return orderId when exists on server',
      () async {
        when(mockDoc.get(any)).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(true);
        when(mockSnapshot.data()).thenReturn({'orderId': orderId});

        final result = await service.getActiveOrder(driverId);

        expect(result, orderId);
        verify(
          mockDoc.get(
            argThat(predicate((GetOptions o) => o.source == Source.server)),
          ),
        ).called(1);
      },
    );

    test(
      'getActiveOrder should fallback to cache when server fetch fails',
      () async {
        // 1. Mock server failure
        when(
          mockDoc.get(
            argThat(predicate((GetOptions o) => o.source == Source.server)),
          ),
        ).thenThrow(Exception('No internet'));

        // 2. Mock cache success
        when(
          mockDoc.get(argThat(isNull)),
        ).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(true);
        when(mockSnapshot.data()).thenReturn({'orderId': 'cached_order'});

        final result = await service.getActiveOrder(driverId);

        expect(result, 'cached_order');
        verify(mockDoc.get(any)).called(2);
      },
    );

    test('clearActiveOrder should call delete', () async {
      when(mockDoc.delete()).thenAnswer((_) async => {});

      await service.clearActiveOrder(driverId);

      verify(mockDoc.delete()).called(1);
    });

    test(
      'getActiveOrder returns null when doc does not exist anywhere',
      () async {
        when(mockDoc.get(any)).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(false);

        final result = await service.getActiveOrder(driverId);

        expect(result, isNull);
      },
    );
  });
}
