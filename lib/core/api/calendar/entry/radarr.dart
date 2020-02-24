import 'package:flutter/material.dart';
import 'package:lunasea/routes/radarr/subpages/details/movie.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/widgets/ui.dart';

class CalendarRadarrEntry extends CalendarEntry {
    final Map<String, dynamic> api = Database.currentProfileObject.getRadarr();
    bool hasFile;
    String fileQualityProfile;
    int year;
    int runtime;

    CalendarRadarrEntry({
        @required int id,
        @required String title,
        @required this.hasFile,
        @required this.fileQualityProfile,
        @required this.year,
        @required this.runtime,
    }): super(id, title);

    String get runtimeString {
        return runtime.lsTime_runtimeString(dot: true);
    }

    TextSpan get subtitle => TextSpan(
        style: TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
        ),
        children: <TextSpan>[
            TextSpan(
                text: '$year$runtimeString',
            ),
            if(!hasFile) TextSpan(
                text: '\nNot Downloaded',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                ),
            ),
            if(hasFile) TextSpan(
                text: '\nDownloaded ($fileQualityProfile)',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(Constants.ACCENT_COLOR),
                ),
            )
        ],
    );
    
    String get bannerURI {
        return api['enabled']
            ? '${api['host']}/api/MediaCover/$id/fanart-360.jpg?apikey=${api['key']}'
            : '';
    }

    Future<void> enterContent(BuildContext context) async {
        await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => RadarrMovieDetails(entry: null, movieID: id),
            ),
        );
    }

    IconButton get trailing => IconButton(
        icon: Elements.getIcon(Icons.arrow_forward_ios),
        onPressed: null,
    );
}