import 'package:flutter_test/flutter_test.dart';
import 'package:reel_views/app/app.dart';


void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
  
    });
  });
}
