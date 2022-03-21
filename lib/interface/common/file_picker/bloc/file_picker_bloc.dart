import 'package:eazyweigh/interface/common/file_picker/bloc/file_picker_events.dart';
import 'package:eazyweigh/interface/common/file_picker/bloc/file_picker_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final FilePickerBloc fileBloc = FilePickerBloc();

class FilePickerBloc extends Bloc<FilePickerEvents, FilePickerStates> {
  FilePickerBloc() : super(FilePickerLoadedState());

  @override
  Stream<FilePickerStates> mapEventToState(FilePickerEvents event) async* {
    if (event is FilePicked) {
      event.controller.text = event.readPath.name;
      yield FilePickedState(event.readPath, event.controller);
    }
    if (event is FilePickerLoaded) {
      yield FilePickerLoadedState();
    }
  }
}
