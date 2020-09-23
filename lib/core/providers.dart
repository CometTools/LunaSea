//Exports
export 'package:provider/provider.dart';
//Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart' show
    HomeState,
    LidarrModel,
    NZBGetModel,
    OmbiState,
    RadarrState,
    SABnzbdModel,
    SearchModel,
    SettingsState,
    SonarrModel,
    TautulliState;

class LunaProvider {
    LunaProvider._();

    static void reset(BuildContext context) {
        Provider.of<LunaState>(context, listen: false).reset();
        // General
        Provider.of<HomeState>(context, listen: false).reset();
        Provider.of<SettingsState>(context, listen: false).reset();
        // Monitoring
        Provider.of<OmbiState>(context, listen: false).reset();
        Provider.of<TautulliState>(context, listen: false).reset();
    }
    
    static MultiProvider providers({ @required Widget child }) => MultiProvider(
        providers: [
            ChangeNotifierProvider(create: (_) => LunaState()),
            // General
            ChangeNotifierProvider(create: (_) => HomeState()),
            ChangeNotifierProvider(create: (_) => SearchModel()),
            ChangeNotifierProvider(create: (_) => SettingsState()),
            // Automation
            ChangeNotifierProvider(create: (_) => SonarrModel()),
            ChangeNotifierProvider(create: (_) => LidarrModel()),
            ChangeNotifierProvider(create: (_) => RadarrState()),
            // Clients
            ChangeNotifierProvider(create: (_) => NZBGetModel()),
            ChangeNotifierProvider(create: (_) => SABnzbdModel()),
            // Monitoring
            ChangeNotifierProvider(create: (_) => OmbiState()),
            ChangeNotifierProvider(create: (_) => TautulliState()),
        ],
        child: child,
    );
}

