import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/core/utils/sized_box.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/bloc/alerts/alerts_bloc.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/components/alert_diismissable.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/components/handle_dismissable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlertsView extends StatelessWidget with HandleDismissable {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alerts")),
      body: BlocSelector<AlertsBloc, AlertsState, List<AlertEntity>>(
        selector: (state) => state.maybeMap(
          loaded: (loadedState) => loadedState.alerts,
          orElse: () => <AlertEntity>[],
        ),
        builder: (_, values) {
          return SlidableAutoCloseBehavior(
            child: ListView.separated(
              padding: .symmetric(
                horizontal: Dimens.horizontalspacing,
                vertical: Dimens.verticalspacing,
              ),
              separatorBuilder: (_, _) => SizeBox.widgetSpacing,
              itemCount: values.length,
              itemBuilder: (_, index) {
                final alert = values[index];
                return AlertDismissible(
                  key: ValueKey(index),
                  entity: alert,
                  onDismissed: () async {
                    final reason = await showDismissReasonSheet(context);

                    if (reason == null) return;
                    if (context.mounted) {
                      context.read<AlertsBloc>().add(
                        AlertsEvent.dismiss(alertId: alert.id, reason: reason),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
