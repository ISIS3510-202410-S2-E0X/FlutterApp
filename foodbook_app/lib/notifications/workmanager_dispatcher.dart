import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  
  Workmanager().executeTask((task, inputData) {
    // Perform your task here
    print("background task executed");
    
    //showNotification();
    //showTestNotification();
    return Future.value(true);
  });
}
