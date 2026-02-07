import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Toast utility for showing beautiful notifications throughout the app

class ToastUtils {
  // Private constructor to prevent instantiation
  ToastUtils._();

  static final FToast _fToast = FToast();

  /// Show success toast (green)
  static void showSuccess(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastContainer(
        message: message,
        icon: Icons.check_circle,
        backgroundColor: const Color(0xFF4CAF50),
        iconColor: Colors.white,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  /// Show error toast (red)
  static void showError(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastContainer(
        message: message,
        icon: Icons.error,
        backgroundColor: const Color(0xFFE53935),
        iconColor: Colors.white,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  /// Show info toast (blue)
  static void showInfo(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastContainer(
        message: message,
        icon: Icons.info,
        backgroundColor: const Color(0xFF2196F3),
        iconColor: Colors.white,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  /// Show warning toast (orange)
  static void showWarning(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastContainer(
        message: message,
        icon: Icons.warning,
        backgroundColor: const Color(0xFFFF9800),
        iconColor: Colors.white,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  /// Build custom toast container widget
  static Widget _buildToastContainer({
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Cancel all active toasts
  static void cancelAllToasts() {
    _fToast.removeCustomToast();
  }
}