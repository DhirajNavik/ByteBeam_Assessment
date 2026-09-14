import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/presentation/bloc/geofence/geofence_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeofenceFormSheet extends StatefulWidget {
  const GeofenceFormSheet({super.key, this.existing});

  final GeofenceEntity? existing;

  @override
  State<GeofenceFormSheet> createState() => _GeofenceFormSheetState();
}

class _GeofenceFormSheetState extends State<GeofenceFormSheet> {
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _radiusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final g = widget.existing!;
      _nameController.text = g.name;
      _latController.text = g.latitude.toString();
      _lonController.text = g.longitude.toString();
      _radiusController.text = g.radiusMeters.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.horizontalspacing,
            vertical: Dimens.verticalspacing,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isEdit ? 'Edit Geofence' : 'New Geofence',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.gapX4),
                _Field(
                  controller: _nameController,
                  label: 'Name',
                  hint: 'e.g. Main Warehouse',
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(height: Dimens.gapX3),
                Row(
                  children: [
                    Expanded(
                      child: _Field(
                        controller: _latController,
                        label: 'Latitude',
                        hint: '12.9716',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        validator: (v) => _validateCoord(v, -90, 90),
                      ),
                    ),
                    SizedBox(width: Dimens.gapX3),
                    Expanded(
                      child: _Field(
                        controller: _lonController,
                        label: 'Longitude',
                        hint: '77.5946',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        validator: (v) => _validateCoord(v, -180, 180),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.gapX3),
                _Field(
                  controller: _radiusController,
                  label: 'Radius (metres)',
                  hint: '500',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final n = double.tryParse(v.trim());
                    if (n == null || n <= 0) return 'Must be > 0';
                    return null;
                  },
                ),
                SizedBox(height: Dimens.gapX6),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colorScheme.onPrimary,
                            ),
                          )
                        : Text(isEdit ? 'Save changes' : 'Create geofence'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateCoord(String? value, double min, double max) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = double.tryParse(value.trim());
    if (n == null) return 'Invalid number';
    if (n < min || n > max) return 'Out of range';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final name = _nameController.text.trim();
    final lat = double.parse(_latController.text.trim());
    final lon = double.parse(_lonController.text.trim());
    final radius = double.parse(_radiusController.text.trim());
    final bloc = context.read<GeofenceBloc>();

    if (widget.existing == null) {
      bloc.add(
        GeofenceEvent.create(
          name: name,
          latitude: lat,
          longitude: lon,
          radiusMeters: radius,
        ),
      );
    } else {
      bloc.add(
        GeofenceEvent.update(
          id: widget.existing!.id,
          name: name,
          latitude: lat,
          longitude: lon,
          radiusMeters: radius,
        ),
      );
    }

    if (mounted) Navigator.pop(context);
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}