import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/transcation.dart';
import 'package:intl/intl.dart';

class TranscationList extends StatelessWidget {
  final List<Transcation> transcations;
  final Function deleteTx;
  TranscationList(this.transcations, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: transcations.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: <Widget>[
                    Text(
                      'No transcation added yet!',
                      // ignore: deprecated_member_use
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/image/Image513.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('\Rs ${transcations[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      transcations[index].title,
                      // ignore: deprecated_member_use
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transcations[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 470
                        ? FlatButton.icon(
                            onPressed: () => deleteTx(transcations[index].id),
                            icon: Icon(Icons.delete),
                            label: const Text('Delete'),
                            textColor: Theme.of(context).errorColor,
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => deleteTx(transcations[index].id),
                          ),
                  ),
                );
              },
              itemCount: transcations.length,
            ),
    );
  }
}
