import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/widgets/ui.dart';
import 'package:lunasea/routes/lidarr/routes.dart';

class Lidarr extends StatefulWidget {
    static const ROUTE_NAME = '/lidarr';

    @override
    State<Lidarr> createState() => _State();
}

class _State extends State<Lidarr> {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    int _currIndex = 0;
    String _profileState = Database.currentProfileObject.toString();
    LidarrAPI _api = LidarrAPI.from(Database.currentProfileObject);

    final List _refreshKeys = [
        GlobalKey<RefreshIndicatorState>(),
        GlobalKey<RefreshIndicatorState>(),
        GlobalKey<RefreshIndicatorState>(),
    ];

    final List<Icon> _navbarIcons = [
        Icon(CustomIcons.music),
        Icon(CustomIcons.calendar_missing),
        Icon(CustomIcons.history)
    ];

    final List<String> _navbarTitles = [
        'Catalogue',
        'Missing',
        'History',
    ];

    @override
    Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: Database.lunaSeaBox.listenable(keys: ['profile']),
        builder: (context, box, widget) {
            if(_profileState != Database.currentProfileObject.toString()) _refreshProfile();
            return Scaffold(
                key: _scaffoldKey,
                body: _body,
                drawer: _drawer,
                appBar: _appBar,
                bottomNavigationBar: _bottomNavigationBar,
            );
        },
    );

    Widget get _drawer => LSDrawer(page: 'lidarr');

    Widget get _bottomNavigationBar => LSBottomNavigationBar(
        index: _currIndex,
        icons: _navbarIcons,
        titles: _navbarTitles,
        onTap: _navOnTap,
    );

    List<Widget> get _tabs => [
        LidarrCatalogue(
            refreshIndicatorKey: _refreshKeys[0],
            refreshAllPages: _refreshAllPages,
        ),
        LidarrMissing(
            refreshIndicatorKey: _refreshKeys[1],
            refreshAllPages: _refreshAllPages,
        ),
        LidarrHistory(
            refreshIndicatorKey: _refreshKeys[2],
            refreshAllPages: _refreshAllPages,
        ),
    ];

    Widget get _body => Stack(
        children: List.generate(_tabs.length, (index) => Offstage(
            offstage: _currIndex != index,
            child: TickerMode(
                enabled: _currIndex == index,
                child: _api.enabled
                    ? _tabs[index]
                    : LSNotEnabled('Lidarr'),
            ),
        )),
    );

    Widget get _appBar => LSAppBar(
        title: 'Lidarr',
        actions: _api.enabled
            ? <Widget>[
                IconButton(
                    icon: Elements.getIcon(Icons.add),
                    tooltip: 'Add Artist',
                    onPressed: () async => _enterAddArtist(),
                ),
                IconButton(
                    icon: Elements.getIcon(Icons.more_vert),
                    tooltip: 'More Settings',
                    onPressed: () async => _handlePopup(context),
                )
            ]
            : null,
    );

    Future<void> _enterAddArtist() async {
        //Clear search query before we enter the route
        final _model = Provider.of<LidarrModel>(context, listen: false);
        _model.addSearchQuery = '';
        //Enter the route
        final dynamic result = await Navigator.of(context).pushNamed(LidarrAddSearch.ROUTE_NAME);
        // //Handle the result
        if(result != null && result[0] == 'artist_added') {
            LSSnackBar(
                context: context,
                title: 'Artist Added',
                message: result[1],
                type: SNACKBAR_TYPE.success,
            );
            _refreshAllPages();
        }
    }

    Future<void> _handlePopup(BuildContext context) async {
        
        List<dynamic> values = await LidarrDialogs.showSettingsPrompt(context);
        if(values[0]) switch(values[1]) {
            case 'web_gui': await _api.host?.toString()?.lsLinks_OpenLink(); break;
            case 'update_library': await _api.updateLibrary()
                ? LSSnackBar(
                    context: context,
                    title: 'Updating Library...',
                    message: 'Updating your library in the background',
                )
                : LSSnackBar(
                    context: context,
                    title: 'Failed to Update Library',
                    message: Constants.CHECK_LOGS_MESSAGE,
                    type: SNACKBAR_TYPE.failure, 
                );
                break;
            case 'rss_sync': await _api.triggerRssSync()
                ? LSSnackBar(
                    context: context,
                    title: 'Running RSS Sync...',
                    message: 'Running RSS sync in the background',
                )
                : LSSnackBar(
                    context: context,
                    title: 'Failed to Run RSS Sync',
                    message: Constants.CHECK_LOGS_MESSAGE,
                    type: SNACKBAR_TYPE.failure, 
                );
                break;
            case 'backup': await _api.triggerBackup()
                ? LSSnackBar(
                    context: context,
                    title: 'Backing Up Database...',
                    message: 'Backing up database in the background',
                )
                : LSSnackBar(
                    context: context,
                    title: 'Failed to Backup Database',
                    message: Constants.CHECK_LOGS_MESSAGE,
                    type: SNACKBAR_TYPE.failure, 
                );
                break;
            case 'missing_search': {
                List<dynamic> values = await LidarrDialogs.showSearchMissingPrompt(context);
                if(values[0]) await _api.searchAllMissing()
                    ? LSSnackBar(
                        context: context,
                        title: 'Searching...',
                        message: 'Search for all missing albums',
                    )
                    : LSSnackBar(
                        context: context,
                        title: 'Failed to Search',
                        message: Constants.CHECK_LOGS_MESSAGE,
                        type: SNACKBAR_TYPE.failure, 
                    );
                break;
            }
        }
    }

    void _navOnTap(int index) => setState(() => _currIndex = index);

    void _refreshProfile() {
        _api = LidarrAPI.from(Database.currentProfileObject);
        _profileState = Database.currentProfileObject.toString();
        _refreshAllPages();
    }

    void _refreshAllPages() {
        for(var key in _refreshKeys) key?.currentState?.show();
    }
}
