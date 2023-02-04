// import 'package:backpack/features/assignment/assignment.dart';

// import 'package:backpack/features/course/course.dart';
// import 'package:backpack/features/profile/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../course/view/old_coursepage.dart';
// import 'file_upload.dart';

// class StudentAssignmentButtons extends ConsumerWidget {
//   const StudentAssignmentButtons({
//     super.key,
//     required this.user,
//     required this.assignment,
//   });

//   final UserProfile user;
//   final Assignment assignment;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Text to display on submit button
//     final buttonText =
//         assignment.submissionRequired ? 'Submit' : 'Mark as Complete';
//     return Column(
//       children: <Widget>[
//         // Show upload section if assignment requries a file upload
//         // And not already submitted
//         if (assignment.submissionRequired &&
//             !user.completed.contains(assignment.id))
//           const FileUpload(),
//         // Disable button if assignment is already submitted
//         ElevatedButton(
//           onPressed: user.completed.contains(assignment.id)
//               ? null
//               : () async {
//                   // Change assignment status to complete
//                   // ref
//                   //     .read(authStateProvider.notifier)
//                   //     .markComplete(assignment.id);
//                   // Return to course page
//                   ref.read(assignmentDetailProvider.notifier).state = null;
//                 },
//           child: Text(buttonText),
//         ),
//       ],
//     );
//   }
// }
