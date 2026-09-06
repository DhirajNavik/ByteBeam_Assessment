import "package:bytebeam_assessment/config/injectors/injectable.dart";
import "package:bytebeam_assessment/feature/telemetry/presentation/bloc/vehicle_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<VehicleBloc>()..add(VehicleEvent.fetchVehicles()),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<VehicleBloc, VehicleState>(
                builder: (_, state) {
                  return state.when(
                    initial: () => Center(child: Text("hello")),
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (error) => Center(child: Text(error)),
                    loaded: (vehicles) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final vehicle = vehicles[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(child: Text('${index + 1}')),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              vehicle.registration.toString(),
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(vehicle.model.toString()),
                                          ],
                                        ),
                                      ),
                                      Text('#${vehicle.id}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              ElevatedButton(onPressed: () {}, child: Text("data")),
            ],
          ),
        ),
      ),
    );
  }
}
