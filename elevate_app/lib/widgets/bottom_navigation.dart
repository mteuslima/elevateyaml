import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      decoration: BoxDecoration(
        color: const Color(0xFF4292467161),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(64),
          topRight: Radius.circular(64),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home,
            index: 0,
            spacing: 56,
          ),
          _buildNavItem(
            context,
            icon: Icons.add,
            index: 1,
            isHighlighted: true,
            spacing: 56,
          ),
          _buildNavItem(
            context,
            icon: Icons.person,
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required int index,
    bool isHighlighted = false,
    double spacing = 0,
  }) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        margin: EdgeInsets.only(right: spacing),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isHighlighted 
                ? const Color(0xFF4292613180)
                : const Color(0xFF4290822336),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            size: 24,
            color: isHighlighted 
                ? const Color(0xFF4293717228)
                : const Color(0xFF4281019179),
          ),
        ),
      ),
    );
  }
}