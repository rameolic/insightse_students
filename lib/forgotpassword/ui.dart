import '../effects/effects.dart';
import '../Contsants.dart';
import 'package:flutter/material.dart';
import '../sign_in/tracking_text_input.dart';
import 'package:flushbar/flushbar.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../forgotpassword/api.dart';
import '../sign_in/sign_in.dart';
class ForgotPasswordui extends StatelessWidget {
  String userid;
  String otp;
  String mobilenumber;
  String username;
  ForgotPasswordui({@required this.userid,@required this.otp,@required this.mobilenumber,@required this.username});
  @override
  void initState() {
    progress.value = 0;
  }
  final progress = new ValueNotifier(0);
  final otpstatus = new ValueNotifier(false);
  final resendstatus = new ValueNotifier(false);
  String newpassword;
  String confirmnewpassword;
  var defaultDuration = Duration(minutes: 1);
  static const defaultPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  @override
  Widget build(BuildContext context) {
    OtpFieldController Otpcontroller = OtpFieldController();
    return SafeArea(
      child:
      Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 290,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topCenter,
                      colors: [
                        secondarycolor,
                        Colors.white,
                        //style.Style.lowerGradientColor,
                      ],
                    ),
                  ),
                  // BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(40.0),
                  // ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/InsightsELogo.png",
                            width: MediaQuery.of(context).size.width/3,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ValueListenableBuilder<bool>(
                              valueListenable: otpstatus,
                              builder: (context, value, child) {
                                return AnimatedCrossFade(
                                    firstChild:
                                    ValueListenableBuilder<bool>(
                                        valueListenable: resendstatus,
                                        builder: (context, value, child) {
                                          return Container(
                                      height: MediaQuery.of(context).size.height/5,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Verify your otp that was sent to ",style: TextStyle(color: Colors.black45),),
                                                  Text(mobilenumber,style: TextStyle(color: secondarycolor),),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 12,),
                                            Center(
                                              child: OTPTextField(
                                                onCompleted: (value)async {
                                                  progress.value = 1;
                                                  if (await verifyotp(userid,value,mobilenumber,context)) {
                                                    progress.value = 0;
                                                    print("here");
                                                    ///small haptic feedback is given to user to notify if OTP is valid
                                                    SmallHapticFeedback(true);
                                                    otpstatus.value = true;
                                                  } else {
                                                    progress.value = 0;
                                                    print("Incorrect");
                                                    if(value.length == 4){
                                                      ///large haptic feedback is given to user to notify if OTP is invalid
                                                      SmallHapticFeedback(false);
                                                    }
                                                  }
                                                },
                                                length: 4,
                                                controller: Otpcontroller,
                                                width: MediaQuery.of(context).size.width / 2,
                                                fieldWidth: 40,
                                                style: TextStyle(fontSize: 17),
                                                textFieldAlignment: MainAxisAlignment.spaceAround,
                                                fieldStyle: FieldStyle.box,
                                              ),
                                            ),
                                            if(!resendstatus.value)
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SlideCountdown(
                                                onDone: () async{
                                                  resendstatus.value = true;
                                                },
                                                duration: defaultDuration,
                                                padding: defaultPadding,
                                                slideDirection: SlideDirection.up,
                                                fade: true,
                                                decoration: BoxDecoration(
                                                    color: secondarycolor,
                                                    borderRadius: BorderRadius.circular(10)),
                                                icon: Padding(
                                                  padding: EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    Icons.alarm,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if(resendstatus.value)
                                            TextButton(
                                                onPressed: () async{
                                                  if(await  resendotp(username,mobilenumber,context)) {
                                                    resendstatus.value =
                                                    !resendstatus.value;
                                                  }
                                                },
                                                child: Text(
                                                  "Resend Otp ?",
                                                  style: TextStyle(
                                                      color: secondarycolor,
                                                      fontSize: 12),
                                                )),
                                          ],
                                        ),
                                      ),
                                    );}),
                                    secondChild: Container(
                                      height: MediaQuery.of(context).size.height/5,
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Verification successful for ",style: TextStyle(color: Colors.black45),),
                                              Text(username,style: TextStyle(color: secondarycolor),),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          TrackingTextInput(
                                            onTextChanged: (String email) {
                                              newpassword = email;
                                            },
                                            label: "New Password",
                                            icon: Icons.person,
                                            enable: true,
                                          ),
                                          TrackingTextInput(
                                            label: "Confirm New Password",
                                            isObscured: true,
                                            onTextChanged: (String password) {
                                              confirmnewpassword = password;
                                            },
                                            icon: Icons.phone_iphone_rounded,
                                            enable: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    crossFadeState: otpstatus.value
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration:
                                    const Duration(milliseconds: 200));
                              }),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 2),
                      child: ValueListenableBuilder<int>(
                          valueListenable: progress,
                          builder: (context, value, child) {
                            return FloatingActionButton(
                              onPressed: () async{
                                    if(newpassword.length>7){
                                      if (newpassword ==
                                          confirmnewpassword) {
                                        progress.value = 1;
                                        if(await changepassword(newpassword,
                                            confirmnewpassword, context)){
                                          forgotpasswordui.value = false;
                                          forgotpassword.value = false;
                                        }
                                        progress.value = 0;
                                      }
                                    }else{
                                      Flushbar(
                                        message: "Password must contain minimum of 8 characters",
                                        icon: const Icon(
                                          Icons.info_outline,
                                          size: 20.0,
                                          color: secondarycolor,
                                        ),
                                        duration: const Duration(seconds: 4),
                                        leftBarIndicatorColor: secondarycolor,
                                      ).show(context);
                                    }
                                  },
                              tooltip: "Sign in",
                              child: progress.value == 0
                                  ? Icon(
                                Icons.arrow_forward_ios_rounded,
                                color:
                                secondarycolor.withOpacity(0.5),
                              )
                                  : progress.value == 1
                                  ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: secondarycolor,
                                ),
                              )
                                  : Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              backgroundColor: progress.value == 1
                                  ? Colors.white
                                  : progress.value == 2
                                  ? Colors.green
                                  : borderyellow,
                            );
                          })),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
