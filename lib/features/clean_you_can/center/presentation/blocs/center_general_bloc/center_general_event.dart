part of 'center_general_bloc.dart';

sealed class CenterGeneralEvent {
  const CenterGeneralEvent();
}

class CreateCenterEvent extends CenterGeneralEvent {
  CenterEntity createCenter;
  CreateCenterEvent({required this.createCenter});
}