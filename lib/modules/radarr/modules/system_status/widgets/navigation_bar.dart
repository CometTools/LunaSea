import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrSystemStatusNavigationBar extends StatefulWidget {
    static const List<IconData> icons = [
        Icons.subject_rounded,
        Icons.donut_large_rounded,
    ];

    static const List<String> titles = [
        'About',
        'Disk Space',
    ];

    final PageController pageController;

    RadarrSystemStatusNavigationBar({
        Key key,
        @required this.pageController,
    }): super(key: key);

    @override
    State<StatefulWidget> createState() => _State();
}

class _State extends State<RadarrSystemStatusNavigationBar> {
    int _index = RadarrDatabaseValue.NAVIGATION_INDEX_SYSTEM_STATUS.data;

    @override
    void initState() {
        super.initState();
        widget.pageController?.addListener(_pageControllerListener);
    }

    @override
    void dispose() {
        widget.pageController?.removeListener(_pageControllerListener);
        super.dispose();
    }

    void _pageControllerListener() {
        if(widget.pageController.page.round() == _index) return;
        setState(() => _index = widget.pageController.page.round());
    }

    @override
    Widget build(BuildContext context) => LSBottomNavigationBar(
        index: _index,
        onTap: _navOnTap,
        icons: RadarrSystemStatusNavigationBar.icons,
        titles: RadarrSystemStatusNavigationBar.titles,
    );

    Future<void> _navOnTap(int index) async {
        widget.pageController.lunaAnimateToPage(index);
    }
}
