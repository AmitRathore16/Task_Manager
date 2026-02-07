class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates email format
  /// Returns error message if invalid, null if valid
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedValue = value.trim();

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password strength
  /// Returns error message if invalid, null if valid
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  /// Validates full name
  /// Returns error message if invalid, null if valid
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    // Check if name contains only letters and spaces
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(trimmedValue)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  /// Validates task title
  /// Returns error message if invalid, null if valid
  static String? validateTaskTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Task title is required';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return 'Task title must be at least 3 characters long';
    }

    if (trimmedValue.length > 200) {
      return 'Task title must not exceed 200 characters';
    }

    return null;
  }

  /// Generic non-empty validator
  /// Returns error message if empty, null if valid
  static String? validateNotEmpty(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Checks if email format is valid (returns boolean)
  static bool isValidEmail(String email) {
    return validateEmail(email) == null;
  }

  /// Checks if password is valid (returns boolean)
  static bool isValidPassword(String password) {
    return validatePassword(password) == null;
  }

  /// Checks if name is valid (returns boolean)
  static bool isValidName(String name) {
    return validateName(name) == null;
  }

  /// Checks if task title is valid (returns boolean)
  static bool isValidTaskTitle(String title) {
    return validateTaskTitle(title) == null;
  }
}