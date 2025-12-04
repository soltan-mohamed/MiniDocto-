import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/professional.dart';
import '../../models/timeslot.dart';
import '../../services/api_service.dart';
import '../../providers/appointment_provider.dart';

class ProfessionalDetailScreen extends StatefulWidget {
  final Professional professional;

  const ProfessionalDetailScreen({super.key, required this.professional});

  @override
  State<ProfessionalDetailScreen> createState() => _ProfessionalDetailScreenState();
}

class _ProfessionalDetailScreenState extends State<ProfessionalDetailScreen> {
  final ApiService _apiService = ApiService();
  List<TimeSlot> _timeSlots = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTimeSlots();
  }

  Future<void> _loadTimeSlots() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _apiService.getAvailableSlots(widget.professional.id);
      setState(() {
        _timeSlots = data.map((json) => TimeSlot.fromJson(json)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _bookAppointment(TimeSlot slot) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réserver un rendez-vous'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Motif de consultation',
            hintText: 'Décrivez brièvement votre besoin',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      try {
        await context.read<AppointmentProvider>().createAppointment({
          'professionalId': widget.professional.id,
          'timeSlotId': slot.id,
          'reason': reasonController.text,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rendez-vous réservé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.professional.fullName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations du professionnel
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
                        child: Text(
                          widget.professional.firstName[0] +
                              widget.professional.lastName[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.professional.fullName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.professional.speciality,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.professional.score}/100',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.professional.description.isNotEmpty) ...[
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.professional.description),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(widget.professional.address)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 20),
                      const SizedBox(width: 8),
                      Text(widget.professional.phone),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Créneaux disponibles
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Créneaux disponibles',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_error != null)
                    Center(
                      child: Column(
                        children: [
                          Text('Erreur: $_error'),
                          ElevatedButton(
                            onPressed: _loadTimeSlots,
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    )
                  else if (_timeSlots.isEmpty)
                    const Center(
                      child: Text('Aucun créneau disponible'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = _timeSlots[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(
                              DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                                  .format(slot.startTime),
                            ),
                            subtitle: Text(
                              '${DateFormat('HH:mm').format(slot.startTime)} - '
                              '${DateFormat('HH:mm').format(slot.endTime)}',
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _bookAppointment(slot),
                              child: const Text('Réserver'),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
