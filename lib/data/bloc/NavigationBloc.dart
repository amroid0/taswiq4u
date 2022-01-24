import 'package:olx/data/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class NaviagtionBloc extends Bloc{
  final _contoller = BehaviorSubject<NavigationScreen>();
  Stream<NavigationScreen> get stream => _contoller.stream;
  NavigationScreen get currentScreen=>_contoller.value??NavigationScreen.HOME;


  void navigateToScreen(NavigationScreen screenEnum){
    _contoller.sink.add(screenEnum);
  }



  @override
  void dispose() {
_contoller.close();
    /*
    _controller.close();
    _viewController.close();
    _likeController.close();
    _imageController.close();*/
  }}

  enum NavigationScreen{
  HOME,FAVROITE,OFFER,MYADS,PRFOILE,SETTINGS,CONTACT_US,POLICY,RuLES,ABOUT,FAQ,SAFETY
  }