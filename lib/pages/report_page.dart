import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/widgets/bottom_nav_bar.dart';


class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
bottomNavigationBar: CustomBottomNavBar(
  currentIndex: 1,
  backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildConsultationCard(
              date: "02 October 2024",
              doctorName: "Drh. Joko Susanto",
              doctorRole: "Veterinarian",
              statusText: "Completed",
              statusColor: Colors.green,
              iconColor: Colors.green,
              onDownload: () => _downloadReport(context),
              imagePath: 'assets/images/image.png',
            ),
            const SizedBox(height: 16),
            _buildConsultationCard(
              date: "02 October 2024",
              doctorName: "Drh. Joko Susanto",
              doctorRole: "Veterinarian",
              statusText: "Pending Payment",
              statusColor: Colors.orange,
              iconColor: Colors.orange,
              onDownload: () => _showPaymentPrompt(context),
              imagePath: 'assets/images/image.png',
            ),
            const SizedBox(height: 16),
            _buildConsultationCard(
              date: "02 October 2024",
              doctorName: "Drh. Joko Susanto",
              doctorRole: "Veterinarian",
              statusText: "Cancelled",
              statusColor: Colors.red,
              iconColor: Colors.red,
              onDownload: () => _showCancelledMessage(context),
              imagePath: 'assets/images/image.png',
            ),
          ],
        ),
      ),
    );
  }


  void _downloadReport(BuildContext context) {
    // Simulate download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading report...'),
        duration: Duration(seconds: 2),
      ),
    );
  }


  void _showPaymentPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Payment Required'),
            content: const Text(
              'Please complete your payment to access this report.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }


  void _showCancelledMessage(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancelled Consultation'),
            content: const Text(
              'No report available for cancelled consultations.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }


  Widget _buildConsultationCard({
    required String date,
    required String doctorName,
    required String doctorRole,
    required String statusText,
    required Color statusColor,
    required Color iconColor,
    required VoidCallback onDownload,
    String? imagePath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
       
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.grey[200],
  ),
  child: ClipOval(
    child: Image.asset(
      imagePath ?? 'assets/images/default_avatar.png', // Jika `imagePath` kosong, gunakan gambar default
      width: 48,
      height: 48,
      fit: BoxFit.cover, // Agar gambar pas di dalam lingkaran
    ),
  ),
),


              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Consultation with",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctorRole,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
Row(
  mainAxisAlignment: MainAxisAlignment.end, // Biar semua elemen sejajar ke kanan
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
      ),
    ),
    const SizedBox(width: 8), // Tambahkan jarak antara status dan ikon download
    Icon(
      Icons.file_download_outlined,
      color: iconColor,
      size: 20, // Kecilkan ikon agar lebih proporsional
    ),
  ],
),


            ],
          ),
        ),
      ],
    );
  }
}


