import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/ads_model.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget({super.key, required this.advertisements});
  final List<AdvertisementsModel> advertisements;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: advertisements.map((item) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 325,
            height: 184,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(item.imageURL),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(25, 114, 124, 142),
                    offset: Offset(0, 10),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ]),
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 20,
                  child: SizedBox(
                    height: 75,
                    width: 100,
                    child: Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Color(0xffffffff),
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
      ),
    );
  }
}
