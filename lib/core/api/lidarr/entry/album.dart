import 'package:lunasea/core/database.dart';
import 'package:intl/intl.dart';

class LidarrAlbumEntry {
    final Map<String, dynamic> api = Database.getProfileObject().getLidarr();
    String title;
    String releaseDate;
    int albumID;
    int trackCount;
    double percentageTracks;
    bool monitored;
    
    LidarrAlbumEntry(
        this.albumID,
        this.title,
        this.monitored,
        this.trackCount,
        this.percentageTracks,
        this.releaseDate,
    );

    DateTime get releaseDateObject {
        if(releaseDate != null) {
            return DateTime.tryParse(releaseDate)?.toLocal();
        }
        return null;
    }

    String get releaseDateString {
        if(releaseDateObject != null) {
            return DateFormat('MMMM dd, y').format(releaseDateObject);

        }
        return 'Unknown Release Date';
    }

    String get tracks {
        return trackCount != 1 ?
            '$trackCount Tracks' :
            '$trackCount Track';
    }

    String albumCoverURI({bool highRes = false}) {
        if(api['enabled']) {
            return highRes
                ? '${api['host']}/api/v1/MediaCover/Album/$albumID/cover.jpg?apikey=${api['key']}'
                : '${api['host']}/api/v1/MediaCover/Album/$albumID/cover-500.jpg?apikey=${api['key']}';
        }
        return '';
    }
}
