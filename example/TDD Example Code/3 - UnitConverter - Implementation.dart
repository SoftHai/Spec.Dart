

typedef num ConvertUnit(num srcValue); 

class UnitConverter {
  
  Map<String, ConvertUnit> _defenitions = new Map<String, ConvertUnit>();
  
  void define(String srcUnit, String destUnit, ConvertUnit convert) {
    this._defenitions["$srcUnit->$destUnit"] = convert;
  }
  
  num convert(num srcValue, String srcUnit, String destUnit) {
    
    if(this._defenitions.containsKey("$srcUnit->$destUnit")) {
      return this._defenitions["$srcUnit->$destUnit"](srcValue);
    }
    else {
      throw new UnitConvertException();
    }
    
  }
  
}

class UnitConvertException implements Exception {
  
}