import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/student_list_screen.dart';
import 'screens/student_detail_screen.dart';

void main() {
  runApp(const StudentManagerApp());
}

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Manager',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      // Định nghĩa routes tĩnh
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.studentList: (context) => const StudentListScreen(),
        AppRoutes.studentDetail: (context) => const StudentDetailScreen(),
        // Form screen đang dùng push(MaterialPageRoute) nên không cần khai báo ở đây
      },
      // onGenerateRoute: chuẩn bị cho các trường hợp route không có trong routes map
      onGenerateRoute: (settings) {
        // Ví dụ: sau này xử lý deep link /students/detail?id=S001 ở đây
        // Ở bài này ta chỉ log cho sinh viên thấy flow
        debugPrint('onGenerateRoute được gọi với: ${settings.name}');
        return null; // Trả null để MaterialApp dùng tiếp onUnknownRoute (nếu có)
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
