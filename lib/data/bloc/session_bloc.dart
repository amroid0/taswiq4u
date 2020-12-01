import 'package:olx/data/bloc/bloc.dart';
import 'package:olx/model/login_api_response.dart';
import 'package:rxdart/rxdart.dart';

class SessionBloc extends Bloc{
  final _controller = BehaviorSubject<bool>();
  Stream<bool> get stream => _controller.stream;

  SessionBloc();




  @override
  void dispose() {
    // TODO: implement dispose
  }

}