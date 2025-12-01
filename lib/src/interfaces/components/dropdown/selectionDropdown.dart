import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';

class SelectionDropDown extends StatefulWidget {
  final String? hintText;
  final String? label;
  final Widget? labelWidget; // Add support for RichText widgets
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final Color backgroundColor;

  const SelectionDropDown({
    this.label,
    this.labelWidget, // Add support for RichText widgets
    required this.items,
    this.value,
    required this.onChanged,
    this.validator,
    Key? key,
    this.hintText,
    this.backgroundColor = kInputFieldcolor,
  }) : super(key: key);

  @override
  _SelectionDropDownState createState() => _SelectionDropDownState();
}

class _SelectionDropDownState extends State<SelectionDropDown>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null || widget.labelWidget != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: widget.labelWidget ??
                      Text(widget.label ?? "", style: kSmallTitleM),
                ),
              DropdownButtonFormField2<String>(
                iconStyleData: IconStyleData(
                    icon: Icon(
                  color: kWhite,
                  Icons.keyboard_arrow_down_rounded,
                )),
                isExpanded: true,
                value: widget.value,
                items: widget.items,
                onChanged: widget.onChanged,
                validator: widget.validator,
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300,
                  decoration: BoxDecoration(
                    color: kInputFieldcolor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 12, right: 12),
                  hintText: widget.hintText ?? '',
                  hintStyle: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                  ),
                  fillColor: widget.backgroundColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: kWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
