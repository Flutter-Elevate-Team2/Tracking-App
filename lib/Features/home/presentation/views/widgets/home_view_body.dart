import 'package:flutter/material.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_shimmer_loading.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/order_card.dart';

class HomeViewBody extends StatelessWidget {
  final bool isLoading;

  const HomeViewBody({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),
          Expanded(
            child: isLoading
                ? const HomeShimmerLoading()
                : ListView.builder(
                    itemCount: 5, // Dummy count
                    itemBuilder: (context, index) {
                      return OrderCard();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
