import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

class PreferenceForm extends StatefulWidget {
  bool? firstTime;
  PreferenceForm({super.key, this.firstTime});

  @override
  _PreferenceFormState createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {
  bool petsAllowed = false;
  bool smokingAllowed = false;
  bool drinkAllowed = false;
  bool visitAllowed = false;
  bool noiseAllowed = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: screenHeight * 0.15),
              children: [
                SizedBox(height: 10), 
                _buildQuestionContainer(
                  'Permites mascotas dentro de la propiedad?',
                  _buildPetsQuestion(),
                ),
                SizedBox(height: 10),
                _buildQuestionContainer(
                  'Permites fumar dentro de la propiedad?',
                  _buildSmokingQuestion(),
                ),
                 SizedBox(height: 10),
                _buildQuestionContainer(
                  '¿Estás bien con que los residentes tengan visitas con regularidad?',
                  _buildVisitQuestion(),
                ),
                SizedBox(height: 10),
                _buildQuestionContainer(
                  '¿Permites tomar dentro de la propiedad?',
                  _buildDrinkQuestion(),
                ),
                SizedBox(height: 10),
                _buildQuestionContainer(
                  '¿Permites el ruido?',
                  _buildNoiseQuestion(),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildAppBar(context),
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildAppBar(BuildContext context) {
    if (widget.firstTime == false) { 
      return CustomAppBar(
        backgroundColor: Colors.white,
        leadingWidth: 48,
        leftText: "Atrás",
        rightText: 'Siguiente',
        showBoxShadow: false,
        onTapLeftText: () { 
          Navigator.pop(context);
        },
        onTapRigthText: () {
          _savePreferences();
        },
      );
    } else {
      return CustomAppBar(
        backgroundColor: Colors.white,
        leadingWidth: 48,
        rightText: 'Siguiente',
        showBoxShadow: false,
        onTapRigthText: () {
          _savePreferences();
        },
      );
    }
  }
  Widget _buildQuestionContainer(String question, Widget questionWidget) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 8),
          questionWidget,
        ],
      ),
    );
  }

  Widget _buildPetsQuestion() {
    return Row(
      children: <Widget>[
        Radio(
          value: true,
          groupValue: petsAllowed,
          onChanged: (value) {
            setState(() {
              petsAllowed = value!;
            });
          },
        ),
        Text('Sí'),
        Radio(
          value: false,
          groupValue: petsAllowed,
          onChanged: (value) {
            setState(() {
              petsAllowed = value!;
            });
          },
        ),
        Text('No'),
      ],
    );
  }

  Widget _buildVisitQuestion() {
    return Row(
      children: <Widget>[
        Radio(
          value: true,
          groupValue: visitAllowed,
          onChanged: (value) {
            setState(() {
              visitAllowed = value!;
            });
          },
        ),
        Text('Sí'),
        Radio(
          value: false,
          groupValue: visitAllowed,
          onChanged: (value) {
            setState(() {
              visitAllowed = value!;
            });
          },
        ),
        Text('No'),
      ],
    );
  }

  Widget _buildDrinkQuestion() {
    return Row(
      children: <Widget>[
        Radio(
          value: true,
          groupValue: drinkAllowed,
          onChanged: (value) {
            setState(() {
              drinkAllowed = value!;
            });
          },
        ),
        Text('Sí'),
        Radio(
          value: false,
          groupValue: drinkAllowed,
          onChanged: (value) {
            setState(() {
              drinkAllowed = value!;
            });
          },
        ),
        Text('No'),
      ],
    );
  }
  
  Widget _buildSmokingQuestion() {
    return Row(
      children: <Widget>[
        Radio(
          value: true,
          groupValue: smokingAllowed,
          onChanged: (value) {
            setState(() {
              smokingAllowed = value!;
            });
          },
        ),
        Text('Sí'),
        Radio(
          value: false,
          groupValue: smokingAllowed,
          onChanged: (value) {
            setState(() {
              smokingAllowed = value!;
            });
          },
        ),
        Text('No'),
      ],
    );
  }


  Widget _buildNoiseQuestion() {
    return Row(
      children: <Widget>[
        Radio(
          value: true,
          groupValue: noiseAllowed,
          onChanged: (value) {
            setState(() {
              noiseAllowed = value!;
            });
          },
        ),
        Text('Sí'),
        Radio(
          value: false,
          groupValue: noiseAllowed,
          onChanged: (value) {
            setState(() {
              noiseAllowed = value!;
            });
          },
        ),
        Text('No'),
      ],
    );
  }


void _savePreferences(){
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null){
    FirebaseFirestore.instance.collection('User').doc(user.uid).update({
      'firstTime': false,
      'preferences': {
        'petsAllowed': petsAllowed,
        'smokingAllowed': smokingAllowed,
        'drinkAllowed': drinkAllowed,
        'visitAllowed': visitAllowed,
        'noiseAllowerd': noiseAllowed
      }
    });
  }
  Navigator.pushNamed(context, AppRoutes.mainScreen);
}
}
