import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/routes/lidarr/routes.dart';
import 'package:lunasea/widgets/ui.dart';

class LidarrHistoryTile extends StatefulWidget {
    final LidarrHistoryData entry;
    final GlobalKey<ScaffoldState> scaffoldKey;
    final Function refresh;

    LidarrHistoryTile({
        @required this.entry,
        @required this.scaffoldKey,
        @required this.refresh,
    });

    @override
    State<LidarrHistoryTile> createState() => _State();
}

class _State extends State<LidarrHistoryTile> {
    @override
    Widget build(BuildContext context) => LSCardTile(
        title: LSTitle(text: widget.entry.title),
        subtitle: RichText(
            text: TextSpan(
                children: widget.entry.subtitle,
            ),
        ),
        padContent: true,
        onTap: () => _enterArtist(),
    );

    Future<void> _enterArtist() async {
        if(widget.entry.artistID == null || widget.entry.artistID == -1) {
            LSSnackBar(
                context: context,
                title: 'No Artist Available',
                message: 'There is no artist associated with this history entry',
                type: SNACKBAR_TYPE.failure,
            );
        } else {
            final dynamic result = await Navigator.of(context).pushNamed(
                LidarrDetailsArtist.ROUTE_NAME,
                arguments: LidarrDetailsArtistArguments(
                    data: null,
                    artistID: widget.entry.artistID,
                ),
            );
            if(result != null) switch(result[0]) {
                case 'remove_artist': {
                    LSSnackBar(
                        context: context,
                        title: result[1] ? 'Removed (With Data)' : 'Removed',
                        message: widget.entry.title,
                        type: SNACKBAR_TYPE.success,
                    );
                    widget.refresh();
                    break;
                }
            }
        }
    }
}
