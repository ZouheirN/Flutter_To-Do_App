import 'package:flutter/material.dart';

import '../widgets/card.dart';
import '../widgets/skeleton_shimmer.dart';

class IndividualTasksScreen extends StatefulWidget {
  const IndividualTasksScreen({super.key});

  @override
  State<IndividualTasksScreen> createState() => _IndividualTasksScreenState();
}

class _IndividualTasksScreenState extends State<IndividualTasksScreen> {
  late bool _isLoading;

  void getData() async {
    //TODO get data from DB

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    _isLoading = true;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: _isLoading
          ? ListView.separated(
              itemBuilder: (context, index) => Skeleton(
                height: 140,
                width: MediaQuery.sizeOf(context).width - 40,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: 5,
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TaskCard(
                    color: Theme.of(context).primaryColor,
                  ),
                  TaskCard(
                    color: Theme.of(context).primaryColor,
                  ),
                  TaskCard(
                    color: Theme.of(context).primaryColor,
                  ),
                  TaskCard(
                    color: Theme.of(context).primaryColor,
                  ),
                  TaskCard(
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
    );
  }
}
