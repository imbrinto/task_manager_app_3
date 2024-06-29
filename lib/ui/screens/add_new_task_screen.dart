import 'package:flutter/material.dart';
import 'package:task_manager_3/data/models/network_response.dart';
import 'package:task_manager_3/data/network_caller/network_caller.dart';
import 'package:task_manager_3/data/utilities/urls.dart';
import 'package:task_manager_3/ui/widgets/background_widget.dart';
import 'package:task_manager_3/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_3/ui/widgets/profile_app_bar.dart';
import 'package:task_manager_3/ui/widgets/show_snackbar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: _titleTEController,
                  validator: (String? value){
                    if(value!.trim().isEmpty){
                      return 'Enter title';
                    }return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: _descriptionTEController,
                  validator: (String? value){
                    if(value!.trim().isEmpty){
                      return 'Enter description';
                    }return null;
                  },
                  maxLines: 4,
                  decoration: const InputDecoration(hintText: 'Decoration'),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _addNewTaskInProgress == false,
                  replacement: const CenteredProgressIndicator(),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addNewTask();
                        }
                      },
                      child: const Text('Add')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestData = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New",
    };
    NetworkResponse response = await NetworkCaller.postRequest(
      Urls.createTask,
      body: requestData,
    );
    _addNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if(response.isSuccess){
      _clearTextFields();
      if(mounted){
        showSnackbarMessage(context, 'New task added',);
      } else{
        if (mounted) {
          showSnackbarMessage(context, 'New task add failed! Try again.', true);
        }
      }
    }
  }

  void _clearTextFields(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
