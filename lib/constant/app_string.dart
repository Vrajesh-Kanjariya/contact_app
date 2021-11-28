class AppString {
  static String appName = 'Contact App';
  static String register = 'Register';
  static String logIn = 'Log In';

  static String email = 'Email';
  static String enterEmail = 'Enter email';
  static String password = 'Password';
  static String enterPassword = 'Enter password';

  static String firstName = 'First name';
  static String enterFirstName = 'Enter first name';
  static String lastName = 'Last name';
  static String enterLastName = 'Enter last name';
  static String contactNo = 'Contact';
  static String enterContact = 'Enter mobile';
  static String address = 'Address';
  static String enterAddress = 'Enter address';
  static String dob = 'Date of birth';
  static String enterDob = 'Select date of birth';
  static String weekPassword = 'weak-password';
  static String emailAlreadyUse = 'email-already-in-use';
  static String userNotFound = 'user-not-found';
  static String wrongPassword = 'wrong-password';

  static String isLoggedIn = 'isLoggedIn';
  static String isEmail = 'isEmail';
  static String isPassword = 'isPassword';
  static String isUserId = 'isUserId';

  static String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static String passwordRegex =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  static String nameRegex = r'^[a-zA-Z ]+$';
  static String contactRegex = r'^[0-9]+$';

  static String contact = 'Add Contact';
  static String update = 'Update Contact';
  static String addContact = 'Add Contact';
  static String imageNotSelected = 'Image not selected';
  static String userAdded = 'User Added';
  static String pleaseSelectImage = 'Please select image';
  static String firstNameEmpty = 'First name can not empty';
  static String lastNameEmpty = 'Last name can not empty';
  static String characterOnly = 'Please enter character only';
  static String selectDob = 'Please select date of birth';
  static String contactEmpty = 'Contact can not empty';
  static String numberOnly = 'Please enter number only';
  static String tenDigitOnly = 'Contact must be 10 digit only';
  static String addressEmpty = 'Address can not empty';
  static String emailEmpty = 'Email can not empty';
  static String validateEmail = 'Please enter valid email';
  static String passwordEmpty = 'Password can not empty';
  static String validatePassword =
      'Password should contains at least One upper case letter and one digit and one special character.';
  static String delete = 'Delete';
  static String deleteConfirmation = 'Are you sure you want to delete?';
  static String userUpdated = 'User updated';
  static String userNotUpdated = 'User not updated';
  static String exit = 'Exit';
  static String exitConfirmation = 'Are you sure you want to exit?';
}
