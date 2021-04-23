import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';

class TautulliMediaDetailsMetadataMetadata extends StatelessWidget {
  final TautulliMetadata metadata;

  TautulliMediaDetailsMetadataMetadata({
    Key key,
    @required this.metadata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        if (metadata.originallyAvailableAt != null &&
            metadata.originallyAvailableAt.isNotEmpty)
          LunaTableContent(
              title: 'released', body: metadata.originallyAvailableAt),
        if (metadata.addedAt != null)
          LunaTableContent(title: 'added', body: metadata.addedAt.lunaDate),
        if (metadata.duration != null)
          LunaTableContent(
              title: 'duration', body: metadata.duration.lunaTimestamp),
        if (metadata.mediaInfo != null && metadata.mediaInfo.length != 0)
          LunaTableContent(
              title: 'bitrate',
              body:
                  '${metadata.mediaInfo[0].bitrate ?? LunaUI.TEXT_EMDASH} kbps'),
        if (metadata.rating != null)
          LunaTableContent(
              title: 'rating',
              body: '${(((metadata?.rating ?? 0) * 10).truncate())}%'),
        if (metadata.studio != null && metadata.studio.isNotEmpty)
          LunaTableContent(title: 'studio', body: metadata.studio),
        if (metadata.genres != null && metadata.genres.length != 0)
          LunaTableContent(
              title: 'genres', body: metadata.genres.take(5).join('\n')),
        if (metadata.directors != null && metadata.directors.length != 0)
          LunaTableContent(
              title: 'directors', body: metadata.directors.take(5).join('\n')),
        if (metadata.writers != null && metadata.writers.length != 0)
          LunaTableContent(
              title: 'writers', body: metadata.writers.take(5).join('\n')),
        if (metadata.actors != null && metadata.actors.length != 0)
          LunaTableContent(
              title: 'actors', body: metadata.actors.take(5).join('\n')),
      ],
    );
  }
}
