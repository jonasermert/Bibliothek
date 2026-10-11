import 'dart:ui';

import 'package:flutter/material.dart';

/// A curved surface with a sliding glass indicator and drag-to-select tabs.
class CurvedBottomNavigationBar extends StatefulWidget {
  const CurvedBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  }) : assert(destinations.length > 1),
       assert(selectedIndex >= 0 && selectedIndex < destinations.length);

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  @override
  State<CurvedBottomNavigationBar> createState() =>
      _CurvedBottomNavigationBarState();
}

class _CurvedBottomNavigationBarState
    extends State<CurvedBottomNavigationBar> {
  double? _dragPosition;

  double _visualIndex(int index, bool rtl) =>
      (rtl ? widget.destinations.length - 1 - index : index).toDouble();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / widget.destinations.length;
          final target = _dragPosition ??
              _visualIndex(widget.selectedIndex, rtl);
          void updateDrag(DragUpdateDetails details) {
            setState(() {
              _dragPosition = (details.localPosition.dx / tabWidth - .5)
                  .clamp(0.0, widget.destinations.length - 1.0);
            });
          }

          return GestureDetector(
            onHorizontalDragStart: (_) => setState(() {
              _dragPosition = _visualIndex(widget.selectedIndex, rtl);
            }),
            onHorizontalDragUpdate: updateDrag,
            onHorizontalDragCancel: () => setState(() => _dragPosition = null),
            onHorizontalDragEnd: (_) {
              final visual = _dragPosition!.round();
              final index = rtl
                  ? widget.destinations.length - 1 - visual
                  : visual;
              setState(() => _dragPosition = null);
              widget.onDestinationSelected(index);
            },
            child: SizedBox(
              height: 96,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CurvedSurfacePainter(
                        colors.surfaceContainer,
                        colors.outlineVariant,
                      ),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: target, end: target),
                    duration: reduceMotion || _dragPosition != null
                        ? Duration.zero
                        : const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    builder: (context, position, child) {
                      final fraction = (position + .5) /
                          widget.destinations.length;
                      final dip = 4 * fraction * (1 - fraction) * 16;
                      return Positioned(
                        left: position * tabWidth + 4,
                        top: 7 + dip,
                        width: tabWidth - 8,
                        height: 48,
                        child: IgnorePointer(child: child),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colors.primaryContainer.withValues(alpha: .85),
                                colors.primaryContainer.withValues(alpha: .5),
                              ],
                            ),
                            border: Border.all(
                              color: colors.onPrimaryContainer
                                  .withValues(alpha: .18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      children: [
                        for (var i = 0; i < widget.destinations.length; i++)
                          Expanded(
                            child: Semantics(
                              label: widget.destinations[i].label,
                              button: true,
                              selected: widget.selectedIndex == i,
                              onTap: () => widget.onDestinationSelected(i),
                              child: ExcludeSemantics(
                                child: Tooltip(
                                  message: widget.destinations[i].label,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap: () =>
                                          widget.onDestinationSelected(i),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 19 +
                                              4 *
                                                  ((i + .5) / widget.destinations.length) *
                                                  (1 - (i + .5) / widget.destinations.length) *
                                                  16,
                                          left: 2,
                                          right: 2,
                                        ),
                                        child: Column(
                                          children: [
                                            IconTheme(
                                              data: IconThemeData(
                                                size: 26,
                                                color: widget.selectedIndex == i
                                                    ? colors.onPrimaryContainer
                                                    : colors.onSurfaceVariant,
                                              ),
                                              child: widget.selectedIndex == i
                                                  ? widget.destinations[i].selectedIcon ??
                                                      widget.destinations[i].icon
                                                  : widget.destinations[i].icon,
                                            ),
                                            const SizedBox(height: 12),
                                            Flexible(
                                              child: Text(
                                                widget.destinations[i].label,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: widget.selectedIndex == i
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                  color: colors.onSurface,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CurvedSurfacePainter extends CustomPainter {
  const _CurvedSurfacePainter(this.color, this.borderColor);

  final Color color;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 24)
      ..quadraticBezierTo(0, 4, 20, 6)
      ..quadraticBezierTo(size.width / 2, 38, size.width - 20, 6)
      ..quadraticBezierTo(size.width, 4, size.width, 24)
      ..lineTo(size.width, size.height - 24)
      ..quadraticBezierTo(size.width, size.height, size.width - 24, size.height)
      ..lineTo(24, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - 24)
      ..close();
    canvas.drawShadow(path, Colors.black.withValues(alpha: .18), 6, false);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor.withValues(alpha: .5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_CurvedSurfacePainter oldDelegate) =>
      color != oldDelegate.color || borderColor != oldDelegate.borderColor;
}
