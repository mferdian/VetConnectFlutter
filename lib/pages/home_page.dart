import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/doctor_detail_page.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../models/doctor.dart';
import '../services/vet_api_service.dart';
import '../pages/article_page.dart';
import '../pages/doctor_list_page.dart';
import '../pages/report_page.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/dokter_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final profileController = Get.find<ProfileController>();
  List<Dokter> dokters = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDokters();
  }

  Future<void> _loadDokters() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await DokterService.getDoktersForHome();
      setState(() {
        dokters = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildServiceIcon(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: const Color(0xFF497D74),
            radius: 25,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search doctor, drugs, articles...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Service',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildServiceIcon(Icons.local_hospital, 'Doctors', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DoctorListPage()),
                  );
                }),
                _buildServiceIcon(Icons.article_outlined, 'Article', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ArticlePage()),
                  );
                }),
                _buildServiceIcon(Icons.assignment_outlined, 'Report', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportsPage()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Doctor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DoctorListPage()),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            const Text('Failed to load doctors'),
                            ElevatedButton(
                              onPressed: _loadDokters,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : dokters.isEmpty
                      ? const Center(child: Text('No doctors available'))
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: dokters.length,
                        itemBuilder: (context, index) {
                          final dokter = dokters[index];
                          return DokterCard(
                            dokter: dokter,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DoctorDetailPage(dokterId: dokter.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 0,
        backgroundColor: Color.fromARGB(255, 253, 253, 253),
      ),
    );
  }
}
