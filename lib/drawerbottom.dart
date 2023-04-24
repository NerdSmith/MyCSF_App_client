import 'package:flutter/material.dart';

class NavDrawerBottom extends StatefulWidget {
  Function onTileTap;
  int selectedIdx;

  NavDrawerBottom({Key? key, required this.onTileTap, required this.selectedIdx}) : super(key: key);

  static final itemIcon = [
    Image.asset("assets/menu_items/bottom/home.png", height: 20),
    Image.asset("assets/menu_items/bottom/map.png", height: 20),
    Image.asset("assets/menu_items/bottom/AI.png", height: 22),
    Image.asset("assets/menu_items/bottom/calendar.png", height: 25),
    Image.asset("assets/menu_items/bottom/chat.png", height: 25),
  ];

  static final itemIconSelected = [
    Image.asset("assets/menu_items/bottom/selected/home.png", height: 40),
    Image.asset("assets/menu_items/bottom/selected/map.png", height: 40),
    Image.asset("assets/menu_items/bottom/selected/AI.png", height: 40),
    Image.asset("assets/menu_items/bottom/selected/calendar.png", height: 40),
    Image.asset("assets/menu_items/bottom/selected/chat.png", height: 40),
  ];

  @override
  State<NavDrawerBottom> createState() => _NavDrawerBottomState();
}

class _NavDrawerBottomState extends State<NavDrawerBottom> {
  void setNewViewIdx(int index) {
    if (index == 0) {
      widget.onTileTap(-1);
    }
    if (index == 1) {
      widget.onTileTap(5);
    }
    if (index == 2) {
      widget.onTileTap(8);
    }
    if (index == 3) {
      widget.onTileTap(7);
    }
    if (index == 4) {
      widget.onTileTap(9);
    }
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 55,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black, width: 1.0))),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: widget.selectedIdx == -1 ? NavDrawerBottom.itemIconSelected[0] : NavDrawerBottom.itemIcon[0], label: ''),
            BottomNavigationBarItem(icon: widget.selectedIdx == 5 ? NavDrawerBottom.itemIconSelected[1] : NavDrawerBottom.itemIcon[1], label: ''),
            BottomNavigationBarItem(icon: widget.selectedIdx == 8 ? NavDrawerBottom.itemIconSelected[2] : NavDrawerBottom.itemIcon[2], label: ''),
            BottomNavigationBarItem(icon: widget.selectedIdx == 7 ? NavDrawerBottom.itemIconSelected[3] : NavDrawerBottom.itemIcon[3], label: ''),
            BottomNavigationBarItem(icon: widget.selectedIdx == 9 ? NavDrawerBottom.itemIconSelected[4] : NavDrawerBottom.itemIcon[4], label: ''),
          ],
          onTap: setNewViewIdx,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0.0,
          unselectedFontSize: 0.0
        ),
      )
    );
  }
}
