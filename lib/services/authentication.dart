class AuthMethod {
  // 회원가입
  Future<String> register({
    required String email,
    required String name,
    required String password,
  }) async {
    String message = "오류 발생!";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        message = "success";
      } else {
        message = "빈칸이 있습니다.";
      }
    } catch (err) {
      return message = err.toString();
    }
    return message;
  }

  // 로그인
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String message = "오류 발생!";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        message = "success";
      } else {
        message = "빈칸이 있습니다.";
      }
    } catch (err) {
      return err.toString();
    }
    return message;
  }
}
