import 'package:example/chips_input/chips_input_controller.dart';
import 'package:example/chips_input/choose_input_chips/app_chip_dismissable.dart';
import 'package:example/chips_input/choose_input_chips/app_text_counter.dart';
import 'package:example/chips_input/choose_input_chips/scroll_controller_extension.dart';
import 'package:example/chips_input/choose_input_chips/src/chips_input.dart';
import 'package:example/chips_input/choose_input_chips/string_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppChipsInputField extends StatefulWidget {
  const AppChipsInputField({
    required this.chipsInputController,
    required this.hintText,
    this.title,
    super.key,
    this.onChanged,
    this.autoFocus = false,
    this.maxLength,
    this.onLastQueryChanged,
    this.scrollController,
    this.onAdd,
  });

  final String hintText;
  final String? title;
  final bool autoFocus;
  final int? maxLength;
  final ChipsInputController chipsInputController;
  final void Function(List<String>)? onChanged;
  final VoidCallback? onAdd;
  // You can use it to add this query if user save but not made a chip
  final void Function(String)? onLastQueryChanged;
  final ScrollController? scrollController;

  @override
  State<AppChipsInputField> createState() => _AppChipsInputFieldState();
}

class _AppChipsInputFieldState extends State<AppChipsInputField> {
  late final FocusNode textFocusNode;
  final GlobalKey<ChipsInputState<String>> chipKey =
      GlobalKey<ChipsInputState<String>>();
  // Weather to make the focus visiblility of the chips text field at the end
  late final bool keepVisibileAtEnd;

  @override
  void initState() {
    super.initState();

    keepVisibileAtEnd = widget.scrollController != null;
    textFocusNode = FocusNode();
    textFocusNode.addListener(() {
      if (!textFocusNode.hasFocus) {
        // in case of lost focus, add the text as a chip after
        // removing the invalid characters
        final String textValue = removeTextSpecialCharacters(
          chipKey.currentState!.effectiveController.text,
        );
        if (textValue.isNotEmpty) {
          chipKey.currentState!.addChip(textValue);
        }
      } else {
        if (keepVisibileAtEnd) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => Future<void>.delayed(const Duration(milliseconds: 600), () {
              widget.scrollController!.scrollToBottomSheetEnd(
                context: context,
              );
            }),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title.isNotEmptyOrNull()) ...<Widget>[
            Text(
              widget.title!,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0,
                height: 1.45,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
          ChipsInput<String>(
            ensureVisible: false,
            autofocus: widget.autoFocus,
            textFocusNode: textFocusNode,
            key: chipKey,
            maxLength: widget.maxLength,
            initialValue: widget.chipsInputController.chips,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.43,
              letterSpacing: 0,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              filled: true,
              prefix: const Padding(
                padding: EdgeInsetsDirectional.only(start: 10, end: 5),
              ),
              suffix: const Padding(
                padding: EdgeInsetsDirectional.only(start: 5, end: 10),
              ),
              fillColor: const Color(0xffffffff),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xe0dfe0e0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xff4d75c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xe0dfe0e0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffEF4848),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: const Color(0x66696a6c),
                  ),
              errorStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: const Color(0xffEF4848),
                  ),
              counter: _showMaxLengthCounter()
                  ? AppTextCounter(
                      currentLength:
                          widget.chipsInputController.lastQuery.length,
                      maxLength: widget.maxLength!,
                    )
                  : null,
            ),
            findSuggestions: ({
              required String query,
              required bool isSubmitted,
            }) {
              if (widget.maxLength != null &&
                  query.length > widget.maxLength! * .9) {
                setState(() {});
              }
              if (query.replaceAll(',', '').trim().isEmpty) {
                widget.onLastQueryChanged?.call(query);
                widget.chipsInputController.lastQuery = '';
                setState(() {});

                return <String>[];
              }
              if (query.contains(',') || isSubmitted) {
                widget.chipsInputController.lastQuery = '';
                final String textValue = removeTextSpecialCharacters(query);

                chipKey.currentState!.addChip(textValue);
              } else {
                widget.chipsInputController.lastQuery = query;
              }
              setState(() {});

              return <String>[query];
            },
            onChanged: (List<String> data) {
              final bool isDeleteChip =
                  widget.chipsInputController.chips.length != data.length;
              if (!isDeleteChip) {
                widget.chipsInputController.lastQuery = '';
                widget.onAdd?.call();
              }
              widget.chipsInputController.update(chips: data);
              widget.onChanged?.call(data);
            },
            chipBuilder: (
              BuildContext context,
              ChipsInputState<dynamic> state,
              String text,
            ) =>
                AppChipDismissable(
              text: text,
              onDismiss: () => state.deleteChip(text),
            ),
            suggestionBuilder: (
              BuildContext context,
              String text,
            ) =>
                const SizedBox.shrink(),
            optionsViewBuilder: (
              BuildContext context,
              _,
              __,
            ) =>
                const SizedBox.shrink(),
          ),
        ],
      );

  bool _showMaxLengthCounter() =>
      widget.maxLength != null &&
      textFocusNode.hasFocus &&
      widget.chipsInputController.lastQuery.length >= widget.maxLength! * .9;
}
