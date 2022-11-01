import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/widget.dart';

class Itext extends ConsumerWidget {
  const Itext({ Key? key, required this.label, required this.ctrl,  
    this.status = true, this.required = false, this.maxLines = 1, this.isPwd = false, 
    this.fnValid, this.fnOnChange }) : super(key: key);

  final String label;
  final TextEditingController ctrl;
  final bool status;
  final bool required;
  final int maxLines;
  final bool isPwd;
  final Function? fnValid;
  final Function? fnOnChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WG.itext(label, ctrl, status: status, required: required,
      maxLines: maxLines, isPwd: isPwd, fnValid: fnValid, fnOnChange: fnOnChange);
  }

}