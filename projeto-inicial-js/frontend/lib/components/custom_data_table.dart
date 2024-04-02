import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;

  const CustomDataTable({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            child: DataTable(
              columns: data!.isNotEmpty!
                  ? data!.first.keys
                      .map((key) => DataColumn(label: Text(key.toUpperCase())))
                      .toList()
                  : [],
              rows: data!
                      .map(
                        (user) => DataRow(
                          cells: user.keys
                              .map(
                                (key) => DataCell(
                                  Text(user[key].toString()),
                                ),
                              )
                              .toList(),
                        ),
                      )
                      .toList(),
                  // [
                  //   DataCell(
                  //     IconButton(
                  //       icon: Icon(Icons.edit)
                  //         ),
                  //     ),
                  //   ),
                  //   DataCell(
                  //     IconButton(
                  //     icon: Icon(Icons.delete),
                  //   ))
                  // ],
            ),
          ),
        ],
      ),
    );
  }
}
