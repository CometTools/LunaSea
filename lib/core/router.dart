import 'package:flutter/material.dart' hide Router;
import 'package:fluro_fork/fluro_fork.dart';
import 'package:lunasea/modules/home/routes.dart';
import 'package:lunasea/modules/search/routes.dart';
import 'package:lunasea/modules/lidarr/routes.dart';
import 'package:lunasea/modules/radarr/routes.dart';
import 'package:lunasea/modules/sonarr/routes.dart';
import 'package:lunasea/modules/nzbget/routes.dart';
import 'package:lunasea/modules/sabnzbd/routes.dart';
import 'package:lunasea/modules/ombi.dart' show OmbiModule, OmbiRouter;
import 'package:lunasea/modules/settings.dart' show SettingsModule, SettingsRouter;
import 'package:lunasea/modules/tautulli.dart' show TautulliModule, TautulliRouter;

class LunaRouter {
    LunaRouter._();

    static void intialize() {
        // General
        SettingsRouter.initialize();
        // Monitoring
        OmbiRouter.initialize();
        TautulliRouter.initialize();
    }

    static TransitionType get transitionType => TransitionType.native;

    static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder> {
        ..._home,
        SettingsModule.ROUTE_NAME: (context) => SettingsModule(),
        ..._search,
        ..._lidarr,
        ..._radarr,
        ..._sonarr,
        ..._sabnzbd,
        ..._nzbget,
        OmbiModule.ROUTE_NAME: (context) => OmbiModule(),
        TautulliModule.ROUTE_NAME: (context) => TautulliModule(),
    };

    static Map<String, WidgetBuilder> get _home => <String, WidgetBuilder> {
        //  /
        Home.ROUTE_NAME: (context) => Home(),
        //  /home/*
        HomeCalendar.ROUTE_NAME: (context) => HomeCalendar(refreshIndicatorKey: null),
        HomeQuickAccess.ROUTE_NAME: (context) => HomeQuickAccess(),
    };

    static Map<String, WidgetBuilder> get _search => <String, WidgetBuilder> {
        //  /search
        Search.ROUTE_NAME: (context) => Search(),
        //  /search/*
        SearchSearch.ROUTE_NAME: (context) => SearchSearch(),
        SearchCategories.ROUTE_NAME: (context) => SearchCategories(),
        SearchSubcategories.ROUTE_NAME: (context) => SearchSubcategories(),
        SearchResults.ROUTE_NAME: (context) => SearchResults(),
    };

    static Map<String, WidgetBuilder> get _lidarr => <String, WidgetBuilder> {
        //  /lidarr
        Lidarr.ROUTE_NAME: (context) => Lidarr(),
        //  /lidarr/*
        LidarrCatalogue.ROUTE_NAME: (context) => LidarrCatalogue(refreshIndicatorKey: null, refreshAllPages: null),
        LidarrMissing.ROUTE_NAME: (context) => LidarrMissing(refreshIndicatorKey: null, refreshAllPages: null),
        LidarrHistory.ROUTE_NAME: (context) => LidarrHistory(refreshIndicatorKey: null, refreshAllPages: null),
        //  /lidarr/add/*
        LidarrAddSearch.ROUTE_NAME: (context) => LidarrAddSearch(),
        LidarrAddDetails.ROUTE_NAME: (context) => LidarrAddDetails(),
        //  /lidarr/edit/*
        LidarrEditArtist.ROUTE_NAME: (context) => LidarrEditArtist(),
        //  /lidarr/details/*
        LidarrDetailsAlbum.ROUTE_NAME: (context) => LidarrDetailsAlbum(),
        LidarrDetailsArtist.ROUTE_NAME: (context) => LidarrDetailsArtist(),
        //  /lidarr/search/*
        LidarrSearchResults.ROUTE_NAME: (context) => LidarrSearchResults(),
    };

