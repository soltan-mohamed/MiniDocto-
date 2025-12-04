import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/professional_provider.dart';
import '../../models/professional.dart';
import 'professional_detail_screen.dart';

class ProfessionalListScreen extends StatefulWidget {
  const ProfessionalListScreen({super.key});

  @override
  State<ProfessionalListScreen> createState() => _ProfessionalListScreenState();
}

class _ProfessionalListScreenState extends State<ProfessionalListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ProfessionalProvider>().loadProfessionals(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfessionalProvider>(
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
                  onPressed: () => provider.loadProfessionals(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (provider.professionals.isEmpty) {
          return const Center(
            child: Text('Aucun professionnel disponible'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadProfessionals(),
          child: ListView.builder(
            itemCount: provider.professionals.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final professional = provider.professionals[index];
              return _ProfessionalCard(professional: professional);
            },
          ),
        );
      },
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final Professional professional;

  const _ProfessionalCard({required this.professional});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            professional.firstName[0] + professional.lastName[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          professional.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(professional.speciality),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('Score: ${professional.score}/100'),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfessionalDetailScreen(professional: professional),
            ),
          );
        },
      ),
    );
  }
}
