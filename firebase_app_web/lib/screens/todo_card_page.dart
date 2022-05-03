import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  TodoCard(
      {Key key,
      this.title,
      this.onChange,
      this.iconData,
      this.iconColor,
      this.check,
      this.index,
      this.iconBgColor,
      this.time})
      : super(key: key);
  String title;
  IconData iconData;
  Color iconColor;
  bool check;
  Color iconBgColor;
  String time;
  final Function onChange;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
              data: ThemeData(
                  primarySwatch: Colors.blue,
                  unselectedWidgetColor: const Color(0xFF5e616a)),
              child: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    value: check,
                    onChanged: (bool change) {
                      onChange(index);
                    }),
              )),
          Expanded(
              child: Container(
            height: 75,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color(0xff2a2e3d),
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 33,
                    width: 36,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      iconData,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      time,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
