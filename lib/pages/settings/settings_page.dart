import 'package:flutter/material.dart';
import 'package:match_game/blocs/settings_bloc.dart';
import 'package:match_game/models/settings.dart';
import 'package:match_game/pages/settings/widgets/question_count_fields.dart';
import 'package:provider/provider.dart';

import 'widgets/number_selection_field.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  int _gamePieceCount;
  int _preGameTimer;
  int _gameTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<SettingsBloc>(context, listen: false).loadSettings();
  }

  void _onSave() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    Provider.of<SettingsBloc>(context, listen: false).updateSettings(
      _gamePieceCount,
      _preGameTimer,
      _gameTimer,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SettingsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: StreamBuilder<Settings>(
        stream: bloc.settings,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text('Error'),
            );

          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          final settings = snapshot.data;
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuestionCountFields(
                    label: 'Game Piece Count',
                    options: [4, 8, 16, 24, 32],
                    initialValue: settings.gamePieceCount,
                    validator: (value) => value.isNaN ? 'Required' : null,
                    onSaved: (value) => _gamePieceCount = value,
                  ),
                  Divider(),
                  NumberSelectionField(
                    label: 'Preview Timer (seconds)',
                    initialValue: settings?.preGameTimer,
                    validator: (value) => value <= 0 ? 'Required' : null,
                    onSaved: (value) => _preGameTimer = value,
                  ),
                  Divider(),
                  NumberSelectionField(
                    label: 'Game Timer (seconds)',
                    initialValue: settings?.gameTimer,
                    validator: (value) => value <= 0 ? 'Required' : null,
                    onSaved: (value) => _gameTimer = value,
                  ),
                  Divider(),
                  TextButton(
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    onPressed: _onSave,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
