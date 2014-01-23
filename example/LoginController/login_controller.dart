
class LoginController {
  
  bool _isLogin = false;
  bool get isLogin => this._isLogin;
  
  LoginController();
  
  bool login(String username, String password) {
    
    if(username == "Soft" && password == "Hai") {
      this._isLogin = true;
      return true;
    }
    else {
      return false;
    }
   
  }
  
  bool logoff() {
    
    if(this._isLogin) {
      this._isLogin = false;
      return true;
    }
    else {
      return false;
    }
    
  }
}