import 'package:fluro_fork/fluro_fork.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsCustomizationCalendarRoute extends StatefulWidget {
    static const ROUTE_NAME = '/settings/customization/calendar';
    static String route() => ROUTE_NAME;

    static void defineRoute(Router router) => router.define(
        ROUTE_NAME,
        handler: Handler(handlerFunc: (context, params) => SettingsCustomizationCalendarRoute()),
        transitionType: LunaRouter.transitionType,
    );

    @override
    State<SettingsCustomizationCalendarRoute> createState() => _State();
}

class _State extends State<SettingsCustomizationCalendarRoute> {
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
        title: 'Calendar',
    );

    Widget get _body => LSListView(
        children: [
            LSHeader(
                text: 'Date Range',
                subtitle: 'Choose how far in the past and future the calendar will fetch data',
            ),
            SettingsCustomizationCalendarPastDaysTile(),
            SettingsCustomizationCalendarFutureDaysTile(),
            LSHeader(
                text: 'Starting Options',
                subtitle: 'Customizable options for the default starting date, size, and type of the calendar',
            ),
            SettingsCustomizationCalendarStartingDateTile(),
            SettingsCustomizationCalendarStartingSizeTile(),
            SettingsCustomizationCalendarStartingTypeTile(),
            LSHeader(
                text: 'Modules',
                subtitle: 'Choose which modules will appear in the calendar',
            ),
            SettingsCustomizationCalendarEnableLidarrTile(),
            SettingsCustomizationCalendarEnableRadarrTile(),
            SettingsCustomizationCalendarEnableSonarrTile(),
        ],
    );
}
