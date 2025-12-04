  import 'package:flutter/material.dart';

  import '../../../core/constants/colors.dart';
import 'custom_tab_selector.dart';



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
          CustomTabSelector(
            items: widget.tabTitles,
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: widget.tabViews[_selectedIndex],
          ),
        ],
      );
    }
  }
