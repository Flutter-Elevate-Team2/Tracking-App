import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/my_orders_body.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        titleSpacing: 0,
        title: Text((context).l10n.myOrders),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            context.pop();
          },
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),

      body: BlocProvider(
        create: (context) => getIt<MyOrdersViewModel>(),
        child: MyOrdersBody(),
      ),
    );
  }
}