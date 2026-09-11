import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/components/custom_modal_sheet.dart';
import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
mixin HandleDismissable {

Future<DismissReason?> showDismissReasonSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return CustomModalSheetWidget(
        size: 0.3,
        maxSize: 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimens.gapX1,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.horizontalspacing,
              ),
              child: Text(
                'Why are you dismissing this alert?',
                style: context.textTheme.titleMedium,
              ),
            ),
            for (final reason in DismissReason.values)
              SizedBox(
                height: Dimens.scaleX5,
                child: ListTile(
                  isThreeLine: false,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimens.horizontalspacing,
                  ),
                  onTap: () => context.pop(reason),
                  leading: Icon(Icons.circle, size: Dimens.scaleX1),
                  minLeadingWidth: 0,
                  title: Text(
                    reason.label,
                    style: context.textTheme.titleMedium,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

}