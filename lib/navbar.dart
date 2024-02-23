import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
      child: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 2,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF252525),
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildNavItem(Icons.home),
                  buildNavItem(Icons.bookmark),
                ],
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox())
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          iconSize: 30,
          color: Colors.white,
          onPressed: () {},
        ),
      ],
    );
  }
}
