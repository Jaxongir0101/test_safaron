import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScrollTabsExample(),
    );
  }
}

class ScrollTabsExample extends StatefulWidget {
  const ScrollTabsExample({super.key});

  @override
  State<ScrollTabsExample> createState() => _ScrollTabsExampleState();
}

class _ScrollTabsExampleState extends State<ScrollTabsExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Har bir tab nechta itemdan iborat
  final int itemsPerTab = 10;
  final double itemHeight = 80; // har bir item balandligi

  bool isTabChangeFromScroll = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(() {
      if (!isTabChangeFromScroll) {
        int index = (_scrollController.offset ~/ (itemsPerTab * itemHeight))
            .clamp(0, 2);
        if (_tabController.index != index) {
          _tabController.animateTo(index);
        }
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        isTabChangeFromScroll = true;
        _scrollToTab(_tabController.index);
      }
    });
  }

  void _scrollToTab(int tabIndex) {
    final offset = tabIndex * itemsPerTab * itemHeight;
    _scrollController
        .animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((_) {
      isTabChangeFromScroll = false;
    });
  }

  Widget _buildItem(String title, Color color) {
    return Container(
      height: itemHeight,
      color: color,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Text(title, style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allItems = [
      ...List.generate(itemsPerTab,
          (i) => _buildItem("Tab 1 - Item ${i + 1}", Colors.redAccent)),
      ...List.generate(itemsPerTab,
          (i) => _buildItem("Tab 2 - Item ${i + 1}", Colors.greenAccent)),
      ...List.generate(itemsPerTab,
          (i) => _buildItem("Tab 3 - Item ${i + 1}", Colors.blueAccent)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scroll → Tab Change"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Tab 1"),
            Tab(text: "Tab 2"),
            Tab(text: "Tab 3"),
          ],
        ),
      ),
      body: ListView(
        controller: _scrollController,
        children: allItems,
      ),
    );
  }
}
