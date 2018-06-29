import "package:flutter/foundation.dart";

abstract class InitializeContainer{
  void setInitialized();

  bool getInitialized();

  void initialize();
}