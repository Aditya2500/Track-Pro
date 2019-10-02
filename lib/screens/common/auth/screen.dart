import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/http_request.dart';
import '../../../services/debouncer.dart';
import '../../../utils/router.dart';

import 'elements/texts.dart';
import 'elements/input_fields.dart';
import 'elements/auth_buttons.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String username;
  String password;
  String avatar;

  TextEditingController accountEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  final Debouncer credentialsDebouncer = Debouncer(milliseconds: 300);

  FocusNode accountFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    this.setState(() => {
      username = "",
      password = "",
      avatar = null
    });

    this.accountEditingController.addListener(onAccountFieldChange);
    this.passwordEditingController.addListener(onPasswordFieldChange);
  }

  void onAccountFieldChange() {
    this.setState(() => {
      username = this.accountEditingController.text
    });
    credentialsDebouncer.run(() => this.checkCredentials());
  }

  void onPasswordFieldChange() {
    this.setState(() => {
      password = this.passwordEditingController.text
    });
    credentialsDebouncer.run(() => this.checkCredentials());
  }

  void authenticate() async {
    if (await AuthService.authenticate(this.username, this.password)) {
      Router.goToHome(this.context);
    }
  }

  void checkCredentials() async {
    try {
      this.setState(() => {
        avatar = null
      });
      RequestResultBody body = await AuthService.check(this.username, this.password);
      Map<String, dynamic> json = body.toJson();
      if (json.containsKey('user') || json['user'].containsKey('avatar')) {
        this.setState(() => {
          avatar = json['user']['avatar']
        });
        return;
      }
    }
    catch (exception) {}
  }

  void authenticateUsingGoogle() async {
    if (await AuthService.authenticateUsingGoogle()) {
      Router.goToHome(this.context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment(0.0, 0.0),
          constraints: BoxConstraints.expand(),
          // BACKGROUND
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/logo.jpeg"),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
            children: <Widget>[
              // APP NAME & LOGIN FORM
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child:
                              ClipOval(
                                child:
                                  avatar != null
                                    ? Image.network(
                                        avatar,
                                        fit: BoxFit.cover,
                                        width: 200.0,
                                        height: 200.0
                                      )
                                    : Image(
                                        image: AssetImage("assets/logo.jpeg"),
                                        fit: BoxFit.cover,
                                        width: 200.0,
                                        height: 200.0
                                      )
                              )
                          ),

                          HeroText(),

                          InputFieldArea(
                            hint: "Email",
                            obscure: false,
                            icon: Icons.email,
                            focusNode: accountFocusNode,
                            controller: accountEditingController,
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(passwordFocusNode);
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          InputFieldArea(
                            hint: "Password",
                            obscure: false,
                            icon: Icons.lock_outline,
                            focusNode: passwordFocusNode,
                            controller: passwordEditingController,
                            onFieldSubmitted: (String value) {
                              this.authenticate();
                            },
                            textInputAction: TextInputAction.go,
                          ),
                          AuthButton(
                            onTap: () { this.authenticate(); }
                          ),

                          OrText(),

                          GoogleAuthButton(
                            onTap: () { this.authenticateUsingGoogle(); }
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              )
            ],
          )
        ),
      )
    );
  }
}