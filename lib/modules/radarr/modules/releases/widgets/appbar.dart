import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrReleasesSearchBar extends StatefulWidget implements PreferredSizeWidget {
    final ScrollController scrollController;

    RadarrReleasesSearchBar({
        Key key,
        @required this.scrollController,
    }) : super(key: key);

    @override
    Size get preferredSize => Size.fromHeight(62.0);

    @override
    State<RadarrReleasesSearchBar> createState() => _State();
}

class _State extends State<RadarrReleasesSearchBar> {
    final TextEditingController _controller = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Consumer<RadarrState>(
            builder: (context, state, _) => Row(
                children: [
                    Expanded(
                        child: LunaTextInputBar(
                            controller: _controller,
                            autofocus: false,
                            onChanged: (value) => context.read<RadarrReleasesState>().searchQuery = value,
                            margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 14.0),
                        ),
                    ),
                    RadarrReleasesAppBarFilterButton(controller: widget.scrollController),
                    RadarrReleasesAppBarSortButton(controller: widget.scrollController),
                ],
            ),
        );
    }
}
