import '../conf_project/util.dart';
import 'package:flutter/material.dart';

class LoginModel extends ProjectModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for textE-mail widget.
  TextEditingController? textEMailController;
  String? Function(BuildContext, String?)? textEMailControllerValidator;
  // State field(s) for textSenha widget.
  TextEditingController? textSenhaController;
  late bool textSenhaVisibility;
  String? Function(BuildContext, String?)? textSenhaControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    textSenhaVisibility = false;
  }

  void dispose() {
    unfocusNode.dispose();
    textEMailController?.dispose();
    textSenhaController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
