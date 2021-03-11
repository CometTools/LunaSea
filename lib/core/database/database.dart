import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules.dart';

class Database {
    static const String _DATABASE_PATH = 'database';

    /// Initialize the database.
    /// 
    /// - Initializes Hive database path
    /// - Register all adapters
    /// - Open all boxes
    /// - Set default database state of necessary
    Future<void> initialize() async {
        await Hive.initFlutter(_DATABASE_PATH);
        _registerAdapters();
        await _openBoxes();
        if(profilesBox.keys.length == 0) setDefaults(clearEverything: true);
    }

    /// Deinitialize the database by closing all open hive boxes.
    Future<void> deinitialize() async => await Hive.close();

    /// Registers all necessary object adapters for Hive.
    void _registerAdapters() {
        //Core
        Hive.registerAdapter(IndexerHiveObjectAdapter());
        Hive.registerAdapter(ProfileHiveObjectAdapter());
        //General
        LunaDatabase().registerAdapters();
        DashboardDatabase().registerAdapters();
        SearchDatabase().registerAdapters();
        //Automation
        LidarrDatabase().registerAdapters();
        RadarrDatabase().registerAdapters();
        SonarrDatabase().registerAdapters();
        //Clients
        NZBGetDatabase().registerAdapters();
        SABnzbdDatabase().registerAdapters();
        //Monitoring
        TautulliDatabase().registerAdapters();
    }

    /// Open all Hive boxes for reading.
    Future<void> _openBoxes() async {
        await Hive.openBox('alerts');
        await Hive.openBox<IndexerHiveObject>('indexers');
        await Hive.openBox<LunaLogHiveObject>('logs');
        await Hive.openBox('lunasea');
        await Hive.openBox<ProfileHiveObject>('profiles');
    }

    /// Set the default state for all hive boxes.
    void setDefaults({ bool clearEverything = false }) {
        //Clear all the boxes
        clearAllBoxes(clearEverything: clearEverything);
        //Set default profile & enabled profile
        profilesBox.put('default', ProfileHiveObject.empty());
        lunaSeaBox.put(LunaDatabaseValue.ENABLED_PROFILE.key, 'default');
    }

    //Get boxes
    static Box get alertsBox => Hive.box('alerts');
    static Box<IndexerHiveObject> get indexersBox => Hive.box<IndexerHiveObject>('indexers');
    static Box<LunaLogHiveObject> get logsBox => Hive.box('logs');
    static Box get lunaSeaBox => Hive.box('lunasea');
    static Box<ProfileHiveObject> get profilesBox => Hive.box<ProfileHiveObject>('profiles');

    //Clear boxes
    void clearAlertsBox() => alertsBox.deleteAll(alertsBox.keys);
    void clearIndexersBox() => indexersBox.deleteAll(indexersBox.keys);
    void clearLogsBox() => logsBox.deleteAll(logsBox.keys);
    void clearLunaSeaBox() => lunaSeaBox.deleteAll(lunaSeaBox.keys);
    void clearProfilesBox() => profilesBox.deleteAll(profilesBox.keys);
    
    void clearAllBoxes({ bool clearEverything = false }) {
        clearLunaSeaBox();
        clearProfilesBox();
        clearIndexersBox();
        if(clearEverything) {
            clearAlertsBox();
            clearLogsBox();
        }
    }

    //Profile values
    static String get currentProfile => lunaSeaBox.get('profile');
    static ProfileHiveObject get currentProfileObject => profilesBox.get(currentProfile);
}
