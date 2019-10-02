import 'package:flutter/material.dart';

class PageAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 60.0;
  final VoidCallback backMethod;
  final VoidCallback exitMethod;
  PageAppBar(this.title, {this.backMethod, this.exitMethod});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + barHeight,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.chevron_left),
              color: this.backMethod != null ? Colors.black : Colors.transparent,
              onPressed: () => this.backMethod != null ? this.backMethod() : null
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24.0
              )
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              color: this.exitMethod != null ? Colors.red : Colors.transparent,
              onPressed: () => this.exitMethod != null ? this.exitMethod() : null
            ),
          )
        ],
      )
    );
  }
}