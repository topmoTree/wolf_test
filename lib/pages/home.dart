import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:wolf_test/data/moment_api.dart';
import 'package:wolf_test/utils/custom_expansion_tile.dart';
import 'package:wolf_test/utils/date_time_extensions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Moment> moments = MomentApi.getMoments();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wolfpack assessment"),
      ),
      //grouped list library link: https://pub.dev/packages/grouped_list
      //grouped by int, because in Dart no date class and it is easier to group by int like yyyyMMdd
      body: GroupedListView<dynamic, int>(
        elements: moments,
        groupBy: (element) => convertToDateInt((element as Moment).date),

        groupSeparatorBuilder: (dateTimeInt) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Text(intConvertToDateTime(dateTimeInt)),
        ),

        itemBuilder: (context, dynamic element) {
          var moment = element as Moment;
          return _buildExpandableTile(moment);
        },

        itemComparator: (element1, element2) {
          final moment1 = element1 as Moment;
          final moment2 = element2 as Moment;
          return moment1.date.compareTo(moment2.date);
        },
      ),
    );
  }

  bool areAllMedicineTaken(List<Medicine> medicines) {
    var taken = true;

    for (final med in medicines) {
      if (!med.taken) {
        taken = false;
        break;
      }
    }

    return taken;
  }

  int convertToDateInt(DateTime dateTime){
    return (dateTime.year * 100 + dateTime.month) * 100 + dateTime.day;
  }

  String intConvertToDateTime(int dateInt){
    int day = dateInt % 100;
    int yearAndMonth = dateInt ~/ 100;
    int month = yearAndMonth % 100;
    int year = yearAndMonth ~/ 100;
    final dateTime = DateTime(year, month, day);
    return dateTime.printDate();
  }

  Widget _buildExpandableTile(Moment moment){
    return CustomExpansionTile(
        onExpansionChanged: (value){
          moment.isCollapsed = !value;
        },
        hasIcon: false,
        initiallyExpanded: !moment.isCollapsed,
        title: Card(
          color: areAllMedicineTaken(moment.medicines) ? Colors.grey : Colors.white,

          child: ListTile(
            title: Text(moment.title),
            subtitle: Text(moment.date.printTime()),
            leading: moment.icon,
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: areAllMedicineTaken(moment.medicines)
                      ? const Icon(Icons.check_box)
                      : const Icon(Icons.check_box_outline_blank),

                  onPressed: () {
                    final currentTakenState = areAllMedicineTaken(moment.medicines);

                    setState(() {
                      for (var med in moment.medicines){
                        med.taken = !currentTakenState;
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ),
        children: moment.medicines.map((medicine) => _buildMedicineTile(medicine)).toList()
    );
  }

  Widget _buildMedicineTile(Medicine medicine) {
    return ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text(medicine.name)
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: medicine.taken
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),

              onPressed: () {
                setState(() {
                  medicine.taken = !medicine.taken;
                });
              },
            )
          ],
        ),
    );
  }
}
