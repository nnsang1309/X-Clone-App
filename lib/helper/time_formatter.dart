/*
  - This converts a  timestamp object into a string

  E.g.

  if the input timestamp represents: Feb 16, 2025, 18:00

  the fucntion will return the string: "2025-02-16 18:30"
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
}
