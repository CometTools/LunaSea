import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/tautulli.dart';

class TautulliLogsNewsletterLogTile extends StatelessWidget {
  final TautulliNewsletterLogRecord newsletter;

  TautulliLogsNewsletterLogTile({
    Key key,
    @required this.newsletter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaListTile(
      context: context,
      title: LunaText.title(text: newsletter.agentName),
      subtitle: _subtitle(),
      trailing: _trailing(),
      contentPadding: true,
    );
  }

  Widget _subtitle() => RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white70,
            fontSize: LunaUI.FONT_SIZE_SUBTITLE,
          ),
          children: [
            TextSpan(text: '${newsletter.notifyAction}\n'),
            TextSpan(text: '${newsletter.subjectText}\n'),
            TextSpan(text: '${newsletter.bodyText}\n'),
            TextSpan(
              text: LunaDatabaseValue.USE_24_HOUR_TIME.data
                  ? DateFormat('MMMM dd, yyyy ${LunaUI.TEXT_EMDASH} HH:mm')
                      .format(newsletter.timestamp)
                  : DateFormat('MMMM dd, yyyy ${LunaUI.TEXT_EMDASH} hh:mm a')
                      .format(newsletter.timestamp),
              style: TextStyle(
                color: LunaColours.accent,
                fontWeight: LunaUI.FONT_WEIGHT_BOLD,
              ),
            ),
          ],
        ),
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 4,
      );

  Widget _trailing() => Column(
        children: [
          LunaIconButton(
            icon: newsletter.success ? Icons.check_circle : Icons.cancel,
            color: newsletter.success ? Colors.white : LunaColours.red,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      );
}
