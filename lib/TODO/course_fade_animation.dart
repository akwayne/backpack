

// TODO: Put this back in the router
//       GoRoute(
//         name: 'course',
//         path: '/course/:courseId',
//         pageBuilder: (context, state) {
//           final courseId = state.params['courseId'] ?? '';
//           return CustomTransitionPage<void>(
//             child: CoursePage(courseId: courseId),
//             transitionDuration: const Duration(milliseconds: 300),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) =>
//                     SlideTransition(
//               position: animation.drive(Tween<Offset>(
//                 begin: const Offset(0.0, 1.0),
//                 end: Offset.zero,
//               ).chain(CurveTween(curve: Curves.easeIn))),
//               child: child,
//             ),
//           );
//         },
//       ),

