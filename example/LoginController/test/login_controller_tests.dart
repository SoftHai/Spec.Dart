import 'package:SpecDart/spec_dart.dart';
import 'package:unittest/unittest.dart';
import '../login_controller.dart';

void main() {
  
  SpecContext.language = SpecLanguage.en; // EN is default, just to demonstrate how to change the language 
  SpecContext.output = new HtmlOutputFormatter((m) => print(m));
  
  var feature = new Feature("UserManagement", "With this feature, user can have an account to protect here data");
  
  var story1 = feature.story("Login", asA: "user", iWant: "to login/logoff to my account", soThat: "I can get access to my data");
  
  story1.scenario("Login Test - Valid")
   ..given(text: "is a login controller", 
           func: (context) => context.data["ctrl"] =  new LoginController())
           
   ..when(text: "a user insert valid login data (user: Soft / password: Hai)", 
          func: (context) => context.data["ctrl"].login("Soft", "Hai"))
          
   ..than(text: "the user is Logged in", 
          func: (context) => context.data["ctrl"].isLogin);
  
  story1.scenario("Login Test - Invalid")
   ..given(text: "is a login controller", 
           func: (context) => context.data["ctrl"] =  new LoginController())
           
   ..when(text: "a user insert invalid login data (user: user / password: pw)", 
          func: (context) => context.data["ctrl"].login("user", "pw"))
          
   ..than(text: "the user is not Logged in", 
          func: (context) => expect(context.data["ctrl"].isLogin, isTrue));
 
  story1.scenario("Login Test - Example Data")
    ..given(text: "is a login controller", 
        func: (context) => context.data["ctrl"] =  new LoginController())
        
    ..when(text: "a user insert invalid login data (user: [user] / password: [pw])", 
           func: (context) => context.data["ctrl"].login(context.data["user"], context.data["pw"]))
              
    ..than(text: "the user is not Logged in", 
           func: (context) => expect(context.data["ctrl"].isLogin, context.data["successful"]))
  
    ..example([{ "user": "Soft", "pw": "Hai", "successful": true}, 
               { "user": "Hero", "pw": "Man", "successful": false}]);
  
   feature.run();
}