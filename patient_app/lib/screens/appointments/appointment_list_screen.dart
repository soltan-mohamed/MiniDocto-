import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/appointment_provider.dart';
import '../../models/appointment.dart';
import 'rate_appointment_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AppointmentProvider>().loadAppointments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erreur: ${provider.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadAppointments(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (provider.appointments.isEmpty) {
          return const Center(
            child: Text('Aucun rendez-vous'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadAppointments(),
          child: ListView.builder(
            itemCount: provider.appointments.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final appointment = provider.appointments[index];
              return _AppointmentCard(appointment: appointment);
            },
          ),
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentCard({required this.appointment});

  Color _getStatusColor() {
    switch (appointment.status) {
      case 'CONFIRMED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (appointment.status) {
      case 'CONFIRMED':
        return 'Confirmé';
      case 'PENDING':
        return 'En attente';
      case 'CANCELLED':
        return 'Annulé';
      case 'COMPLETED':
        return 'Terminé';
      default:
        return appointment.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment.professionalName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              appointment.professionalSpeciality,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                      .format(appointment.appointmentTime),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 8),
                Text(
                  DateFormat('HH:mm').format(appointment.appointmentTime),
                ),
              ],
            ),
            if (appointment.reason != null && appointment.reason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Motif: ${appointment.reason}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
            if (appointment.status == 'CONFIRMED') ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _cancelAppointment(context),
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text(
                      'Annuler',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
            if (appointment.status == 'COMPLETED' && appointment.hasReview == false) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _rateAppointment(context),
                    icon: const Icon(Icons.star),
                    label: const Text('Noter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
            if (appointment.status == 'COMPLETED' && appointment.hasReview == true) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Avis envoyé',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _cancelAppointment(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler le rendez-vous'),
        content: const Text(
          'Êtes-vous sûr de vouloir annuler ce rendez-vous ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await context.read<AppointmentProvider>().cancelAppointment(appointment.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rendez-vous annulé'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _rateAppointment(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => RateAppointmentScreen(appointment: appointment),
      ),
    );

    if (result == true && context.mounted) {
      context.read<AppointmentProvider>().loadAppointments();
    }
  }
}
