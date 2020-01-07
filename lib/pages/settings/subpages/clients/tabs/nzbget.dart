import 'package:flutter/material.dart';
import 'package:lunasea/configuration/values.dart';
import 'package:lunasea/system/ui.dart';

class NZBGet extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _NZBGetWidget();
    }
}

class _NZBGetWidget extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return _NZBGetState();
    }
}

class _NZBGetState extends State<StatefulWidget> {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    List<dynamic> _nzbgetValues;

    @override
    void initState() {
        super.initState();
        _refreshData();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: _scaffoldKey,
            body: _nzbgetSettings(),
            floatingActionButton: _buildFloatingActionButton(),
        );
    }

    void _refreshData() {
        if(mounted) {
            setState(() {
                _nzbgetValues = List.from(Values.nzbgetValues);
            });
        }
    }

    Widget _buildFloatingActionButton() {
        return FloatingActionButton(
            heroTag: null,
            tooltip: 'Save Settings',
            child: Elements.getIcon(Icons.save),
            onPressed: () async {
                await Values.setNZBGet(_nzbgetValues);
                Notifications.showSnackBar(_scaffoldKey, 'Settings saved');
            },
        );
    }

    Widget _nzbgetSettings() {
        return Scrollbar(
            child: ListView(
                children: <Widget>[
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('Enable NZBGet'),
                            trailing: Switch(
                                value: _nzbgetValues[0],
                                onChanged: (value) {
                                    if(mounted) {
                                        setState(() {
                                            _nzbgetValues[0] = value;
                                        });
                                    }
                                },
                            ),
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('Host'),
                            subtitle: Elements.getSubtitle(_nzbgetValues[1] == '' ? 'Not Set' : _nzbgetValues[1], preventOverflow: true),
                            trailing: IconButton(
                                icon: Elements.getIcon(Icons.arrow_forward_ios),
                                onPressed: null,
                            ),
                            onTap: () async {
                                List<dynamic> _values = await SystemDialogs.showEditTextPrompt(context, 'NZBGet Host', prefill: _nzbgetValues[1], showHostHint: true);
                                if(_values[0] && mounted) {
                                    setState(() {
                                        _nzbgetValues[1] = _values[1];
                                    });
                                }
                            }
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('Username'),
                            subtitle: Elements.getSubtitle(_nzbgetValues[2] == '' ? 'Not Set' : _nzbgetValues[2], preventOverflow: true),
                            trailing: IconButton(
                                icon: Elements.getIcon(Icons.arrow_forward_ios),
                                onPressed: null,
                            ),
                            onTap: () async {
                                List<dynamic> _values = await SystemDialogs.showEditTextPrompt(context, 'NZBGet Username', prefill: _nzbgetValues[2]);
                                if(_values[0] && mounted) {
                                    setState(() {
                                        _nzbgetValues[2] = _values[1];
                                    });
                                }
                            }
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('Password'),
                            subtitle: Elements.getSubtitle(_nzbgetValues[3] == '' ? 'Not Set' : '••••••••••••', preventOverflow: true),
                            trailing: IconButton(
                                icon: Elements.getIcon(Icons.arrow_forward_ios),
                                onPressed: null,
                            ),
                            onTap: () async {
                                List<dynamic> _values = await SystemDialogs.showEditTextPrompt(context, 'NZBGet Password', prefill: _nzbgetValues[3]);
                                if(_values[0] && mounted) {
                                    setState(() {
                                        _nzbgetValues[3] = _values[1];
                                    });
                                }
                            }
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                    Elements.getButton('Test Connection', () async {
                    }),
                ],
                padding: Elements.getListViewPadding(),
            ),
        );
    }
}
