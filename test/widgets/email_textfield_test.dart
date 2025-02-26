import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/components/my_text_field.dart';

void main() {
  testWidgets('Email TextField should accept input', (WidgetTester tester) async {
    // Tạo một TextEditingController để kiểm tra
    final controller = TextEditingController();

    // Xây dựng widget MyTextField
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyTextField(
            controller: controller,
            hintText: 'Enter email',
            obscureText: false,
          ),
        ),
      ),
    );

    // Tìm kiếm TextField
    final textFieldFinder = find.byType(TextField);

    // Kiểm tra xem TextField có tồn tại không
    expect(textFieldFinder, findsOneWidget);

    // Nhập vào trường email
    await tester.enterText(textFieldFinder, 'test@example.com');

    // Kiểm tra xem giá trị trong controller có đúng không
    expect(controller.text, 'test@example.com');
  });
}
