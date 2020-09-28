import 'package:fluro_fork/fluro_fork.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsCustomizationDrawerRoute extends StatefulWidget {
    static const ROUTE_NAME = '/settings/customization/drawer';
    static String route() => ROUTE_NAME;

    static void defineRoute(Router router) => router.define(
        ROUTE_NAME,
        handler: Handler(handlerFunc: (context, params) => SettingsCustomizationDrawerRoute()),
        transitionType: LunaRouter.transitionType,
    );

    @override
    State<SettingsCustomizationDrawerRoute> createState() => _State();
}

class _State extends State<SettingsCustomizationDrawerRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LunaAppBar(
        context: context,
        popUntil: '/settings',
        title: 'Drawer',
    );

    Widget get _body => LSListView(
        children: [
            ..._folders,  
        ],
    );

    List<Widget> get _folders => [
        LSHeader(
            text: 'Folders',
            subtitle: 'Customizable options related to grouping modules into folders',
        ),
        SettingsCustomizationDrawerUseCategoriesTile(),
        SettingsCustomizationDrawerExpandAutomationTile(),
        SettingsCustomizationDrawerExpandClientsTile(),
        SettingsCustomizationDrawerExpandMonitoringTile(),
    ];
}
