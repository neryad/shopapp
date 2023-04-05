import 'package:PocketList/home/widgwets/menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buenas tardes Neryad'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: MyCard(
                iconData: Icons.shopping_bag_outlined,
                title: 'Shopping List',
                subtitle: '5 items',
                date: 'April 4, 2023',
                total: '\$25.00',
              ),

              //     Card(
              //   elevation: 1,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              //     child: Column(
              //       children: [
              //         Align(
              //           alignment: Alignment.topRight,
              //           child: IconButton(
              //               onPressed: () {},
              //               icon: const Icon(Icons.more_vert_rounded)),
              //         ),
              //         Align(
              //           alignment: Alignment.bottomLeft,
              //           child: Row(
              //             children: [
              //               IconButton(
              //                   onPressed: () {},
              //                   icon: Icon(Icons.energy_savings_leaf))
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // )

              //Text(
              //  'Aun no tiene listas registradas, presione el botn + para crear una nueva'),
            )
          ],
        ),
      ),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;
  final String date;
  final String total;

  MyCard({
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      // borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconData),
                SizedBox(width: 16),
                Text(title, style: Theme.of(context).textTheme.headline6),
              ],
            ),
            SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodyText2),
            SizedBox(height: 8),
            Row(
              children: [
                Text(date),
                Spacer(),
                Text(total, style: Theme.of(context).textTheme.headline6),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.edit_note_outlined)),
                IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete_outline,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
