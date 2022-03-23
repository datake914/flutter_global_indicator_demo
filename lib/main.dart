import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'loading_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap the provide scope.
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Global Loader Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (context, child) {
          return Stack(
            children: [
              if (child != null) child,
              Consumer(builder: (context, ref, child) {
                final isLoading = ref.watch(loadingServiceProvider);
                if (isLoading) {
                  return const ColoredBox(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          );
        },
        home: const GlobalIndicatorDemoPage(),
      ),
    );
  }
}

class GlobalIndicatorDemoPage extends StatelessWidget {
  const GlobalIndicatorDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Indicator Demo'),
      ),
      body: Center(
        child: Consumer(builder: (context, ref, child) {
          return ElevatedButton(
            child: const Text('Show Loader'),
            onPressed: () async {
              ref.read(loadingServiceProvider.notifier).wrap(
                    Future.delayed(const Duration(seconds: 3)),
                  );
            },
          );
        }),
      ),
    );
  }
}

class DialogPatternPage extends StatelessWidget {
  const DialogPatternPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog Pattern'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show Loader'),
          onPressed: () async {
            // Present the indicator.
            showDialog(
              context: context,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
            try {
              // Asynchronous processing such as API calls.
              await Future.delayed(const Duration(seconds: 3));
            } finally {
              // Dismiss the indicator.
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}

class StackWidgetPatternPage extends StatefulWidget {
  const StackWidgetPatternPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StackWidgetPatternPageState();
  }
}

class StackWidgetPatternPageState extends State<StackWidgetPatternPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Stack Widget Pattern'),
          ),
          body: Center(
            child: ElevatedButton(
              child: const Text('Show Loader'),
              onPressed: () async {
                // Present the indicator.
                setState(() {
                  isLoading = true;
                });
                try {
                  // Asynchronous processing such as API calls.
                  await Future.delayed(const Duration(seconds: 3));
                } finally {
                  // Dismiss the indicator.
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
          ),
        ),
        // Stack.
        if (isLoading)
          const ColoredBox(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}