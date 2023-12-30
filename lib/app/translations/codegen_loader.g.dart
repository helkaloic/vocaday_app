// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en_US = {
    "on_board": {
      "select_language": "Select language",
      "select_language_content":
          "Don't worry! You can change it later on Settings.",
      "onboard_title": "Let's learn!",
      "onboard_body":
          "We will help you learn English vocabulary everyday, effectively. Trust me, this is really fun!",
      "get_started": "Get started"
    },
    "app_language": {"english": "English", "vietnamese": "Vietnamese"},
    "common": {
      "next": "Next",
      "accept": "Accept",
      "cancel": "Cancel",
      "skip": "Skip",
      "done": "Done",
      "browse": "Browse",
      "other_k": "Other"
    },
    "auth": {
      "already_have_an_account": "Already have an account?",
      "sign_in": "Sign in",
      "sign_up": "Sign up",
      "welcome": "Welcome",
      "enter_email": "Enter email",
      "enter_password": "Enter password",
      "forgot_password": "Forgot password?",
      "or_sign_in_with": "Or sign in with:",
      "create_an_account": "Create an account",
      "confirm_password": "Confirm password",
      "please_enter_and_password": "Please enter email and password!",
      "password_does_not_match": "Password does not match",
      "sign_in_as_email": "Sign in as {email}",
      "invalid_email":
          "Email could only contains . - _ as the special characters",
      "invalid_password": "Password must contains 8 characters and numbers.",
      "sign_out": "Sign out"
    },
    "app_log": {"on_restart": "Welcome back!"},
    "user_data": {
      "point": {
        "zero": "0 point",
        "one": "1 point",
        "many": "{} points",
        "other": "{} points"
      }
    },
    "page": {
      "home": "Home",
      "search": "Search",
      "activity": "Activity",
      "profile": "Profile",
      "setting": "Setting"
    },
    "search": {
      "search_for_words": "Search for words",
      "type_something": "Type something",
      "not_found": "Not found",
      "are_you_looking_for": "Are you looking for?"
    }
  };
  static const Map<String, dynamic> vi_VN = {
    "on_board": {
      "select_language": "Chọn ngôn ngữ",
      "select_language_content":
          "Đừng lo! Bạn có thể thay đổi nó sau trong phần Cài đặt.",
      "onboard_title": "Học nào!",
      "onboard_body":
          "Chúng tôi sẽ giúp bạn học từ vựng tiếng Anh mỗi ngày. Tin tôi đi, nó sẽ rất vui đấy!",
      "get_started": "Bắt đầu"
    },
    "app_language": {"english": "Tiếng Anh", "vietnamese": "Tiếng Việt"},
    "common": {
      "next": "Tiếp tục",
      "accept": "Đồng ý",
      "cancel": "Huỷ",
      "skip": "Huỷ",
      "done": "Xong",
      "browse": "Duyệt",
      "other_k": "Khác"
    },
    "auth": {
      "already_have_an_account": "Bạn đã có tài khoản chưa?",
      "sign_in": "Đăng nhập",
      "sign_up": "Đăng ký",
      "welcome": "Chào mừng",
      "enter_email": "Nhập email",
      "enter_password": "Nhập mật khẩu",
      "forgot_password": "Quên mật khẩu?",
      "or_sign_in_with": "Hoặc đăng nhập với:",
      "create_an_account": "Tạo một tài khoản",
      "confirm_password": "Xác nhận mật khẩu",
      "please_enter_and_password": "Hãy nhập email và mật khẩu!",
      "password_does_not_match": "Mật khẩu không khớp",
      "sign_in_as_email": "Đăng nhập với {email}",
      "invalid_email": "Email chỉ có thể chứa . - _ là ký tự đặc biệt",
      "invalid_password": "Mật khẩu phải bao gồm 8 ký tự và chữ số.",
      "sign_out": "Đăng xuất"
    },
    "app_log": {"on_restart": "Mừng bạn quay lại!"},
    "user_data": {
      "point": {
        "zero": "0 điểm",
        "one": "1 điểm",
        "many": "{} điểm",
        "other": "{} điểm"
      }
    },
    "page": {
      "home": "Trang chủ",
      "search": "Tìm kiếm",
      "activity": "Hoạt động",
      "profile": "Hồ sơ",
      "setting": "Cài đặt"
    },
    "search": {
      "search_for_words": "Tìm từ vựng",
      "type_something": "Nhập gì đó",
      "not_found": "Không tìm thấy",
      "are_you_looking_for": "Có phải bạn đang tìm?"
    }
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en_US": en_US,
    "vi_VN": vi_VN
  };
}