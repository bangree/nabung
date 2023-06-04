import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:nabung/constants/color.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final bool isRequired;
  final bool readOnly;
  final Widget? suffix;
  final Function()? onTap;
  final int? maxLines;
  final bool filled;
  final bool usingCurrency;
  final Widget? prefix;
  final EdgeInsets? contentPadding;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.validator,
    this.inputType,
    this.isRequired = true,
    this.readOnly = false,
    this.suffix,
    this.onTap,
    this.maxLines = 1,
    this.filled = false,
    this.usingCurrency = false,
    this.prefix,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isObscure = false;

  @override
  void initState() {
    if (widget.obscure) _isObscure = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.filled ? white : null,
      padding: widget.contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (widget.prefix != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: widget.prefix!,
              ),
            ],
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                obscureText: _isObscure,
                keyboardType: widget.inputType,
                readOnly: widget.readOnly,
                onTap: widget.onTap,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  border: widget.filled
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: grey,
                            width: 0.5,
                          ),
                        ),
                  focusedBorder: widget.filled
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: grey,
                            width: 0.5,
                          ),
                        ),
                  suffixIcon: (widget.suffix != null)
                      ? widget.suffix
                      : widget.obscure
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              child: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            )
                          : const SizedBox(),
                  filled: widget.filled,
                  fillColor: widget.filled ? white : null,
                  contentPadding: widget.contentPadding ??
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                ),
                inputFormatters: [
                  if (widget.usingCurrency) ...[
                    CurrencyTextInputFormatter(
                      locale: 'id_ID',
                      decimalDigits: 0,
                      symbol: '',
                    ),
                  ],
                ],
                validator: widget.validator ??
                    (widget.isRequired
                        ? (val) {
                            if (val == null || val.trim().isEmpty) {
                              return '${widget.hint ?? 'field'} cannot be empty';
                            }
                            return null;
                          }
                        : null),
                maxLines: widget.maxLines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
