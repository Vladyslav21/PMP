import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potopa_pmp_laba_1/person.dart';

import '../lib/details.dart';

void main() {
  testWidgets('DetailsScreen has a title and position', (tester) async {
    await tester.pumpWidget(const MaterialApp(home:const DetailsScreen(person: Person("Will Bankman", "QA Engineer"),)));

    final titleFinder = find.text('Will Bankman');
    final messageFinder = find.text('QA Engineer');

    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}
