import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sciflare/src/controller/home_controller.dart';
import 'package:sciflare/src/model/user_model.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({super.key});
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[400],
        title: const Text(
          'Employee details',
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator()),
                )
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => controller.userList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: controller.userList.length,
                                itemBuilder: (context, index) {
                                  UserModel model = controller.userList[index];
                                  return buildItem(model);
                                },
                              )
                            : buildPlaceHolder(),
                      )
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[400],
        onPressed: () {
          Get.find<HomeController>().addRecordDialog();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget buildItem(UserModel model) {
    return Column(
      children: [
        const SizedBox(
          width: 20,
        ),
        Row(
          children: [
            const Text(
              'Name:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              model.name,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              'Email address:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              model.email,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              'Mobile number:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              model.mobile,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              'Gender:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              model.gender,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Divider()
      ],
    );
  }

  buildPlaceHolder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.no_accounts,
          size: 30,
        ),
        SizedBox(
          height: 10,
        ),
        Text('No Data found!.')
      ],
    );
  }
}
