import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  final List<String> columnNames;
  final void Function(int index) onEdit;
  final void Function(int index) onDelete;

  const CustomDataTable({
    Key? key,
    required this.data,
    required this.title,
    required this.columnNames,
    required this.onEdit,
    required this.onDelete,
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: DataTable(
              columnSpacing: 20.0, // Adjust column spacing
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ],
      ),
    );
  } // Fim do build

  List<DataColumn> _buildColumns() {
    return columnNames.map((name) => DataColumn(label: Text(name))).toList() +
        [DataColumn(label: Text('Editar')), DataColumn(label: Text('Deletar'))];
  }

  List<DataRow> _buildRows() {
    return data!
        .asMap()
        .entries
        .map(
          (entry) => DataRow(
            color: entry.key.isEven
                ? MaterialStateProperty.all<Color>(Colors.white)
                : MaterialStateProperty.all<Color>(Colors.grey[200]!),
            cells: entry.value.keys
                    .map(
                      (key) => DataCell(
                        Text(
                          entry.value[key].toString(),
                          style: const TextStyle(
                            // Customize cell text style
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                    .toList() +
                [
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        onEdit!(entry.key);
                      },
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        onDelete!(entry.key);
                      },
                    ),
                  ),
                ],
          ),
        )
        .toList();
  }
}
