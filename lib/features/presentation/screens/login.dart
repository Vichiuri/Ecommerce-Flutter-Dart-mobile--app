import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/presentation/bloc/forgot_password/forgot_password_bloc.dart';

import '../../../di/injection.dart';
import '../bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// final TextEditingController _usernameControl =
//     new TextEditingController(text: '');
// final TextEditingController _passwordControl =
//     new TextEditingController(text: '');

//*show/hide password
bool _obscureText = true;
String _email = "";
String _password = "";

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  final _authBloc = getIt<AuthBloc>();
  final _forgotPass = getIt<ForgotPasswordBloc>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _forgotPass.close();
    _authBloc.close();
    // _usernameControl.dispose();
    // _passwordControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _forgotController = TextEditingController();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => _authBloc),
        BlocProvider(create: (create) => _forgotPass),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.green,
                  // leading: Text("Success"),
                  position: NotificationPosition.bottom,
                );
              }
              if (state is ForgotPasswordError) {
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Text(
                        state.message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
              }
              if (state is ForgotPasswordLoading) {
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      duration: Duration(minutes: 10),
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularProgressIndicator.adaptive(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          Text(
                            "Sending email...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      duration: Duration(minutes: 10),
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularProgressIndicator.adaptive(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          Text(
                            "Logging in...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
              }
              if (state is AuthSuccess) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                // WidgetsBinding.instance?.addPostFrameCallback(
                //   (_) => AutoRouter.of(context).replace(MainScreenRoute()),
                // );
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  if (state.salesman) {
                    AutoRouter.of(context).replaceAll([InitializePageRoute()]);
                  } else {
                    AutoRouter.of(context).replaceAll([HomePageRoute()]);
                  }
                });
                // return
              }
              if (state is AuthError) {
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Text(
                        state.message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(30),
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/m_logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: 25.0,
                    ),
                    child: Text(
                      "Sign in to your account",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    elevation: 3.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          _email = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.black,
                          ),
                        ),
                        maxLines: 1,
                        // controller: _usernameControl,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Card(
                    elevation: 3.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          _password = value;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) => _authBloc.add(AuthLogin(
                          email: _email.toLowerCase().trim(),
                          password: _password.trim(),
                          // deviceId: "",
                        )),
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Password",
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            color: Colors.black,
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        obscureText: _obscureText,
                        maxLines: 1,
                        // controller: _passwordControl,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),

                  // SizedBox(height: 10.0),
                  Container(
                    // height: 50.0,
                    child: MaterialButton(
                      height: 40,
                      child: Container(
                        alignment: Alignment.center,
                        width: 200,
                        child: Text(
                          "LOGIN".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () => _authBloc.add(
                        AuthLogin(
                          email: _email.toLowerCase().trim(),
                          password: _password.trim(),
                        ),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                    child: Text("Forgot Password"),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (builder) => AlertDialog(
                        title: Text("RESET PASSWORD"),
                        content: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (RegExp(EMAIL_REGEX)
                                .hasMatch(value!.trim().toLowerCase())) {
                              return null;
                            } else {
                              return "email must be valid";
                            }
                          },
                          controller: _forgotController,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) => {
                            if (RegExp(EMAIL_REGEX)
                                .hasMatch(value.trim().toLowerCase()))
                              {Navigator.of(context).pop(true)}
                            else
                              {print("Validations msee")}
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: InputBorder.none,
                            hintText: "Enter your email",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(null),
                            child: Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () => {
                              if (RegExp(EMAIL_REGEX).hasMatch(
                                  _forgotController.text.trim().toLowerCase()))
                                {Navigator.of(context).pop(true)}
                              else
                                {print("Validations msee")}
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    )
                        .then((value) => {
                              if (value != null && value)
                                {
                                  _forgotPass.add(
                                    ForgotPasswordPressed(
                                        email: _forgotController.text
                                            .trim()
                                            .toLowerCase()),
                                  )
                                }
                            })
                        .catchError(
                          (e, s) => {
                            print("CANNOT LAUNCH URL: $e,$s"),
                          },
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
