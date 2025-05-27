class SigninModel {
  final int error;
  final String message;
  final String? token;

  SigninModel({required this.error, required this.message, this.token});
}
