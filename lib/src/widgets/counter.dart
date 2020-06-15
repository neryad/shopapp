import 'package:flutter/material.dart';
import 'package:shopapp/src/pages/newList.dart';


class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State {
  int _count = 1;
  double total;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _count += 1;
   
              
            }); 
            
            //Navigator.push(context, new MaterialPageRoute(builder: (context) => new NewList(counter: new Counter())));
          },
          child: Container(
            width: 25.0,
            height: 25.0,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 111, 94, 1),
              shape: BoxShape.circle,
              //border: Border.all(),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 15.0,
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Text("$_count"),
        SizedBox(width: 15.0),
        GestureDetector(
          onTap: () {
            setState(() {
              if (_count <= 0) {
                return;
              }
              _count -= 1;
            });
          },
          child: Container(
            width: 25.0,
            height: 25.0,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 111, 94, 1),
              shape: BoxShape.circle,
              //border: Border.all(),
            ),
            child: Icon(
              Icons.remove,
              color: Colors.white,
              size: 15.0,
            ),
          ),
        ),
      ],
    );
  }


}
