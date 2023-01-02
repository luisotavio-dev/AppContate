import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final bool password;
  final FormFieldValidator validator;
  final int stringToEdit;
  final Size size;
  final bool multilines;
  final bool readOnly;
  final bool defaultFocus;
  final Key formKey;
  final Function? onTap;
  final String? initialValue;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String) onChanged;

  const TextFieldWidget({
    required this.hintText,
    this.icon,
    this.password = false,
    this.controller,
    required this.validator,
    required this.stringToEdit,
    required this.onChanged,
    required this.size,
    this.readOnly = false,
    this.multilines = false,
    this.defaultFocus = false,
    this.onTap,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.01),
      child: Container(
        width: size.width * 0.9,
        constraints: BoxConstraints(
          minHeight: size.height * 0.06,
          maxWidth: size.width * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
          key: formKey,
          child: TextFormField(
            style: const TextStyle(color: Colors.black),
            onChanged: (value) => onChanged(value),
            controller: controller,
            validator: validator,
            autofocus: defaultFocus,
            readOnly: readOnly,
            textInputAction: TextInputAction.next,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            initialValue: initialValue,
            maxLines: multilines ? null : 1,
            onTap: onTap != null ? () => onTap!() : null,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(color: Color(0xffADA4A5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 17),
              hintText: hintText,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(
                  icon,
                  color: const Color(0xff7B6F72),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
