import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/profile/profile.dart';
import 'package:biz_mobile_app/features/presentation/bloc/password/password_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/profile/profile_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

///profile screen
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileModel? profileModel;
  PasswordBloc _passwordBloc = getIt<PasswordBloc>();
  ProfileBloc _profileBloc = getIt<ProfileBloc>();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _oldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileBloc.add(FetchProfileEventStarted());
  }

  @override
  void dispose() {
    _passwordBloc.close();
    _profileBloc.close();
    _passController.dispose();
    _oldController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _passwordBloc),
        BlocProvider(create: (create) => _profileBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PasswordBloc, PasswordState>(
            listener: (context, state) {
              if (state is PasswordSuccess) {
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.green,
                  position: NotificationPosition.bottom,
                );
              }
              if (state is PasswordError) {
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.red,
                  position: NotificationPosition.bottom,
                );
              }
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccess) {
                profileModel = state.profile.profile!;
              }
            },
          )
        ],
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProfileInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProfileError) {
                  return DashboardErrorWidget(
                    refresh: () => context.read<ProfileBloc>()
                      ..add(FetchProfileEventStarted()),
                  );
                }
                return ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: profileModel!.pic != null
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    IMAGE_URL + profileModel!.pic!,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage("assets/images/Slack.jpg"),
                                ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      profileModel!.name,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      profileModel!.email,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                          flex: 3,
                        ),
                      ],
                    ),
                    Divider(),
                    Container(height: 15.0),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Account Information".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Full Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        profileModel!.name,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        profileModel!.email,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        profileModel!.phone,
                      ),
                    ),
                    BlocBuilder<PasswordBloc, PasswordState>(
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: MaterialButton(
                            onPressed: () => state is PasswordLoading
                                ? print('Immanu')
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ResetPassword(
                                        // obscurePass: _obscurePass,
                                        oldController: _oldController,
                                        // obscureOld: _obscureOld,
                                        passController: _passController,
                                        // obscureConfirm: _obscureConfirm,
                                        confirmPassController:
                                            _confirmPassController,
                                      );
                                    }).then((value) {
                                    if (value != null && value) {
                                      if (_oldController.text.isNotEmpty &&
                                          _passController.text.isNotEmpty) {
                                        // Navigator.pop(context);
                                        _passwordBloc.add(
                                          ChangePasswordEventStarted(
                                            oldPass: _oldController.text.trim(),
                                            newPass:
                                                _passController.text.trim(),
                                          ),
                                        );

                                        _formKey.currentState!.reset();
                                      }
                                      _formKey.currentState!.reset();
                                    }
                                    print("Empty");
                                  }),
                            color: Colors.blue,
                            child: Text(
                              state is PasswordLoading
                                  ? "Changing Password..."
                                  : "Change Password",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    Key? key,
    // required bool obscurePass,
    required TextEditingController oldController,
    // required bool obscureOld,
    required TextEditingController passController,
    // required bool obscureConfirm,
    required TextEditingController confirmPassController,
  })  : _oldController = oldController,
        // _obscureOld = obscureOld,
        _passController = passController,
        // _obscureConfirm = obscureConfirm,
        _confirmPassController = confirmPassController,
        super(key: key);

  // final bool _obscurePass;
  final TextEditingController _oldController;
  // final bool _obscureOld;
  final TextEditingController _passController;
  // final bool _obscureConfirm;
  final TextEditingController _confirmPassController;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _obscureOld = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        // overflow: Overflow.visible,
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  obscureText: _obscureOld,
                  controller: widget._oldController,
                  validator: (value) {
                    if (widget._oldController.text.isEmpty) {
                      return "field required";
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureOld = !_obscureOld;
                        });
                      },
                      icon: Icon(
                        _obscureOld ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                    fillColor: Colors.grey[300],
                    filled: true,
                    hintText: "Old Password",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  obscureText: _obscurePass,
                  controller: widget._passController,
                  validator: (value) {
                    if (widget._passController.text.isEmpty) {
                      return "field required";
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePass = !_obscurePass;
                        });
                      },
                      icon: Icon(
                        _obscurePass ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                    fillColor: Colors.grey[300],
                    filled: true,
                    hintText: "New Password",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  obscureText: _obscureConfirm,
                  controller: widget._confirmPassController,
                  validator: (value) {
                    if (widget._confirmPassController.text.isEmpty) {
                      return "field required";
                    }
                    if (widget._passController.text !=
                        widget._confirmPassController.text) {
                      return "password must match";
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: "Confirm Password",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(true);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
