import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_bloc.dart';
import 'package:foodbook_app/bloc/review_report_bloc/review_report_bloc.dart';
import 'package:foodbook_app/bloc/review_report_bloc/review_report_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_state.dart';
import 'package:foodbook_app/data/models/review.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/browse_view.dart';

class ReviewReportView extends StatefulWidget {
  final Review review;

  const ReviewReportView({
    super.key,
    required this.review,
  });

  @override
  _ReviewReportViewState createState() => _ReviewReportViewState();
}

class _ReviewReportViewState extends State<ReviewReportView> {
  String? _selectedOption;
  final TextEditingController _otherController = TextEditingController();

  Future<bool> _checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return (connectivityResult[0] != ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Review Report'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
          child: Column(
          children: [
            ListTile(
              title: const Text('Contains offensive content'),
              leading: Radio(
                value: 'Contains offensive content',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Contains offensive image'),
              leading: Radio(
                value: 'Contains offensive image',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Contains false information'),
              leading: Radio(
                value: 'Contains false information',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("It's spam"),
              leading: Radio(
                value: "It's spam",
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Other'),
              leading: Radio(
                value: 'Other',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedOption == 'Other') Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                controller: _otherController,
                decoration: const InputDecoration(
                  labelText: 'Please specify',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                maxLength: 180,
              ),
            ),
            const SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: ElevatedButton(
                onPressed: () async {
                  final hasConnection = await _checkConnection();
                  if (!hasConnection) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No Internet Connection!'),
                      )
                    );
                  } else {
                    if (_selectedOption == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a report reason!'),
                        )
                      );
                    } else {
                      final reviewReport = _selectedOption == 'Other' ? _otherController.text : _selectedOption!;
                      context.read<UserBloc>().add(GetCurrentUser());
                      final userBlocState = BlocProvider.of<UserBloc>(context).state;
                      if (userBlocState is AuthenticatedUserState) {
                        print('AUTENTICADO!');
                        context.read<ReviewReportBloc>().add(ReportReview(
                          reviewReport,
                          widget.review,
                          userBlocState.email,
                        ));
                        showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Thank you for making foodbook better!'),
                            content: const Text("You report has been sent! We will review and take further action if needed."),
                            actions: <Widget>[
                              TextButton(
                                child: const Center(
                                  child: Text('OK'),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<BrowseBloc>(
                                  create: (context) => BrowseBloc(
                                    restaurantRepository: RestaurantRepository(),
                                    reviewRepository: ReviewRepository(),
                                  )..add(LoadRestaurants()),
                                ),
                                BlocProvider(
                                  create: (context) => ReviewBloc(
                                    reviewRepository: ReviewRepository(),
                                    restaurantRepository: RestaurantRepository(),
                                  ),
                                ),
                                BlocProvider<BookmarkInternetViewBloc>(
                                create: (context) => BookmarkInternetViewBloc(),
                              )
                              ],
                              child: BrowseView(),
                            );
                          }),
                        );
                      }
                    }
                  }
                },
                child: const Text('Leave a report'),
              ),
            ),
          ],
        ),
      )
    );
  }
}
