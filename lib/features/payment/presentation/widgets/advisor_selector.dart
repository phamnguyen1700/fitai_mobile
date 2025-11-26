import 'package:flutter/material.dart';

class Advisor {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final double rating;

  const Advisor({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    required this.rating,
  });

  String get fullName => '$firstName $lastName';
}

class AdvisorSelector extends StatefulWidget {
  final List<Advisor> advisors;
  final ValueChanged<Advisor>? onSelected;

  const AdvisorSelector({super.key, required this.advisors, this.onSelected});

  @override
  State<AdvisorSelector> createState() => _AdvisorSelectorState();
}

class _AdvisorSelectorState extends State<AdvisorSelector> {
  String? _selectedId;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // viewportFraction < 1 → card nằm giữa, có 2 bên lộ ra một chút
    _pageController = PageController(viewportFraction: 0.55);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    if (widget.advisors.isEmpty) {
      return Text('Hiện chưa có advisor khả dụng.', style: t.bodyMedium);
    }

    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.advisors.length,
        padEnds: true, // để item đầu / cuối không dính mép
        itemBuilder: (context, index) {
          final a = widget.advisors[index];
          final selected = a.id == _selectedId;

          return Center(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedId = a.id);
                widget.onSelected?.call(a);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 150, // giữ size giống list cũ
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selected
                      ? cs.primaryContainer.withOpacity(0.4)
                      : cs.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? cs.primary : cs.outlineVariant,
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (selected)
                      BoxShadow(
                        color: cs.primary.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: cs.surfaceContainerHighest,
                      backgroundImage:
                          (a.profilePicture != null &&
                              a.profilePicture!.isNotEmpty)
                          ? NetworkImage(a.profilePicture!)
                          : null,
                      child:
                          (a.profilePicture == null ||
                              a.profilePicture!.isEmpty)
                          ? Text(
                              a.firstName.isNotEmpty
                                  ? a.firstName[0].toUpperCase()
                                  : '?',
                              style: t.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),

                    // Tên advisor
                    Text(
                      a.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: t.bodyMedium?.copyWith(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: a.rating > 0 ? Colors.amber : cs.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          a.rating.toStringAsFixed(1),
                          style: t.bodySmall?.copyWith(
                            color: a.rating > 0
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
