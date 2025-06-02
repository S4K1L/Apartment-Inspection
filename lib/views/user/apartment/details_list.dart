import 'package:apartmentinspection/utils/components/finished_button.dart';
import 'package:apartmentinspection/utils/constant/const.dart';
import 'package:apartmentinspection/utils/constant/inspection_data.dart';
import 'package:apartmentinspection/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'inspection_form.dart';

class DetailsListPage extends StatelessWidget {
  final String apartmentNumber;
  final String apartmentUnit;
  final String apartmentName;
  final String roomName;

  DetailsListPage(
      {super.key,
      required this.roomName,
      required this.apartmentNumber,
      required this.apartmentUnit,
      required this.apartmentName});

  final List<RoomInspectionModel> rooms = [
    RoomInspectionModel(
      fr: "SALLE DE BAINS 1",
      en: "BATHROOM 1",
      checklist: [
        "Conduits flexibles et valves de la toilette",
        "Joints de céramique de la douche",
        "Calfeutrage de porte de douche",
        "État du drain sous le lavabo",
        "Dommages préexistants (moisissure, gypse, etc.)",
        "Siège bidet",
        "Douchette à main",
      ],
    ),
    RoomInspectionModel(
      fr: "SALLE DE BAINS 2",
      en: "BATHROOM 2",
      checklist: [
        "Conduits flexibles et valves de la toilette",
        "Joints de céramique de la douche",
        "Calfeutrage de porte de douche",
        "État du drain sous le lavabo",
        "Dommages préexistants (moisissure, gypse, etc.)",
        "Siège bidet",
        "Douchette à main",
      ],
    ),
    RoomInspectionModel(
      fr: "TOILETTE 1",
      en: "TOILETTE 1",
      checklist: [
        "Conduits flexibles et valves",
        "Dommages préexistants",
        "Siège bidet",
        "Douchette à main",
      ],
    ),
    RoomInspectionModel(
      fr: "TOILETTE 2",
      en: "TOILETTE 2",
      checklist: [
        "Conduits flexibles et valves",
        "Dommages préexistants",
        "Siège bidet",
        "Douchette à main",
      ],
    ),
    RoomInspectionModel(
      fr: "CUISINE",
      en: "CUISINE",
      checklist: [
        "Évier bien scellé",
        "Drain sous évier (rouille, fuite)",
        "Conduit d'eau du lave-vaisselle",
        "Réfrigérateur à eau – État de la valve et du conduit",
        "Âge des électroménagers",
      ],
    ),
    RoomInspectionModel(
      fr: "Salle mécanique / lavage",
      en: "Mechanical room / laundry",
      checklist: [
        "Conduits du chauffe-eau (rouille, suintement)",
        "Date d’installation du chauffe-eau",
        "Air climatisé (modèle, année)",
        "Inspection/entretien récent",
        "Conduits de la laveuse",
        "Drain de renvoi",
        "Conduit de sécheuse (nettoyage)",
        "Dommages préexistants visibles",
        "Type et âge des électroménagers",
      ],
    ),
    RoomInspectionModel(
      fr: "Diversas",
      en: "Divers",
      checklist: [
        "Calfeutrage des fenêtres/portes patio",
        "Thermos des portes/fenêtres",
        "Dommages plafond/plancher causés par l’eau",
        "Système Water-Protec",
        "Détecteur de fumée (date valide)",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Find the room by English name
    final RoomInspectionModel? selectedRoom =
        rooms.firstWhereOrNull((room) => room.en == roomName);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: kBlackColor,
            )),
        title: Text("Details",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Image.asset(Const.bar, height: 26.sp),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: selectedRoom == null
          ? const Center(child: Text("Room not found"))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kPrimaryColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            selectedRoom.fr,
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: kWhiteColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            selectedRoom.en,
                            style:
                                TextStyle(fontSize: 16.sp, color: kWhiteColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: selectedRoom.checklist.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        return _buildRoomTile(
                          onPress: () {
                            Get.to(
                                () => InspectionFormPage(
                                      apartmentNumber: apartmentNumber,
                                      apartmentUnit: apartmentUnit,
                                      roomName: roomName,
                                      apartmentName: apartmentName,
                                      checkingName: selectedRoom.checklist[index],
                                    ),
                                transition: Transition.rightToLeft);
                          },
                          fr: selectedRoom.checklist[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRoomTile({
    required VoidCallback onPress,
    required String fr,
  }) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
