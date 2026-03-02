import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';

sealed class ApplyEvent {}

class OnApplyClickEvent extends ApplyEvent {
  final ApplyRequest applyRequest;

  OnApplyClickEvent({required this.applyRequest});
}
