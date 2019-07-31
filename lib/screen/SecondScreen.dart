import 'package:flutter/material.dart';
import 'package:flutter_localization_app/localization/localizations.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(child: Icon(Icons.arrow_back,),onTap: () => Navigator.of(context).pushReplacementNamed('/home'),),
        title: Text(AppLocalizations.of(context).title),
      ),
      body: Center(
        child: InkWell(

          child: Text(AppLocalizations.of(context).appSecondScreen) ,
        )
      ),
    );
  }
}
