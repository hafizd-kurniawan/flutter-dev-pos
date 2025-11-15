import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class OrderMenu extends StatelessWidget {
  final ProductQuantity data;
  const OrderMenu({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  child: data.product.image != null && data.product.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: data.product.image!.contains('http')
                              ? data.product.image!
                              : '${Variables.baseUrl}/${data.product.image}',
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.fastfood,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        )
                      : Icon(
                          Icons.fastfood,
                          size: 50,
                          color: AppColors.primary,
                        ),
                ),
                title: Text(data.product.name ?? "-",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                subtitle: Text(
                    (data.product.price ?? '0').toIntegerFromText.currencyFormatRp),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context
                        .read<CheckoutBloc>()
                        .add(CheckoutEvent.removeItem(data.product));
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    color: AppColors.white,
                    child: const Icon(
                      Icons.remove_circle,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30.0,
                  child: Center(
                      child: Text(
                    data.quantity.toString(),
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .read<CheckoutBloc>()
                        .add(CheckoutEvent.addItem(data.product));
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    color: AppColors.white,
                    child: const Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SpaceWidth(8),
            SizedBox(
              width: 80.0,
              child: Text(
                ((data.product.price ?? '0').toIntegerFromText * data.quantity)
                    .currencyFormatRp,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
