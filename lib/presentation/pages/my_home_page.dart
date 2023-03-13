import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/repositories/fetch/fetch.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetch = ref.watch(fetchProvider);
    final body = useState('');

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetch.setCookiesFromDevice();
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('fetch API'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await fetch.get('www.baidu.com');
          body.value = res.body;
          for (final cookie in fetch.cookies) {
            print('${cookie.name}=${cookie.value}');
          }
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
