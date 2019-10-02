import 'package:flutter/material.dart';
import 'package:tracking06/GoogleMapHome.dart';
import 'package:tracking06/Tab.dart/add_device.dart';
import 'package:tracking06/Tab.dart/history.dart';
import 'package:tracking06/Tab.dart/safetyzone.dart';
import 'package:tracking06/drawer.dart';


class AddTabs  extends StatefulWidget {
  @override
  _AddTabsState createState() => _AddTabsState();
}

class _AddTabsState extends State<AddTabs> {

  var _curIndex = 1;
  Widget contents = GoogleMapHome();


  

  Widget _indexBottom() => BottomNavigationBar(
    backgroundColor: Colors.grey[100],
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.devices,
              size: 25,
              color: Colors.grey[500],
            ),
            title: Text(
              "Add Device",
              style: TextStyle(
                  fontSize: 15, color: _curIndex == 0 ? Colors.black : Colors.grey[500],)
            ),
            activeIcon: Icon(
              Icons.devices,
              size: 25,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(            
            icon: Icon(
              Icons.location_on,
              size: 25,
              color: Colors.grey[500],
            ),
            title: Text(
              "Locate",
              style: TextStyle(
                  fontSize: 15, color: _curIndex == 1 ? Colors.black : Colors.grey[500],)
            ),
            activeIcon: Icon(
              Icons.location_on,
              size: 25,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.security,
              size: 25,
              color: Colors.grey[500],
            ),
             title: Text(
              "Safety Zone",
              style: TextStyle(
                  fontSize: 15, color: _curIndex == 2 ? Colors.black : Colors.grey[500],)
            ),
            activeIcon: Icon(
              Icons.security,
              size: 25,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: 25,
              color: Colors.grey[500],
            ),
            title: Text(
              "History",
              style: TextStyle(
                  fontSize: 15, color: _curIndex == 3 ? Colors.black : Colors.grey[500],)
            ),
            activeIcon: Icon(
              Icons.history,
              size: 25,
              color: Colors.black,
            ),
          ),         
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _curIndex,
        onTap: (index) {
          setState(() {
            _curIndex = index;
            switch (_curIndex) {
              case 0:
                contents = AddDevice();
                break;
              case 1:                
                contents = GoogleMapHome();     
                break;
              case 2:
              contents = SafetyZone();            
                break;
                 case 3:
                contents = History();
                break;
            }
          });
        },
      );
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(),  
      drawer:AddDrawer(),
      body: contents,
      bottomNavigationBar: _indexBottom(),
    );
  }
}
