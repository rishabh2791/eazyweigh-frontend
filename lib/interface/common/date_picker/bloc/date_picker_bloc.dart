import 'package:eazyweigh/interface/common/date_picker/bloc/date_picker_events.dart';
import 'package:eazyweigh/interface/common/date_picker/bloc/date_picker_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final DatePickerBloc dateBloc = DatePickerBloc();

class DatePickerBloc extends Bloc<DatePickerEvents, DatePickerStates> {
  DatePickerBloc() : super(DatePickerLoadedState());

  @override
  Stream<DatePickerStates> mapEventToState(DatePickerEvents event) async* {
    if (event is DatePickerLoaded) {
      yield DatePickerLoadedState();
    }
    if (event is DatePicked) {
      event.controller.text = event.pickedDate.toString().substring(0, 10);
      yield DatePickedState(event.pickedDate, event.controller);
    }
  }
}
