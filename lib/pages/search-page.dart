import 'package:flutter/material.dart';
import 'package:flutterflavours/resources.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class FilterValues {
  String currentLocation = 'Venice';
  DateTime? currentDate;

  double currentRating = 7;
  RangeValues currentPriceRange = const RangeValues(46, 135);

  bool showCalendar = false;

  bool showAllCategories = false;

  int currentPage = 0;

  bool specialOfferOn = false;
}

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  FilterValues filterValues = FilterValues();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.5,
          title: Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              List<String> ret = Resources.locations.where((element) =>
                  (element.toLowerCase()).contains(
                      textEditingValue.text.toLowerCase())).toList();
              return ret;
            },
            onSelected: (String selection) {
              setState(() {
                filterValues.currentLocation = selection;
              });
            },
            initialValue: TextEditingValue(text: 'Venice'),
          ),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.add_location, color: Colors.black45,),
            )
          ],
          bottom: AppBar(
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(filterValues.currentDate != null
                  ? DateFormat.yMMMd().format(filterValues.currentDate!)
                  : 'Select date',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.black45,),
                onPressed: () {
                  setState(() {
                    filterValues.showCalendar = !filterValues.showCalendar;
                  });
                },)
            ],
            backgroundColor: Colors.white,
          )
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Categories', style: TextStyle(
                              fontSize: 24
                          ),),
                          TextButton(
                            child: Text(filterValues.showAllCategories ? 'See Less' : 'See All'),
                            onPressed: () {
                              filterValues.showAllCategories = !filterValues.showAllCategories;
                              setState(() {
                                filterValues.currentPage = 0;
                              });
                            },
                          )
                        ],
                      ),
                      !filterValues.showAllCategories ? Column(
                        children: [
                          Container(
                            height: 110,
                            child: PageView(
                                children: getCategories,
                              onPageChanged: (_){
                                  setState(() {
                                    filterValues.currentPage = _;
                                  });
                              },
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width/3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                    (Resources.categories.length / 4).ceil(), (index) =>
                                    Container(
                                      height: 7,
                                      width: 7,
                                      decoration: BoxDecoration(
                                          color: (filterValues.currentPage == index) ? Colors.black45 : Colors.black12,
                                          shape: BoxShape.circle
                                      ),
                                    )
                                ),
                              ),
                            ),
                          )
                        ],
                      ) : Column(
                        children: getCategories,
                      ),
                      Divider(
                        color: Colors.black45,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(filterValues.currentLocation, style: TextStyle(
                            fontSize: 24
                          ),),
                          Text('293 Restaurants', style: TextStyle(
                            fontSize: 12,
                            color: Colors.black38
                          ),)
                        ],
                      ),
                      Column(
                          children: List.generate(Resources.restaurants.length, (index) =>
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Image.asset(Resources.restaurants[index]['imgURL'],),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.add_location, color: Theme.of(context).backgroundColor,),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(Resources.restaurants[index]['address'], style: TextStyle(
                                          color: Theme.of(context).backgroundColor
                                        ),),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.fastfood,
                                            color: Theme.of(context).backgroundColor
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(Resources.restaurants[index]['cuisine'], style: TextStyle(
                                            color: Theme.of(context).backgroundColor
                                        ),)
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(Resources.restaurants[index]['name'], style: TextStyle(
                                          fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    )
                                  ],
                                ),
                              ))
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          filterValues.showCalendar ? Column(
            children: [
              Container(
                color: Colors.white,
                child: TableCalendar(
                  focusedDay: filterValues.currentDate ?? DateTime.now(),
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(Duration(days: 30)),
                  onDaySelected: (_, __) {
                    print(_.runtimeType);
                    setState(() {
                      filterValues.currentDate = _;
                    });
                  },
                  currentDay: filterValues.currentDate ?? DateTime.now(),
                  onFormatChanged: (_){},
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false
                  ),
                ),
              ),
              Expanded(child: GestureDetector(
                onTap: () => setState(() => filterValues.showCalendar = false),
                child: Container(
                  color: Colors.black26,
                ),
              ))
            ],
          ) : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(Icons.view_headline),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black38,
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//              ),
              padding: EdgeInsets.zero,
              duration: Duration(days: 1),
              content: Container(
                padding: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                    color: Colors.black38,
//                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                child: Container(
                  decoration: BoxDecoration(
//                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                  ),
                  child: ExtraFilters(filterValues)
                ),
              )),
          );
        },
      ),
    );
  }

  get getCategories => List.generate((Resources.categories.length/4).ceil(), (index) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: Resources.categories.sublist(index*4, Resources.categories.length < index*4+4 ? Resources.categories.length : index*4+4).toList().map((e) => Container(
        width: (MediaQuery.of(context).size.width - 48)/4,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              height: 65,
              width: 65,
              child: Icon(e['icon'], color: Colors.deepPurpleAccent,),
              decoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  borderRadius:
                  BorderRadius.circular(10)
              ),
            ),
            Text(e['label'], style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),)
          ],
        ),
      )).toList(),
    ),
  ));

}

