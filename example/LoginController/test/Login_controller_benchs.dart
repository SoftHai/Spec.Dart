import 'dart:async';
import 'package:spec_dart/spec_dart.dart';
import '../login_controller.dart';

void main() {
  
  var suite = Suite.create();
  suite.interations(10);
  suite.add("Login / logoff Benchs")..setUp((context) { context.data["ctrl"] = new LoginController(); }) 
                                    ..bench((context) { 
                                      return new Future.delayed(new Duration(seconds: 2));
                                      //context.data["ctrl"].login("Soft", "Hai");
                                       //context.data["ctrl"].logoff();
                                     }, "delay");
  
  suite.run();
}