import 'package:flutter/material.dart';
import 'package:task_manager_3/data/models/network_response.dart';
import 'package:task_manager_3/data/models/task_model.dart';
import 'package:task_manager_3/data/network_caller/network_caller.dart';
import 'package:task_manager_3/data/utilities/urls.dart';
import 'package:task_manager_3/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_3/ui/widgets/show_snackbar_message.dart';

class TaskItem extends StatefulWidget {
  final TaskModel taskModel;
  final VoidCallback onUpdateTask;

  const TaskItem({
    super.key,
    required this.taskModel, required this.onUpdateTask,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _deleteInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        title: const Text('Title will be here'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.title ?? ''),
            Text(
              widget.taskModel.createdDate ?? '',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(widget.taskModel.status ?? 'New'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _deleteInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: IconButton(
                        onPressed: () {
                          _deleteTask();
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    _deleteInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.deleteTask(widget.taskModel.sId!));
    if (response.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackbarMessage(context, 'Task delete failed! Try again');
      }
    }
    _deleteInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
