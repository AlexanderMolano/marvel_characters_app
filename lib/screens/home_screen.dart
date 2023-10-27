import 'package:flutter/material.dart';
import 'package:marvel_characters_app/views/home_view_first_offset.dart';
import 'package:marvel_characters_app/views/home_view_fourth_offset.dart';
import 'package:marvel_characters_app/views/home_view_second_offset.dart';
import 'package:marvel_characters_app/views/home_view_third_offset.dart';
import 'package:marvel_characters_app/widgets/custom_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';
  final int pageIndex;

  HomeScreen({Key? key, this.pageIndex = 0}) : super(key: key) {
    imageCache.clear();
    imageCache.maximumSize = 100; // Tamaño máximo de la caché
    imageCache.maximumSizeBytes = 100 << 20; // Tamaño máximo en bytes
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabNames = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabNames.length, vsync: this);
    _tabController.animateTo(widget.pageIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final viewRoutes = <Widget>[
    HomeFirstoffset(),
    HomeSecondoffset(),
    HomeThirdhoffset(),
    HomeFourthoffset(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Marvel Characters',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          labelColor: Colors.red,
          labelStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          controller: _tabController,
          tabs: _tabNames.map((String name) => Tab(text: name)).toList(),
        ),
      ),
      backgroundColor: Colors.red,
      body: TabBarView(
        controller: _tabController,
        children: viewRoutes,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
