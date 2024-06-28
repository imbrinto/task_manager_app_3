import 'package:flutter/material.dart';
import 'package:task_manager_3/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_3/ui/utilities/app_colors.dart';
import 'package:task_manager_3/ui/widgets/task_item.dart';
import 'package:task_manager_3/ui/widgets/task_summery_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          children: [
            buildSummerySection(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const TaskItem();
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        onPressed: _onTapNavAddNewTaskScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapNavAddNewTaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Widget buildSummerySection() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TaskSummeryCard(
            title: 'New Task',
            count: '34',
          ),
          TaskSummeryCard(
            title: 'Completed',
            count: '34',
          ),
          TaskSummeryCard(
            title: 'In Progress',
            count: '34',
          ),
          TaskSummeryCard(
            title: 'Cancelled',
            count: '34',
          ),
        ],
      ),
    );
  }
}
