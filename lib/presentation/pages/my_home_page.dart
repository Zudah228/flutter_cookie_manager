import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/repositories/fetch/fetch.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetch = ref.read(fetchProvider);
    final body = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('fetch API'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await fetch.getRequest('https://www.baidu.com');
          body.value = res.body;
          print(fetch.cookies.first.name);
        },
        child: const Text('Fetch'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Html(data: body.value),
        ),
      ),
    );
  }
}
