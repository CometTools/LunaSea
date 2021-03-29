import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/nzbget.dart';

class NZBGet extends StatefulWidget {
    static const ROUTE_NAME = '/nzbget';

    @override
    State<StatefulWidget> createState() => _State();
}

class _State extends State<NZBGet> {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final _pageController = PageController(initialPage: NZBGetDatabaseValue.NAVIGATION_INDEX.data);
    String _profileState = Database.currentProfileObject.toString();
    NZBGetAPI _api = NZBGetAPI.from(Database.currentProfileObject);

    final List _refreshKeys = [
        GlobalKey<RefreshIndicatorState>(),
        GlobalKey<RefreshIndicatorState>(),
    ];

    @override
    void initState() {
        super.initState();
        Future.microtask(() => Provider.of<NZBGetState>(context, listen: false).navigationIndex = 0);
    }

    @override
    Widget build(BuildContext context) => LunaWillPopScope(
        scaffoldKey: _scaffoldKey,
        child: ValueListenableBuilder(
            valueListenable: Database.lunaSeaBox.listenable(keys: [LunaDatabaseValue.ENABLED_PROFILE.key]),
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
        ),
    );

    Widget get _drawer => LunaDrawer(page: LunaModule.NZBGET.key);

    Widget get _bottomNavigationBar => NZBGetNavigationBar(pageController: _pageController);

    List<Widget> get _tabs => [
        NZBGetQueue(refreshIndicatorKey: _refreshKeys[0]),
        NZBGetHistory(refreshIndicatorKey: _refreshKeys[1]),
    ];

    Widget get _body => PageView(
        controller: _pageController,
        children: _api.enabled ? _tabs : List.generate(_tabs.length, (_) => LSNotEnabled('NZBGet')),
        onPageChanged: _onPageChanged,
    );

    Widget get _appBar => LunaAppBar.dropdown(
        title: 'NZBGet',
        useDrawer: true,
        profiles: Database.profilesBox.keys.fold([], (value, element) {
            if(Database.profilesBox.get(element)?.nzbgetEnabled ?? false) value.add(element);
            return value;
        }),
        actions: _api.enabled
            ? <Widget>[
                Selector<NZBGetState, bool>(
                    selector: (_, model) => model.error,
                    builder: (context, error, widget) => error
                        ? Container()
                        : NZBGetAppBarStats(),
                ),
                LSIconButton(
                    icon: Icons.more_vert,
                    onPressed: () async => _handlePopup(),
                ),
            ]
            : null,
    );

    Future<void> _handlePopup() async {
        List<dynamic> values = await NZBGetDialogs.globalSettings(context);
        if(values[0]) switch(values[1]) {
            case 'web_gui': _api.host.lunaOpenGenericLink(); break;
            case 'add_nzb': _addNZB(); break;
            case 'sort': _sort(); break;
            case 'server_details': _serverDetails(); break;
            default: LunaLogger().warning('NZBGet', '_handlePopup', 'Unknown Case: ${values[1]}');
        }
    }

    Future<void> _addNZB() async {
        List values = await NZBGetDialogs.addNZB(context);
        if(values[0]) switch(values[1]) {
            case 'link': _addByURL(); break;
            case 'file': _addByFile(); break;
            default: LunaLogger().warning('NZBGet', '_addNZB', 'Unknown Case: ${values[1]}');
        }
    }

    Future<void> _addByURL() async {
        List values = await NZBGetDialogs.addNZBUrl(context);
        if(values[0]) await _api.uploadURL(values[1])
        .then((_) => LSSnackBar(
            context: context,
            title: 'Uploaded NZB (URL)',
            message: values[1],
            type: SNACKBAR_TYPE.success,
        ))
        .catchError((_) => LSSnackBar(
            context: context,
            title: 'Failed to Upload NZB',
            message: LunaLogger.checkLogsMessage,
            type: SNACKBAR_TYPE.failure,
        ));
    }

    Future<void> _addByFile() async {
        try {
            FilePickerResult _file = await FilePicker.platform.pickFiles(
                type: FileType.any,
                allowMultiple: false,
                allowCompression: false,
                withData: true,
            );
            if(_file == null) return;
            if(
                _file.files[0].extension == 'nzb' ||
                _file.files[0].extension == 'zip'
            ) {
                String _data = String.fromCharCodes(_file.files[0].bytes);
                String _name = _file.files[0].name;
                if(_data != null) await _api.uploadFile(_data, _name)
                .then((value) {
                    _refreshKeys[0]?.currentState?.show();
                    showLunaSuccessSnackBar(
                        context: context,
                        title: 'Uploaded NZB (File)',
                        message: _name,
                    );
                })
                .catchError((error, stack) => showLunaErrorSnackBar(
                    context: context,
                    title: 'Failed to Upload NZB',
                    message: LunaLogger.checkLogsMessage,
                    error: error,
                ));
            } else {
                showLunaErrorSnackBar(
                    context: context,
                    title: 'Failed to Upload NZB',
                    message: 'The selected file is not valid',
                );
            }
        } catch (error, stack) {
            LunaLogger().error('Failed to add NZB by file', error, stack);
            showLunaErrorSnackBar(
                context: context,
                title: 'Failed to Upload NZB',
                error: error,
            );
        }
    }

    Future<void> _sort() async {
        List values = await NZBGetDialogs.sortQueue(context);
        if(values[0]) await _api.sortQueue(values[1])
        .then((_) {
            _refreshKeys[0]?.currentState?.show();
            LSSnackBar(
                context: context,
                title: 'Sorted Queue',
                message: (values[1] as NZBGetSort).name,
                type: SNACKBAR_TYPE.success,
            );
        })
        .catchError((_) => LSSnackBar(
            context: context,
            title: 'Failed to Sort Queue',
            message: LunaLogger.checkLogsMessage,
            type: SNACKBAR_TYPE.failure,
        ));
    }

    Future<void> _serverDetails() async => Navigator.of(context).pushNamed(NZBGetStatistics.ROUTE_NAME);

    void _onPageChanged(int index) => Provider.of<NZBGetState>(context, listen: false).navigationIndex = index;

    void _refreshProfile() {
        _api = NZBGetAPI.from(Database.currentProfileObject);
        _profileState = Database.currentProfileObject.toString();
        _refreshAllPages();
    }

    void _refreshAllPages() {
        for(var key in _refreshKeys) key?.currentState?.show();
    }
}