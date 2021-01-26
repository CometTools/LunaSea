import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrMovieDetailsOverviewInformationBlock extends StatelessWidget {
    final RadarrMovie movie;
    final RadarrQualityProfile qualityProfile;

    RadarrMovieDetailsOverviewInformationBlock({
        Key key,
        @required this.movie,
        @required this.qualityProfile,
    }): super(key: key);

    @override
    Widget build(BuildContext context) => LSTableBlock(
        children: [
            LSTableContent(title: 'path', body: movie?.path),
            LSTableContent(title: 'size', body: movie?.lunaFileSize),
            LSTableContent(title: 'quality', body: qualityProfile?.name),
            LSTableContent(title: 'availability', body: movie?.lunaMinimumAvailability),
            LSTableContent(title: 'status', body: movie?.status?.readable ?? Constants.TEXT_EMDASH),
            LSTableContent(title: '', body: ''),
            LSTableContent(title: 'in cinemas', body: movie?.lunaInCinemasOn),
            LSTableContent(title: 'release', body: movie?.lunaReleaseDate),
            LSTableContent(title: 'added on', body: movie?.lunaDateAdded),
            LSTableContent(title: '', body: ''),
            LSTableContent(title: 'year', body: movie.lunaYear),
            LSTableContent(title: 'studio', body: movie?.lunaStudio),
            LSTableContent(title: 'runtime', body: movie?.lunaRuntime),
            LSTableContent(title: 'rating', body: movie?.certification ?? Constants.TEXT_EMDASH),
            LSTableContent(title: 'genres', body: movie?.genres?.join(', ') ?? Constants.TEXT_EMDASH),
            LSTableContent(title: 'alternative titles', body: movie?.alternateTitles?.map<String>((title) => title.title)?.join('\n') ?? Constants.TEXT_EMDASH),
        ],
    );
}
