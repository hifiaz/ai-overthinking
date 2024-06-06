import 'package:ai_overthinking/model/content_model.dart';
import 'package:ai_overthinking/service/firebase_service.dart';
import 'package:signals/signals_flutter.dart';

class ContentProvider {
  final content = ListSignal<ContentModel>([]);
  final contentFromFirebase = FutureSignal(() => FirebaseService().contents());
  final contentComputed = computed(() {
    final data = contentProvider.content.value;
    for (var i in contentProvider.contentFromFirebase.value.value ?? []) {
      if (!data.contains(i)) {
        data.add(i);
      }
    }
    return data;
  });
}

final contentProvider = ContentProvider();