    static Map<String, WidgetBuilder> get _radarr => <String, WidgetBuilder> {
        //  /radarr
        Radarr.ROUTE_NAME: (context) => Radarr(),
        //  /radarr/*
        RadarrCatalogue.ROUTE_NAME: (context) => RadarrCatalogue(refreshIndicatorKey: null, refreshAllPages: null),
        RadarrMissing.ROUTE_NAME: (context) => RadarrMissing(refreshIndicatorKey: null, refreshAllPages: null),
        RadarrUpcoming.ROUTE_NAME: (context) => RadarrUpcoming(refreshIndicatorKey: null, refreshAllPages: null),
        RadarrHistory.ROUTE_NAME: (context) => RadarrHistory(refreshIndicatorKey: null, refreshAllPages: null),
        //  /radarr/add/*
        RadarrAddSearch.ROUTE_NAME: (context) => RadarrAddSearch(),
        RadarrAddDetails.ROUTE_NAME: (context) => RadarrAddDetails(),
        //  /radarr/details/*
        RadarrDetailsMovie.ROUTE_NAME: (context) => RadarrDetailsMovie(),
        RadarrEditMovie.ROUTE_NAME: (context) => RadarrEditMovie(),
        RadarrSearchResults.ROUTE_NAME: (context) => RadarrSearchResults(),
    };

    static Map<String, WidgetBuilder> get _sonarr => <String, WidgetBuilder> {
        //  /sonarr
        Sonarr.ROUTE_NAME: (context) => Sonarr(),
        //  /sonarr/*
        SonarrCatalogue.ROUTE_NAME: (context) => SonarrCatalogue(refreshIndicatorKey: null, refreshAllPages: null),
        SonarrMissing.ROUTE_NAME: (context) => SonarrMissing(refreshIndicatorKey: null, refreshAllPages: null),
        SonarrUpcoming.ROUTE_NAME: (context) => SonarrUpcoming(refreshIndicatorKey: null, refreshAllPages: null),
        SonarrHistory.ROUTE_NAME: (context) => SonarrHistory(refreshIndicatorKey: null, refreshAllPages: null),
        //  /sonarr/add/*
        SonarrAddSearch.ROUTE_NAME: (context) => SonarrAddSearch(),
        SonarrAddDetails.ROUTE_NAME: (context) => SonarrAddDetails(),
        //  /sonarr/details/*
        SonarrDetailsSeries.ROUTE_NAME: (context) => SonarrDetailsSeries(),
        SonarrDetailsSeason.ROUTE_NAME: (context) => SonarrDetailsSeason(),
        //  /sonarr/*/*
        SonarrEditSeries.ROUTE_NAME: (context) => SonarrEditSeries(),
        SonarrSearchResults.ROUTE_NAME: (context) => SonarrSearchResults(),
    };

    static Map<String, WidgetBuilder> get _nzbget => <String, WidgetBuilder> {
        //  /nzbget
        NZBGet.ROUTE_NAME: (context) => NZBGet(),
        //  /nzbget/*
        NZBGetHistory.ROUTE_NAME: (context) => NZBGetHistory(refreshIndicatorKey: null),
        NZBGetQueue.ROUTE_NAME: (context) => NZBGetQueue(refreshIndicatorKey: null),
        NZBGetStatistics.ROUTE_NAME: (context) => NZBGetStatistics(),
    };

    static Map<String, WidgetBuilder> get _sabnzbd => <String, WidgetBuilder> {
        //  /sabnzbd
        SABnzbd.ROUTE_NAME: (context) => SABnzbd(),
        //  /sabnzbd/*
        SABnzbdHistory.ROUTE_NAME: (context) => SABnzbdHistory(refreshIndicatorKey: null),
        SABnzbdQueue.ROUTE_NAME: (context) => SABnzbdQueue(refreshIndicatorKey: null),
        SABnzbdStatistics.ROUTE_NAME: (context) => SABnzbdStatistics(),
        //  /sabnzbd/history/*
        SABnzbdHistoryStages.ROUTE_NAME: (context) => SABnzbdHistoryStages(),
    };
}
