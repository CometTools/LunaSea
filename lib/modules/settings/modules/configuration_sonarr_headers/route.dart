import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsConfigurationSonarrHeadersRouter extends LunaPageRouter {
    SettingsConfigurationSonarrHeadersRouter() : super('/settings/configuration/sonarr/headers');

    @override
    void defineRoute(FluroRouter router) => super.noParameterRouteDefinition(router, _SettingsConfigurationSonarrHeadersRoute());
}

class _SettingsConfigurationSonarrHeadersRoute extends StatefulWidget {
    @override
    State<_SettingsConfigurationSonarrHeadersRoute> createState() => _State();
}

class _State extends State<_SettingsConfigurationSonarrHeadersRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LunaAppBar(
        context: context,
        title: 'Custom Headers',
    );

    Widget get _body => ValueListenableBuilder(
        valueListenable: Database.profilesBox.listenable(),
        builder: (context, profile, _) => LSListView(
            children: _headers,
        ),
    );

    List<Widget> get _headers => [
        if((Database.currentProfileObject.sonarrHeaders ?? {}).isEmpty) _noHeaders,
        ..._list,
        SettingsModulesSonarrHeadersAddHeaderTile(),
    ];

    Widget get _noHeaders => LSGenericMessage(text: 'No Custom Headers Added');

    List<Widget> get _list {
        Map<String, dynamic> headers = (Database.currentProfileObject.sonarrHeaders ?? {}).cast<String, dynamic>();
        List<SettingsModulesSonarrHeadersHeaderTile> list = [];
        headers.forEach((key, value) => list.add(SettingsModulesSonarrHeadersHeaderTile(
            headerKey: key.toString(),
            headerValue: value.toString(),
        )));
        list.sort((a,b) => a.headerKey.toLowerCase().compareTo(b.headerKey.toLowerCase()));
        return list;
    }
}