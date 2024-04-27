import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:sciflare/src/database/database_services.dart';
import 'package:sciflare/src/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:sciflare/src/utils/utils.dart';
import 'package:toast/toast.dart';

class HomeController extends GetxController {
  DatabaseHelper? dbHelper;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxBool isLoading = false.obs;
  Client? httpClient;
  RxBool isDialogLoding = false.obs;

  @override
  void onInit() {
    httpClient = http.Client();
    dbHelper = DatabaseHelper();
    readAllEmpDetails();
    super.onInit();
  }

  void readAllEmpDetails() async {
    isLoading.value = true;
    update();

    try {
      var resposne = await httpClient!.get(Uri.parse(baseUrl));
       if (resposne.statusCode == 200) {
          List listItem = json.decode(resposne.body);
          await insertDatabase(listItem);
        }
        userList.value = await dbHelper!.getAllUsers();
        isLoading.value = false;
        update();
    } catch (e) {
      isLoading.value = false;
      update();
    }
  }

  Future<void> insertDatabase(List listItem) async {
    if (listItem.isNotEmpty) {
      await dbHelper!.clearAllRecord();
    }
    List<UserModel> list = listItem
        .map(
          (e) => UserModel.fromMap(e),
        )
        .toList();
    if (list.isNotEmpty) {
      list.forEach((element) async {
        await dbHelper!.insert(element);
      });
    }
  }

  addRecordDialog() {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final mobileController = TextEditingController();
    RxString selectedCategory = ''.obs;
    Get.defaultDialog(
        title: 'Add Employee detail',
        radius: 10.0,
        titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
        content: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      counterText: '',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 4))),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  maxLength: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email address',
                      counterText: '',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 4))),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  maxLength: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                      labelText: 'Mobile number',
                      counterText: '',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 4))),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.0,
                            color: Colors.grey,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    child: DropdownButton<String>(
                      items: <String>[
                        'Male',
                        'FeMale',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(selectedCategory.value.isEmpty
                          ? 'Gender'
                          : selectedCategory.value),
                      borderRadius: BorderRadius.circular(10),
                      underline: const SizedBox(),
                      isExpanded: true,
                      onChanged: (value) {
                        if (value != null) {
                          selectedCategory.value = value;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: const Text('Cancel',
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    //Spacer(),
                    Obx(
                      () => SizedBox(
                        height: 50,
                        width: 150,
                        child: TextButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty) {
                              showMessage("Name cannot be empty!");
                            } else if (emailController.text.isEmpty) {
                              showMessage("Email address cannot be empty!");
                            } else if (mobileController.text.isEmpty) {
                              showMessage("Mobile number cannot be empty!");
                            } else {
                              UserModel model = UserModel();
                              model.name = nameController.text;
                              model.email = emailController.text;
                              model.mobile = mobileController.text;
                              model.gender = selectedCategory.value;
                              model.id = 1;

                              await insertItem(model);
                              Get.back();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue[400]),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Submit',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              const SizedBox(
                                width: 10,
                              ),
                              isDialogLoding.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  showMessage(msg) {
    Toast.show(msg);
  }

  Future<void> insertItem(UserModel model) async {
    try {
      isDialogLoding.value = true;
      update();
      var response = await httpClient!.post(Uri.parse(baseUrl),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "name": model.name,
            "email": model.email,
            "mobile": model.mobile,
            "gender": model.gender
          }));
      isDialogLoding.value = false;
      update();
      readAllEmpDetails();
    } catch (e) {
      httpClient!.close();
      isDialogLoding.value = false;
      update();
    }
  }
}
