import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sciflare/src/controller/home_controller.dart';
import 'package:sciflare/src/model/user_model.dart';
import 'package:toast/toast.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GetBuilder<HomeController>(
            builder: (controller) {
              return controller.isLoading.value
                  ? const Center(
                      child: SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator()),
                    )
                  : Column(
                    children: [
                      const Text(
                        'Employee details',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.userList.length,
                          itemBuilder: (context, index) {
                            UserModel model = controller.userList[index];
                            return buildItem(model);
                          },
                        ),
                      )
                    ],
                  );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[400],
          onPressed: () {
            Get.find<HomeController>().addRecordDialog();
          },
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget buildItem(UserModel model) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
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
        const Divider()
      ],
    );
  }
}
