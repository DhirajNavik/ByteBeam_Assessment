import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String toRelativeTime() {
    try {
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(this);

      // Less than a minute
      if (difference.isNegative || difference.inMinutes < 1) {
        return 'Just now';
      }

      // Less than an hour
      if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? 'min' : 'mins'} ago';
      }

      // Less than a day (24 hours)
      if (difference.inHours < 24) {
        final hours = difference.inHours;
        return '$hours ${hours == 1 ? 'hr' : 'hrs'} ago';
      }

      // Less than a week (7 days)
      if (difference.inDays < 7) {
        final days = difference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      }

      // Otherwise, return the full date
      return DateFormat('dd MMM , yyyy').format(this);
    } catch (e) {
      return "";
    }
  }

  String toWhatsAppRelativeTime() {
    try {
      final DateTime now = DateTime.now();

      // Create date-only objects for comparison (ignoring time)
      final DateTime parsedDateOnly = DateTime(year, month, day);
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime yesterday = today.subtract(const Duration(days: 1));

      // Handle today
      if (parsedDateOnly == today) {
        return 'Today';
      }

      // Handle yesterday
      if (parsedDateOnly == yesterday) {
        return 'Yesterday';
      }

      // Handle current year dates - show "22 October"
      if (year == now.year) {
        return DateFormat('dd MMMM').format(this);
      }

      // Handle previous years - show "22 December 2024"
      return DateFormat('dd MMMM yyyy').format(this);
    } catch (e) {
      return "";
    }
  }

  // String formatTime() {
  //   try {
  //     final parsed = DateFormat("HH:mm:ss").parse(this);
  //     return DateFormat("h:mm a").format(parsed);
  //   } catch (_) {
  //     return this;
  //   }
  // }

  // String formatDate() {
  //   try {
  //     final parsed = DateFormat("yyyy-MM-dd").parse(this);
  //     return DateFormat("EEEE, MMM dd, yyyy").format(parsed);
  //   } catch (_) {
  //     return this;
  //   }
  // }

  // String formaMonth() {
  //   try {
  //     final parsed = DateFormat("yyyy-MM-dd").parse(this);
  //     return DateFormat("MMM dd , EEEE").format(parsed);
  //   } catch (_) {
  //     return this;
  //   }
  // }

  // String paresDate() {
  //   final parsed = DateFormat("yyyy-MM-dd").parse(this);

  //   return DateFormat('dd-MM-yyyy').format(parsed);
  // }
}
