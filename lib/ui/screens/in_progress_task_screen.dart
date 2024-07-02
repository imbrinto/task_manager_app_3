import 'package:flutter/material.dart';
import 'package:task_manager_3/data/models/network_response.dart';
import 'package:task_manager_3/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_3/data/models/task_model.dart';
import 'package:task_manager_3/data/network_caller/network_caller.dart';
import 'package:task_manager_3/data/utilities/urls.dart';
import 'package:task_manager_3/ui/widgets/show_snackbar_message.dart';
import 'package:task_manager_3/ui/widgets/task_item.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getCompletedTaskInProgress = false;
  List<TaskModel> inProgressTaskList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          // return const TaskItem();
        },
      ),
    );
  }
  Future<void> _getCompletedTasks() async {
    _getCompletedTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.inProgressTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      inProgressTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackbarMessage(context, 'Get new task failed! Try again');
      }
    }
    _getCompletedTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
