import 'dart:async';
import 'dart:math';
import 'package:spec_dart/spec_dart.dart';
import '../login_controller.dart';


void main() {
  
  var suite = Suite.create();
  suite.interations(10);
  suite.add("Login / logoff")..setUp((context) { context.data["ctrl"] = new LoginController(); }) 
                              ..bench((context) { 
                                return new Future.delayed(new Duration(milliseconds: 500)).then((_) { // Simulate a constant 500ms run
                                  context.data["ctrl"].login("Soft", "Hai");
                                  context.data["ctrl"].logoff();
                                });
                                }, "Delay")
                               ..bench((context) { 
                                  var rnd = new Random();
                                  return new Future.delayed(new Duration(milliseconds: rnd.nextInt(1000))).then((_) { // Simulate a run which need between 0 and 1000ms
                                    context.data["ctrl"].login("Soft", "Hai");
                                    context.data["ctrl"].logoff();
                                  });
                                 }, "Random", 20);
  
  suite.run();
}