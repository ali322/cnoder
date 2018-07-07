import "package:flutter/foundation.dart";
import "package:http/http.dart";
export "./topic.dart";
export "./me.dart";
export "./message.dart";
export "./collect.dart";

class SelectTab{
  final int index;

  SelectTab(this.index);
}

class StartLogin{
  final String accessToken;
  final VoidCallback afterFinished;

  StartLogin(this.accessToken, this.afterFinished);
}

class FinishLogin{
  final String accessToken;
  final String username;
  final String avatar;

  FinishLogin({this.accessToken, this.username, this.avatar});

  FinishLogin.empty(): this(accessToken: '', username: '', avatar: '');
}

class FinishLoginFailed extends FinishLogin{
  final ClientException err;

  FinishLoginFailed(this.err): super.empty();
}

class Logout{}

class ToggleLoading {
  final bool isLoading;

  ToggleLoading(this.isLoading);
}
