import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final SellerController controller = Get.put(SellerController());
  final OrderController orderController = Get.put(OrderController());
  final AuthController authController = Get.find<AuthController>();
  final Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: GetBuilder<SellerController>(
          initState: (_) async {
            controller.seller = (await database.getSeller(
              authController.user!.uid,
            ))!;
          },
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProfileCard(),
                  Container(
                    margin: EdgeInsets.only(top: 15.h),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xff212529),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Penjualan\nHari Ini',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xfff8f9fa),
                          ),
                        ),
                        Obx(() => Text(
                              PriceFormatter.format(
                                  orderController.totalSales.toInt()),
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xfff8f9fa),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  title(
                    'Akun',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xfff8f9fa),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xffced4da),
                      ),
                    ),
                    child: Column(
                      children: [
                        cards(
                          'Edit Profil',
                          Icons.person,
                          () {
                            Get.toNamed('/edit-profile-page',
                                arguments: controller.seller);
                          },
                        ),
                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),
                        cards(
                          'Edit Akun',
                          Icons.lock,
                          () {
                            Get.toNamed('/edit-account-page');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  title(
                    'Toko',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xfff8f9fa),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xffced4da),
                      ),
                    ),
                    child: Column(
                      children: [
                        cards(
                          'Info Toko',
                          Icons.store,
                          () {},
                        ),
                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),
                        cards(
                          'Riwayat Penjualan',
                          Icons.history,
                          () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  cards(String title, IconData icon, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xfff8f9fa),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xff212529),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  title(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 99, 103, 107),
      ),
    );
  }

  buildProfileCard() {
    var progress = controller.uploadProgress.value;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff212529),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          controller.loading.value
              ? CircleAvatar(
                  radius: 30,
                  child: Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(controller.seller.photoUrl),
                ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.seller.displayName,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xfff8f9fa),
                ),
              ),
              Text(
                controller.seller.email,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xfff8f9fa),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              authController.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
