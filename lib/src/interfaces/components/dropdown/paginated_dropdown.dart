import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';

class PaginatedDropdown<T> extends StatefulWidget {
  final String? hintText;
  final String? label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T>? validator;
  final Color backgroundColor;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onScrolledToEnd;
  final Widget Function(BuildContext, T, bool isSelected) itemBuilder;
  final String Function(T)? getItemLabel;

  const PaginatedDropdown({
    Key? key,
    this.label,
    required this.items,
    this.value,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.backgroundColor = kInputFieldcolor,
    this.isLoading = false,
    this.hasMore = false,
    this.onScrolledToEnd,
    required this.itemBuilder,
    this.getItemLabel,
  }) : super(key: key);

  @override
  State<PaginatedDropdown<T>> createState() => _PaginatedDropdownState<T>();
}

class _PaginatedDropdownState<T> extends State<PaginatedDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final ScrollController _scrollController = ScrollController();
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onScroll() {
    if (widget.hasMore && widget.onScrolledToEnd != null) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        widget.onScrolledToEnd!();
      }
    }
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    const double itemHeight = 48.0;
    const double loadingHeight = 48.0;
    const double maxHeight = 300.0;
    int itemCount = widget.items.length + (widget.isLoading ? 1 : 0);
    double calculatedHeight = (widget.items.length * itemHeight) +
        (widget.isLoading ? loadingHeight : 0);
    double overlayHeight =
        calculatedHeight < maxHeight ? calculatedHeight : maxHeight;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Modal barrier to close dropdown when tapping outside
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeOverlay,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 4),
              child: Material(
                color: widget.backgroundColor,
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: overlayHeight,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index < widget.items.length) {
                        final item = widget.items[index];
                        final isSelected = item == widget.value;
                        return SizedBox(
                          height: itemHeight,
                          child: GestureDetector(
                            onTap: () {
                              widget.onChanged(item);
                              _removeOverlay();
                            },
                            child:
                                widget.itemBuilder(context, item, isSelected),
                          ),
                        );
                      } else {
                        return const SizedBox(
                          height: loadingHeight,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: LoadingAnimation(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabel = widget.value != null
        ? (widget.getItemLabel?.call(widget.value as T) ??
            widget.value.toString())
        : (widget.hintText ?? '');
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(widget.label ?? '', style: kSmallTitleM),
                ),
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: widget.backgroundColor,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorText: widget.validator?.call(widget.value),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          color: kWhite,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: kWhite,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
