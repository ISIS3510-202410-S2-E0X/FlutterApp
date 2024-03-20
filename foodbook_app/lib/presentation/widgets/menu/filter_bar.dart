import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';


class FilterBar extends StatefulWidget {
  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  void _showFilterDialog() {
    String selectedPrice = '\$';
    double selectedDistance = 5.0;
    String selectedCategory = '';
    bool isPriceFilterEnabled = false;
    bool isDistanceFilterEnabled = false;
    bool isCategoryFilterEnabled = false;

    final browseBloc = context.read<BrowseBloc>();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: browseBloc,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Wrap(
                  children: <Widget>[
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<BrowseBloc>().add(FilterRestaurants(
                            name: null,
                            price: isPriceFilterEnabled ? selectedPrice : null,
                            distance: isDistanceFilterEnabled ? selectedDistance : null,
                            category: isCategoryFilterEnabled ? selectedCategory : null,
                          ));
                          Navigator.pop(context);
                        },
                        child: Text('Apply Filter'),
                      ),
                    ),
                    
                    
                    ListTile(
                      title: Text('Price Range'),
                      trailing: Switch(
                        value: isPriceFilterEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            isPriceFilterEnabled = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          isPriceFilterEnabled = !isPriceFilterEnabled;
                        });
                      },
                    ),
                    isPriceFilterEnabled
                        ? Center(
                            child: DropdownButton<String>(
                              value: selectedPrice,
                              onChanged: (value) {
                                setState(() {
                                  selectedPrice = value!;
                                });
                              },
                              items: ['\$', '\$\$', '\$\$\$', '\$\$\$\$']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          )
                        : Container(),
                    // ListTile(
                    //   title: Text('Distance (km)'),
                    //   trailing: Switch(
                    //     value: isDistanceFilterEnabled,
                    //     onChanged: (bool value) {
                    //       setState(() {
                    //         isDistanceFilterEnabled = value;
                    //       });
                    //     },
                    //   ),
                    //   onTap: () {
                    //     setState(() {
                    //       isDistanceFilterEnabled = !isDistanceFilterEnabled;
                    //     });
                    //   },
                    // ),
                    // isDistanceFilterEnabled
                    //     ? Slider(
                    //         min: 0.0,
                    //         max: 20.0,
                    //         divisions: 20,
                    //         label: '${selectedDistance.toStringAsFixed(1)} km',
                    //         value: selectedDistance,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             selectedDistance = value;
                    //           });
                    //         },
                    //       )
                    //     : Container(),
                    ListTile(
                      title: Text('Category'),
                      trailing: Switch(
                        value: isCategoryFilterEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            isCategoryFilterEnabled = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          isCategoryFilterEnabled = !isCategoryFilterEnabled;
                        });
                      },
                    ),
                    isCategoryFilterEnabled
                        ? TextField(
                            decoration: InputDecoration(
                              labelText: 'Category',
                              hintText: 'e.g., Italian, Vegan',
                            ),
                            onChanged: (value) {
                              selectedCategory = value;
                            },
                          )
                        : Container(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
    return 
    IconButton(
      icon: Icon(Icons.filter_list, color: Colors.black), // Filter icon color
      onPressed: _showFilterDialog,
    );
  }
}
