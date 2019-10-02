import 'package:flutter/material.dart';

import 'texts.dart';

class Tapable extends StatelessWidget {
  final Function onTap;
  final String label;
  final String assetImage;

  Tapable(this.label, {this.onTap, this.assetImage});

  @override
  Widget build(BuildContext context) {
    return (
      Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: InkWell(
            onTap: () { onTap(); },
            child: Column(
              children: <Widget>[

                this.assetImage != null
                  ? Image(
                      image: AssetImage(this.assetImage),
                      fit: BoxFit.fill,
                    )
                  : null,

                  PlainText(this.label, fontSize: 12,)
              ]
            ),
          )
        )
      )
    );
  }
}