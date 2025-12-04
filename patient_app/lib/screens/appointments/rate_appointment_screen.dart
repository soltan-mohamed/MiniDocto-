import 'package:flutter/material.dart';
import '../../models/appointment.dart';
import '../../services/api_service.dart';

class RateAppointmentScreen extends StatefulWidget {
  final Appointment appointment;

  const RateAppointmentScreen({super.key, required this.appointment});

  @override
  State<RateAppointmentScreen> createState() => _RateAppointmentScreenState();
}

class _RateAppointmentScreenState extends State<RateAppointmentScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _commentController = TextEditingController();
  
  int _rating = 0;
  bool _isLoading = false;

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une note')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _apiService.addReview({
        'appointmentId': widget.appointment.id,
        'rating': _rating,
        'comment': _commentController.text.trim().isEmpty 
            ? null 
            : _commentController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Merci pour votre avis!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noter le rendez-vous'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comment s\'est passé votre rendez-vous ?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Avec ${widget.appointment.professionalName}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Rating stars
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Votre note',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        return IconButton(
                          iconSize: 48,
                          icon: Icon(
                            starValue <= _rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() => _rating = starValue);
                          },
                        );
                      }),
                    ),
                    if (_rating > 0)
                      Text(
                        _getRatingText(_rating),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Comment
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commentaire (optionnel)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _commentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Partagez votre expérience...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Submit button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Envoyer mon avis'),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Très insatisfait';
      case 2:
        return 'Insatisfait';
      case 3:
        return 'Moyen';
      case 4:
        return 'Satisfait';
      case 5:
        return 'Très satisfait';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
