import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';



class CustomTabBar extends StatefulWidget {
  final List<String> tabTitles;
  final int initialTabIndex;
  final List<Widget> tabViews;

  const CustomTabBar({
    super.key,
    required this.tabTitles,
    required this.initialTabIndex,
    required this.tabViews,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // IMPROVED: Scrollable horizontal category tabs
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.tabTitles.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primary 
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primary 
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.tabTitles[index],
                      style: TextStyle(
                        color: isSelected 
                            ? Colors.white 
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: widget.tabViews[_selectedIndex],
        ),
      ],
    );
  }
}
