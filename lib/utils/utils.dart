import 'package:flutter/material.dart';

class Utils {
   static bool isPasswordInvalid(String? password, BuildContext context){
    if(password == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password field is empty.")));
      return false;

    }

    // Uppercase letter check
    RegExp upperCaseLetterCheck =
        RegExp(r'^(?=.*?[A-Z])$');
        
    RegExp lowerCaseLetterCheck = RegExp(r'^(?=.*?[a-z])$');
    
    RegExp digitCheck = RegExp(r'^(?=.*?[0-9])$');
    
    RegExp specialCharCheck = RegExp(r'^(?=.*?[!@#\$&*~])$');
    
    RegExp passwordLengthCheck = RegExp(r'^.{8,}$');

    List<String> errors = [];
    
    if(!passwordLengthCheck.hasMatch(password)){
      errors.add("Password must be at least 8 characters long.");
    }

    if(!upperCaseLetterCheck.hasMatch(password)){
      errors.add("Password must have at least one upper case letter.");
    }

    if(!lowerCaseLetterCheck.hasMatch(password)){
      errors.add("Password must have at least one lower case letter.");
    }

    if(!digitCheck.hasMatch(password)){
      errors.add("Password must contain at least one digit.");
    }

    if(!specialCharCheck.hasMatch(password)){
      errors.add("Password must contain at least one special character.");
    }

    if(errors.isNotEmpty){
      String snackMsg = errors.reduce((value,element)=>"$value\n${errors.indexOf(element) + 1} - $element");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackMsg)));
    }

    return errors.isEmpty;
  }
}