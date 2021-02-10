import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrMoviesEditQualityProfileTile extends StatelessWidget {
    final List<RadarrQualityProfile> profiles;

    RadarrMoviesEditQualityProfileTile({
        Key key,
        @required this.profiles,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) => LSCardTile(
        title: LunaText.title(text: 'Quality Profile'),
        subtitle: LSSubtitle(text: context.watch<RadarrMoviesEditState>().qualityProfile?.name ?? Constants.TEXT_EMDASH),
        trailing: LSIconButton(icon: Icons.arrow_forward_ios),
        onTap: () async => _onTap(context),
    );

    Future<void> _onTap(BuildContext context) async {
        List _values = await RadarrDialogs.editQualityProfile(context, profiles);
        if(_values[0]) context.read<RadarrMoviesEditState>().qualityProfile = _values[1];
    }
}