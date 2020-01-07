import 'package:flutter/material.dart';
import 'package:lunasea/configuration/values.dart';
import 'package:lunasea/logic/clients/sabnzbd.dart';
import 'package:lunasea/system/ui.dart';

class SABnzbd extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return _SABnzbdWidget();
    }
}

class _SABnzbdWidget extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return _SABnzbdState();
    }
}

class _SABnzbdState extends State<StatefulWidget> {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    List<dynamic> _sabnzbdValues;

    @override
    void initState() {
        super.initState();
        _refreshData();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: _scaffoldKey,
            body: _sabnzbdSettings(),
            floatingActionButton: _buildFloatingActionButton(),
        );
    }

    void _refreshData() {
        if(mounted) {
            setState(() {
                _sabnzbdValues = List.from(Values.sabnzbdValues);
            });
        }
    }

    Widget _buildFloatingActionButton() {
        return FloatingActionButton(
            heroTag: null,
            tooltip: 'Save Settings',
            child: Elements.getIcon(Icons.save),
            onPressed: () async {
                await Values.setSabnzbd(_sabnzbdValues);
                Notifications.showSnackBar(_scaffoldKey, 'Settings saved');
            },
        );
    }

    Widget _sabnzbdSettings() {
        return Scrollbar(
            child: ListView(
                children: <Widget>[
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('Enable SABnzbd'),
                            trailing: Switch(
                                value: _sabnzbdValues[0],
                                onChanged: (value) {
                                    if(mounted) {
                                        setState(() {
                                            _sabnzbdValues[0] = value;
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
                            subtitle: Elements.getSubtitle(_sabnzbdValues[1] == '' ? 'Not Set' : _sabnzbdValues[1], preventOverflow: true),
                            trailing: IconButton(
                                icon: Elements.getIcon(Icons.arrow_forward_ios),
                                onPressed: null,
                            ),
                            onTap: () async {
                                List<dynamic> _values = await SystemDialogs.showEditTextPrompt(context, 'SABnzbd Host', prefill: _sabnzbdValues[1], showHostHint: true);
                                if(_values[0] && mounted) {
                                    setState(() {
                                        _sabnzbdValues[1] = _values[1];
                                    });
                                }
                            }
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                    Card(
                        child: ListTile(
                            title: Elements.getTitle('API Key'),
                            subtitle: Elements.getSubtitle(_sabnzbdValues[2] == '' ? 'Not Set' : '••••••••••••', preventOverflow: true),
                            trailing: IconButton(
                                icon: Elements.getIcon(Icons.arrow_forward_ios),
                                onPressed: null,
                            ),
                            onTap: () async {
                                List<dynamic> _values = await SystemDialogs.showEditTextPrompt(context, 'SABnzbd API Key', prefill: _sabnzbdValues[2]);
                                if(_values[0] && mounted) {
                                    setState(() {
                                        _sabnzbdValues[2] = _values[1];
                                    });
                                }
                            }
                        ),
                        margin: Elements.getCardMargin(),
                        elevation: 4.0,
                    ),
                    Elements.getButton('Test Connection', () async {
                        if(await SABnzbdAPI.testConnection(_sabnzbdValues)) {
                            Notifications.showSnackBar(_scaffoldKey, 'Connected successfully!');
                        } else {
                            Notifications.showSnackBar(_scaffoldKey, 'Connection test failed');
                        }
                    }),
                ],
                padding: Elements.getListViewPadding(),
            ),
        );
    }
}
