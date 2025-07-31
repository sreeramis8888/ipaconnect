import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:characters/characters.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String) onSendText;
  final Function() onAttachment;
  final Function() onCamera;
  final Function() onVoiceRecord;
  final bool isRecording;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showEmojiPicker;
  final VoidCallback onToggleEmojiPicker;

  const ChatInputBar({
    Key? key,
    required this.onSendText,
    required this.onAttachment,
    required this.onCamera,
    required this.onVoiceRecord,
    required this.isRecording,
    required this.controller,
    required this.focusNode,
    required this.showEmojiPicker,
    required this.onToggleEmojiPicker,
  }) : super(key: key);

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with TickerProviderStateMixin {
  bool _isTyping = false;
  late AnimationController _micAnimationController;
  late Animation<double> _micScaleAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);

    _micAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _micScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _micAnimationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isRecording) {
      _micAnimationController.repeat(reverse: true);
    }
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = widget.controller.text.trim().isNotEmpty;
    });
  }

  @override
  void didUpdateWidget(ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _micAnimationController.repeat(reverse: true);
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _micAnimationController.stop();
      _micAnimationController.reset();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _micAnimationController.dispose();
    super.dispose();
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
    Color iconColor = Colors.white,
    double size = 48.0,
    Widget? customChild,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(size / 2),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: customChild ??
              Icon(
                icon,
                color: iconColor,
                size: size * 0.5,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: kBlack54.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Emoji/Keyboard toggle button
                    IconButton(
                      icon: Icon(
                        widget.showEmojiPicker
                            ? Icons.keyboard
                            : Icons.emoji_emotions_outlined,
                        color: kSecondaryTextColor,
                        size: 28,
                      ),
                      onPressed: widget.onToggleEmojiPicker,
                      splashRadius: 24,
                    ),

                    // Text input field
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 120),
                        decoration: BoxDecoration(
                          color: kInputFieldcolor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: kStrokeColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: widget.controller,
                                focusNode: widget.focusNode,
                                style: const TextStyle(
                                  color: kTextColor,
                                  fontSize: 16,
                                ),
                                maxLines: null,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: 'Message',
                                  hintStyle: const TextStyle(
                                    color: kSecondaryTextColor,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            // Attachment button inside text field
                            if (!_isTyping)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.attach_file,
                                    color: kSecondaryTextColor,
                                    size: 24,
                                  ),
                                  onPressed: widget.onAttachment,
                                  splashRadius: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Action buttons (Send/Camera/Mic)
                    if (_isTyping)
                      _buildActionButton(
                        icon: Icons.send,
                        backgroundColor: kPrimaryColor,
                        onPressed: () {
                          final text = widget.controller.text.trim();
                          if (text.isNotEmpty) {
                            widget.onSendText(text);
                            widget.controller.clear();
                          }
                        },
                      )
                    else
                      Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.camera_alt,
                            backgroundColor: kCardBackgroundColor,
                            onPressed: widget.onCamera,
                          ),
                          const SizedBox(width: 8),
                           GestureDetector(
                             onLongPress: () {
                               // Start recording on long press
                               if (!widget.isRecording) {
                                 widget.onVoiceRecord();
                               }
                             },
                             onLongPressEnd: (_) {
                               // Stop recording when long press ends
                               if (widget.isRecording) {
                                 widget.onVoiceRecord();
                               }
                             },
                             child: AnimatedBuilder(
                               animation: _micScaleAnimation,
                               builder: (context, child) {
                                 return Transform.scale(
                                   scale: widget.isRecording ? _micScaleAnimation.value : 1.0,
                                   child: _buildActionButton(
                                     icon: Icons.mic,
                                     backgroundColor: widget.isRecording ? kRed : kPrimaryColor,
                                     onPressed: () {
                                       // Tap to start recording if not already recording
                                       if (!widget.isRecording) {
                                         widget.onVoiceRecord();
                                       }
                                     },
                                   ),
                                 );
                               },
                             ),
                           ),
                        ],
                      ),
                  ],
                ),
              ),

              // Emoji Picker
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: widget.showEmojiPicker ? 300 : 0,
                child: widget.showEmojiPicker
                    ? Container(
                        decoration: BoxDecoration(
                          color: kCardBackgroundColor,
                          border: Border(
                            top: BorderSide(
                              color: kStrokeColor,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            final selection = widget.controller.selection;
                            final text = widget.controller.text;
                            final newText = text.replaceRange(
                              selection.start,
                              selection.end,
                              emoji.emoji,
                            );
                            widget.controller.text = newText;
                            widget.controller.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: selection.start + emoji.emoji.length),
                            );
                          },
                          onBackspacePressed: () {
                            final text = widget.controller.text;
                            final selection = widget.controller.selection;
                            if (text.isNotEmpty && selection.start > 0) {
                              final newText =
                                  text.characters.skipLast(1).toString();
                              widget.controller.text = newText;
                              widget.controller.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: newText.length),
                              );
                            }
                          },
                          textEditingController: widget.controller,
                          config: Config(
                            height: 300,
                            emojiViewConfig: EmojiViewConfig(
                              backgroundColor: kCardBackgroundColor,
                              columns: 8,
                              emojiSizeMax: 28,
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              recentsLimit: 28,
                              noRecents: const Text(
                                'No recent emojis',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kSecondaryTextColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              loadingIndicator: const SizedBox.shrink(),
                            ),
                            categoryViewConfig: CategoryViewConfig(
                              backgroundColor: kInputFieldcolor,
                              iconColor: kSecondaryTextColor,
                              iconColorSelected: kPrimaryColor,
                              indicatorColor: kPrimaryColor,
                              dividerColor: kStrokeColor,
                              backspaceColor: kSecondaryTextColor,
                              categoryIcons: const CategoryIcons(),
                              tabIndicatorAnimDuration:
                                  const Duration(milliseconds: 300),
                            ),
                            skinToneConfig: SkinToneConfig(
                              dialogBackgroundColor: kInputFieldcolor,
                              indicatorColor: kPrimaryColor,
                            ),
                            searchViewConfig: SearchViewConfig(
                              backgroundColor: kCardBackgroundColor,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        

      ],
    );
  }
}
