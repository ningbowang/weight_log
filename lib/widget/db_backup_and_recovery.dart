import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DbBackupAndRecovery extends StatefulWidget {
  const DbBackupAndRecovery({super.key});

  @override
  State<DbBackupAndRecovery> createState() => _DbBackupAndRecoveryState();
}

class _DbBackupAndRecoveryState extends State<DbBackupAndRecovery> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  bool _isLoading = false;
  String? _directoryPath;
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _saveAsFileName;
  bool _userAborted = false;
  bool _lockParentWindow = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: <Widget>[
          // SizedBox(
          //   width: 120,
          //   child: FloatingActionButton.extended(
          //     onPressed: () => _saveFile(),
          //     label: const Text('Save file'),
          //     icon: const Icon(Icons.save_as),
          //   ),
          // ),
          SizedBox(
            width: 120,
            child: FloatingActionButton.extended(
              onPressed: () => _selectFolder(),
              label: const Text('Pick folder'),
              icon: const Icon(Icons.folder),
            ),
          ),
        ],
      ),
    );
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath(
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      );
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }
}
