part of 'app_routes.dart';

abstract class RouteArguments {}

class CoursePageArguments extends RouteArguments {
  CoursePageArguments({required this.courseId});
  final String courseId;
}

class AddAssignmentArgments extends RouteArguments {
  AddAssignmentArgments({required this.courseId});
  final String courseId;
}
