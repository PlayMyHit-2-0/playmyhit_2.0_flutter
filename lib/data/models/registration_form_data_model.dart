class RegistrationFormDataModel {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? passwordConfirmation;
  String? userName;
  bool? isCreator;
  bool? agreedToRecieveNewsletter;
  bool? agreedToTermsAndConditions;

  RegistrationFormDataModel({
    required this.firstName,
    required this.lastName,
    required this.email, 
    required this.password,
    required this.passwordConfirmation,
    required this.userName,
    required this.isCreator,
    required this.agreedToRecieveNewsletter,
    required this.agreedToTermsAndConditions
  });
}