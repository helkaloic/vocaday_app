import 'package:flutter_test/flutter_test.dart';
import 'package:vocaday_app/app/constants/app_asset.dart';
import 'package:vocaday_app/app/utils/json_loader.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('should get map data when load json file', () async {
    final result = await JsonLoader.load(AppAssets.wordData);
    expect(result.isNotEmpty, true, reason: "Map should has value");
    expect(result.keys.first, "A");
  });
}