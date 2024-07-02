import 'package:flutter/material.dart';
import 'package:task_manager_3/data/models/network_response.dart';
import 'package:task_manager_3/data/models/task_by_status_count_wrapper_model.dart';
import 'package:task_manager_3/data/models/task_count_by_status_model.dart';
import 'package:task_manager_3/data/models/task_list_wrapper_model.dart';
import 'package:task_manager_3/data/models/task_model.dart';
import 'package:task_manager_3/data/network_caller/network_caller.dart';
import 'package:task_manager_3/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_3/ui/utilities/app_colors.dart';
import 'package:task_manager_3/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_3/ui/widgets/show_snackbar_message.dart';
import 'package:task_manager_3/ui/widgets/task_item.dart';
import 'package:task_manager_3/ui/widgets/task_summery_card.dart';

import '../../data/utilities/urls.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskInProgress = false;
  bool _getTaskCountByStatusInProgress = false;
  List<TaskModel> newTaskList = [];
  List<TaskCountByStatusModel> taskCountByStatusList = [];

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTasks();
  }

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
              child: RefreshIndicator(
                onRefresh: () async {
                  _getNewTasks();
                  _getTaskCountByStatus();
                },
                child: Visibility(
                  visible: _getNewTaskInProgress == false,
                  replacement: const CenteredProgressIndicator(),
                  child: ListView.builder(
                      itemCount: newTaskList.length,
                      itemBuilder: (context, index) {
                        return TaskItem(taskModel: newTaskList[index], onUpdateTask: () {
                          _getNewTasks();
                          _getTaskCountByStatus();
                        },);
                      }),
                ),
              ),
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
    return  Visibility(
      visible: _getTaskCountByStatusInProgress == false,
      replacement: const SizedBox(
        height: 100,
        child: CenteredProgressIndicator(),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: taskCountByStatusList.map((e){
            return TaskSummeryCard(
              title: (e.sId ?? 'Unknown').toUpperCase(),
              count: e.sum.toString(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _getNewTasks() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.newTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(response.responseData);
      newTaskList = taskListWrapperModel.taskList ?? [];
    } else {
      if (mounted) {
        showSnackbarMessage(context, 'Get new task failed! Try again');
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
          TaskCountByStatusWrapperModel.fromJson(response.responseData);
      taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      if (mounted) {
        showSnackbarMessage(
            context, 'Get task count by status failed! Try again');
      }
    }
    _getTaskCountByStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
