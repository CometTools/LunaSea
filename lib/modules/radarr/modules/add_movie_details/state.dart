import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrAddMovieDetailsState extends ChangeNotifier {
    RadarrAddMovieDetailsState({
        @required RadarrMovie movie,
        @required List<RadarrRootFolder> rootFolders,
        @required List<RadarrQualityProfile> qualityProfiles,
        @required List<RadarrTag> tags,
    }) {
        assert(movie != null);
        assert(rootFolders != null);
        assert(qualityProfiles != null);
        assert(tags != null);
        _movie = movie;
        _tags = [];
        _monitored = RadarrDatabaseValue.ADD_MOVIE_DEFAULT_MONITORED.data ?? true;
        _rootFolder = (rootFolders ?? []).firstWhere(
            (element) => element.id == RadarrDatabaseValue.ADD_MOVIE_DEFAULT_ROOT_FOLDER.data,
            orElse: () => (rootFolders?.length ?? 0) != 0 ? rootFolders[0] : RadarrRootFolder(id: -1, freeSpace: 0, path: Constants.TEXT_EMDASH),
        );
        _qualityProfile = (qualityProfiles ?? []).firstWhere(
            (element) => element.id == RadarrDatabaseValue.ADD_MOVIE_DEFAULT_QUALITY_PROFILE.data,
            orElse: () => (qualityProfiles?.length ?? 0) != 0 ? qualityProfiles[0] : RadarrQualityProfile(id: -1, name: Constants.TEXT_EMDASH),
        );
        _availability = RadarrAvailability.values.firstWhere(
            (element) => element.value == RadarrDatabaseValue.ADD_MOVIE_DEFAULT_MINIMUM_AVAILABILITY.data,
            orElse: () => RadarrAvailability.ANNOUNCED,
        );
    }

    RadarrMovie _movie;
    RadarrMovie get movie => _movie;

    bool _monitored = true;
    bool get monitored => _monitored;
    set monitored(bool monitored) {
        assert(monitored != null);
        _monitored = monitored;
        RadarrDatabaseValue.ADD_MOVIE_DEFAULT_MONITORED.put(_monitored);
        notifyListeners();
    }

    RadarrAvailability _availability;
    RadarrAvailability get availability => _availability;
    set availability(RadarrAvailability availability) {
        assert(availability != null);
        _availability = availability;
        RadarrDatabaseValue.ADD_MOVIE_DEFAULT_MINIMUM_AVAILABILITY.put(_availability.value);
        notifyListeners();
    }

    RadarrRootFolder _rootFolder;
    RadarrRootFolder get rootFolder => _rootFolder;
    set rootFolder(RadarrRootFolder rootFolder) {
        assert(rootFolder != null);
        _rootFolder = rootFolder;
        RadarrDatabaseValue.ADD_MOVIE_DEFAULT_ROOT_FOLDER.put(_rootFolder.id);
        notifyListeners();
    }

    RadarrQualityProfile _qualityProfile;
    RadarrQualityProfile get qualityProfile => _qualityProfile;
    set qualityProfile(RadarrQualityProfile qualityProfile) {
        assert(qualityProfile != null);
        _qualityProfile = qualityProfile;
        RadarrDatabaseValue.ADD_MOVIE_DEFAULT_QUALITY_PROFILE.put(_qualityProfile.id);
        notifyListeners();
    }

    List<RadarrTag> _tags = [];
    List<RadarrTag> get tags => _tags;
    set tags(List<RadarrTag> tags) {
        assert(tags != null);
        _tags = tags;
        notifyListeners();
    }

    LunaLoadingState _state = LunaLoadingState.INACTIVE;
    LunaLoadingState get state => _state;
    set state(LunaLoadingState state) {
        assert(state != null);
        _state = state;
        notifyListeners();
    }
}