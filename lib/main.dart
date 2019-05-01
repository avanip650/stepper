import 'package:flutter/material.dart';
import 'package:stepper/home.dart';

void main() => runApp(MaterialApp(
  home: MyStepper(),
  routes: {
//    "/homescreen": (_) => new HomeScreen(),
  },
));

class MyStepper extends StatefulWidget {
  @override
  _MyStepperState createState() => _MyStepperState();
}

class Details {
  String username = "";
  String email = "";
  String mobileNo = "";
}

class _MyStepperState extends State<MyStepper> {

 static Details mydetails = new Details();
 GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  int current_step = 0;

 /* List<Step> my_step = [
    new Step(title: new Text('Step 1'), content: new Text('User Name'),isActive: true),
    new Step(title: new Text('Step 2'), content: new Text('Email'),isActive: true),
    new Step(title: new Text('Step 3'), content: new Text('Mobile No.'),isActive: true),
  ];
*/

  List<Step> my_step = [
    new Step(title: new Text('Step 1'), isActive: true,
      content: new TextFormField(
        keyboardType: TextInputType.text,
        autocorrect: false,
        maxLines: 1,
        onSaved: (String userName){
          mydetails.username = userName;
          print(userName);
        },
        decoration: new InputDecoration(hintText: 'Enter UserName', labelText: 'UserName'),
        validator: (userName){
          if(userName.isEmpty || (userName.length < 1)){
            return 'Please enter the user Name';
          }
        },
      ),
    ),
    new Step(title: new Text('Step 2'),isActive: true ,
      content: new TextFormField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        maxLines: 1,
        onSaved: (String Email){
          mydetails.email = Email;
          print(mydetails.email);
        },
        decoration: new InputDecoration(hintText: 'Enter Email', labelText: 'Email'),
        validator: (Email){
          if (Email.isEmpty || !Email.contains('@')) {
            return 'Please enter valid email';
          }
        },
      ),
    ),
    new Step(title: new Text('Step 3'), isActive: true,
      content: new TextFormField(
     keyboardType: TextInputType.phone,
     autocorrect: false,
     maxLines: 1,
     onSaved: (String Mobileno){
     mydetails.mobileNo = Mobileno;
     },
     decoration: new InputDecoration(hintText: 'Enter MobileNo', labelText: 'MobileNo'),
     validator: (Mobileno){
       if (Mobileno.isEmpty || Mobileno.length < 10) {
         return 'Please enter valid number';
       }
     },
    ),
    )
  ];

  void _showDialog(){

    final FormState formState = _formKey.currentState;

    if (!formState.validate()) {
//      showSnackBarMessage('Please enter correct data');
    } else {
      formState.save();

      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Get Details:'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text("UserName:" + mydetails.username),
                    new Text("Email:" + mydetails.email),
                    new Text("MobileNo:" + mydetails.mobileNo),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
//                    Navigator.pushReplacementNamed(context, '/homescreen');
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) => new HomeScreen(mydetails.username)));
                    },
                    child: new Text('OK')
                ),
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('Cancle')
                )
              ],
            );
          }
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: new Text("Register Details"),
      ),
      body: new Container(
        child: new Form(
          key: _formKey,
          child: new Stepper(
              steps: my_step,
              currentStep: current_step,
            type: StepperType.vertical,

            onStepTapped: (step){
              setState(() {
                  current_step = step;
              });
            },
            onStepContinue: (){
                setState(() {
                  if(current_step < (my_step.length -1)){
                    current_step = current_step + 1;
//                    print(current_step);
                  }else{

                    _showDialog();

//                   Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context) => new HomeScreen()));
                  }
                });
            },
            onStepCancel: (){
              setState(() {
                if(current_step > 0){
                  current_step = current_step - 1;
                }else{
                  current_step = 0;
                }
              });
            },
          ),
      ),
      ),
    );
  }
}

