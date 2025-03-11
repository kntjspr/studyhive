import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, "assets/icons/chat.png"),
            _buildHomeButton(1, "assets/icons/home.png"),
            _buildNavItem(2, "assets/icons/notification.png"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String imagePath) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9800) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            color: isSelected ? Colors.white : const Color(0xFFFF9800),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(int index, String imagePath) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFFF9800).withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: isSelected ? 2 : 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            imagePath,
            width: 32,
            height: 32,
            // Using the original image without color tinting
            color: null,
          ),
        ),
      ),
    );
  }
}
