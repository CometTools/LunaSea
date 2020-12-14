import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsModulesTautulliRouter {
    static const ROUTE_NAME = '/settings/modules/tautulli';

    static Future<void> navigateTo(BuildContext context, [List parameters]) async => LunaRouter.router.navigateTo(
        context,
        route(),
    );

    static String route() => ROUTE_NAME;
    
    static void defineRoutes(FluroRouter router) => router.define(
        ROUTE_NAME,
        handler: Handler(handlerFunc: (context, params) => _SettingsModulesTautulliRoute()),
        transitionType: LunaRouter.transitionType,
    );

    SettingsModulesTautulliRouter._();
}

class _SettingsModulesTautulliRoute extends StatefulWidget {
    @override
    State<_SettingsModulesTautulliRoute> createState() => _State();
}

class _State extends State<_SettingsModulesTautulliRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LunaAppBar(
        context: context,
        title: 'Tautulli',
        actions: [
            LSIconButton(
                icon: Icons.brush,
                onPressed: () async => SettingsCustomizationTautulliRouter.navigateTo(context),
            ),
        ]
    );

    Widget get _body => ValueListenableBuilder(
        valueListenable: Database.profilesBox.listenable(),
        builder: (context, box, _) => LSListView(
            children: [
                ..._configuration,
                SettingsModulesTautulliTestConnectionTile(),
            ],
        ),
    );

    List<Widget> get _configuration => [
        SettingsModulesTautulliEnabledTile(),
        SettingsModulesTautulliHostTile(),
        SettingsModulesTautulliAPIKeyTile(),
        SettingsModulesTautulliCustomHeadersTile(),
    ];
}