class ExtraFilters extends StatefulWidget {

  final FilterValues filterValues;

  ExtraFilters(this.filterValues);

  @override
  State<StatefulWidget> createState() => _ExtraFiltersState();

}

class _ExtraFiltersState extends State<ExtraFilters> {

  FilterValues get filterValues => widget.filterValues;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.view_headline),
                    Text('More filters', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12.withOpacity(.05), width: 2),
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                      },
                      icon: Icon(Icons.close)
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black45,
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cuisines', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('All Cuisines', style: TextStyle(color: Colors.black38),),
                ],
              ),
              trailing: Icon(Icons.arrow_right),
              children: List.generate(Resources.cuisines.length, (index) =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Resources.cuisines[index]),
                      Checkbox(value: false, onChanged: (_) {})
                    ],
                  )),
            ),
            Divider(
              color: Colors.black45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Special offer', style: TextStyle(fontWeight: FontWeight.bold),),
                Switch(value: filterValues.specialOfferOn, onChanged: (_) =>setState(() {
                  filterValues.specialOfferOn = _;
                }))
              ],
            ),
            Divider(
              color: Colors.black45,
            ),
            Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold),)),
                RangeSlider(
                  activeColor: Theme.of(context).primaryColor,
                    values: filterValues.currentPriceRange,
                    max: 200,
                    min: 0,
                    divisions: 4,
                    labels: RangeLabels(
                      filterValues.currentPriceRange.start.toString(),
                      filterValues.currentPriceRange.end.toString(),
                    ),
                    onChanged: (values) {
                      filterValues.currentPriceRange = values;
                      setState(() {

                      });
                    }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$0'),
                    Text('\$200'),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.black45,
            ),
            Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: Text('Restaurant rating', style: TextStyle(fontWeight: FontWeight.bold),)),
                Slider(
                    value: filterValues.currentRating,
                    max: 10,
                    min: 6,
                    divisions: 4,
                    activeColor: Theme.of(context).primaryColor,
                    thumbColor: Theme.of(context).primaryColor,
                    label: filterValues.currentRating.toString(),
                    onChanged: (value) {
                      filterValues.currentRating = value;
                      setState(() {

                      });
                    }
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('6'),
                      Text('7'),
                      Text('8'),
                      Text('9'),
                      Text('10'),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black45,
            ),
            ExpansionTile(
              textColor: Colors.black,
              tilePadding: EdgeInsets.zero,
              title: Text('Michelin Guide', style: TextStyle(fontWeight: FontWeight.bold),),
              trailing: Icon(Icons.arrow_right),
              children: List.generate(Resources.restaurants
                  .where((element) => element['michelinRating'] != null)
                  .toList()
                  .length, (index) =>
                  Row(
                    children: [
                      Text(Resources.restaurants.where((
                          element) => element['michelinRating'] != null)
                          .toList()[index]['name']),
                      Row(
                        children: List.generate(Resources.restaurants.where((
                            element) =>
                        element['michelinRating'] != null)
                            .toList()[index]['michelinRating'], (i) =>
                            Icon(Icons.star)),
                      ),
                      Checkbox(value: false, onChanged: (_) {})
                    ],
                  )),
            ),
            Divider(
              color: Colors.black45,
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Services', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('All Services', style: TextStyle(color: Colors.black38)),
                ],
              ),
              trailing: Icon(Icons.arrow_right),
              children: List.generate(Resources.services.length, (index) =>
                  Row(
                    children: [
                      Text(Resources.services[index]),
                      Checkbox(value: false, onChanged: (_) {})
                    ],
                  )),
            ),
            Divider(
              color: Colors.black45,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.search, color: Colors.white,),
                  ),
                  Expanded(child: Center(
                    child: TextButton(child: Text('See 475 Restaurants', style: TextStyle(color: Colors.white),), onPressed: (){
                      ScaffoldMessenger.of(context).clearSnackBars();
                    },),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}