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
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text("Wolfpack assessment"),
                  bottom: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.list_alt)),
                      Tab(icon: Icon(Icons.calendar_today))
                    ],
                  ),
                ),
                body: TabBarView(children: [
                  _buildListOfMoments(),
                  _buildWeekAmountMedicine(),
                ]))));
  }

  Widget _buildListOfMoments() {
    //grouped list library link: https://pub.dev/packages/grouped_list
    //grouped by int, because in Dart no date class and it is easier to group by int like yyyyMMdd
    return GroupedListView<dynamic, int>(
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
    );
  }

  int convertToDateInt(DateTime dateTime) {
    return (dateTime.year * 100 + dateTime.month) * 100 + dateTime.day;
  }

  String intConvertToDateTime(int dateInt) {
    int day = dateInt % 100;
    int yearAndMonth = dateInt ~/ 100;
    int month = yearAndMonth % 100;
    int year = yearAndMonth ~/ 100;
    final dateTime = DateTime(year, month, day);
    return dateTime.printDate();
  }

  _buildExpandableTile(Moment moment) {
    return CustomExpansionTile(
        onExpansionChanged: (value) {
          moment.isCollapsed = !value;
        },
        hasIcon: false,
        textColor: Colors.black,
        iconColor: Colors.black,
        initiallyExpanded: !moment.isCollapsed,
        title: Card(
          color: isEveryMedicineTaken(moment.medicines)
              ? Colors.grey
              : Colors.white,
          child: ListTile(
            title: Text(moment.title),
            subtitle: Text(moment.date.printTime()),
            leading: moment.icon,
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: isEveryMedicineTaken(moment.medicines)
                      ? const Icon(
                          Icons.check_box,
                          color: Colors.white,
                        )
                      : const Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    final currentTakenState =
                        isEveryMedicineTaken(moment.medicines);

                    setState(() {
                      for (var med in moment.medicines) {
                        med.taken = !currentTakenState;
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ),
        children: moment.medicines
            .map((medicine) => _buildMedicineTile(medicine))
            .toList());
  }

  bool isEveryMedicineTaken(List<Medicine> medicines) {
    var taken = true;

    for (final med in medicines) {
      if (!med.taken) {
        taken = false;
        break;
      }
    }

    return taken;
  }

  Widget _buildMedicineTile(Medicine medicine) {
    return ListTile(
      title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Text(medicine.name)),
      subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Text(
              "${medicine.tabletsQty} tablets, ${medicine.milligramsPerTablet} mg")),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: medicine.taken
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
              onPressed: () {
                setState(() {
                  medicine.taken = !medicine.taken;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeekAmountMedicine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("January 7 - 14",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Amount of tablets: ${calculateTablets(moments)}",
              style: const TextStyle(fontSize: 18.0)),
          const SizedBox(height: 10),
          Text("Milligrams: ${calculateMilligrams(moments)}",
              style: const TextStyle(fontSize: 18.0))
        ],
      ),
    );
  }

  ///Calculate amount of tablets from 07.01.19 to 14.01.19
  int calculateTablets(List<Moment> moments) {
    var tablets = 0;
    var startDate = DateTime(2019, 01, 07);
    var finishDate = DateTime(2019, 01, 14);

    for (var moment in moments) {
      if (moment.date.isAfter(startDate) && moment.date.isBefore(finishDate)) {
        for (var medicine in moment.medicines) {
          if (medicine.taken) tablets += medicine.tabletsQty;
        }
      }
    }

    return tablets;
  }

  ///Calculate milligrams amount from 07.01.19 to 14.01.19
  int calculateMilligrams(List<Moment> moments) {
    var mg = 0;
    var startDate = DateTime(2019, 01, 07);
    var finishDate = DateTime(2019, 01, 14);

    for (var moment in moments) {
      if (moment.date.isAfter(startDate) && moment.date.isBefore(finishDate)) {
        for (var medicine in moment.medicines) {
          if (medicine.taken) {
            mg += medicine.tabletsQty * medicine.milligramsPerTablet;
          }
        }
      }
    }

    return mg;
  }
}
