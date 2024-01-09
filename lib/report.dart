import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  final List<Map<String, dynamic>> salesReport = [
    {
      'receiptNumber': 12345678,
      'numberOfProducts': 10,
      'netAmount': 500,
    },
    {
      'receiptNumber': 87654321,
      'numberOfProducts': 15,
      'netAmount': 750,
    },
    // Add more sales data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            headingRowHeight: 60.0,
            dataRowHeight: 60.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  'Sr No.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Receipt#',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
            rows: salesReport.asMap().entries.map((entry) {
              final data = entry.value;
              final index = entry.key;
              final color = index.isEven ? Colors.grey.shade200 : Colors.white;

              return DataRow(
                color: MaterialStateProperty.all(color),
                cells: <DataCell>[
                  DataCell(
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '${data['receiptNumber']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '${data['numberOfProducts']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '\$${data['netAmount']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
