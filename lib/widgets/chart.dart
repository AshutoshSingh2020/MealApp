import 'package:flutter/material.dart';
import '../models/transcation.dart';
import 'package:intl/intl.dart';
import '../widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transcation> recentTranscation;
  Chart(this.recentTranscation);
  List<Map<String, Object>> get groupedTranscationValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(
        days: index,
      ));
      var totalSum = 0.0;
      for (var i = 0; i < recentTranscation.length; i++) {
        if (recentTranscation[i].date.day == weekDay.day &&
            recentTranscation[i].date.month == weekDay.month &&
            recentTranscation[i].date.year == weekDay.year) {
          totalSum += recentTranscation[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTranscationValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTranscationValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
