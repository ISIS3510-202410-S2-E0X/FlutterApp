// filter_widget.dart
class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String _selectedPrice = '';
  double _selectedDistance = 0.0;
  String _selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add your price range filter widget here
        // For example, a dropdown or a set of radio buttons

        // Add your distance filter widget here
        // For example, a slider

        // Add your category filter widget here
        // For example, a text field
        TextField(
          decoration: InputDecoration(labelText: 'Category'),
          onChanged: (value) {
            _selectedCategory = value;
          },
        ),

        ElevatedButton(
          onPressed: () {
            // Dispatch the FilterRestaurants event with selected filter values
            context.read<BrowseBloc>().add(FilterRestaurants(
              price: _selectedPrice,
              distance: _selectedDistance,
              category: _selectedCategory,
            ));
            Navigator.pop(context); // Close the filter dialog/widget
          },
          child: Text('Apply Filters'),
        ),
      ],
    );
  }
}
