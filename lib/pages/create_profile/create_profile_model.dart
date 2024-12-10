import '/flutter_flow/flutter_flow_util.dart';
import 'create_profile_widget.dart' show CreateProfileWidget;
import 'package:flutter/material.dart';

class CreateProfileModel extends FlutterFlowModel<CreateProfileWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameTextController;
  String? Function(BuildContext, String?)? yourNameTextControllerValidator;
  // State field(s) for yourCourse widget.
  FocusNode? yourCourseFocusNode;
  TextEditingController? yourCourseTextController;
  String? Function(BuildContext, String?)? yourCourseTextControllerValidator;
  // State field(s) for yourSec widget.
  FocusNode? yourSecFocusNode;
  TextEditingController? yourSecTextController;
  String? Function(BuildContext, String?)? yourSecTextControllerValidator;
  // State field(s) for yourStudNum widget.
  FocusNode? yourStudNumFocusNode;
  TextEditingController? yourStudNumTextController;
  String? Function(BuildContext, String?)? yourStudNumTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameTextController?.dispose();

    yourCourseFocusNode?.dispose();
    yourCourseTextController?.dispose();

    yourSecFocusNode?.dispose();
    yourSecTextController?.dispose();

    yourStudNumFocusNode?.dispose();
    yourStudNumTextController?.dispose();
  }
}
