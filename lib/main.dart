import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speedo Delivery',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0038A8),
          primary: const Color(0xFF0038A8),
        ),
      ),
      home: const DeliveryBookingScreen(),
    );
  }
}

class VehicleOption {
  final String name;
  final String desc;
  final String price;
  final IconData icon;

  const VehicleOption({
    required this.name,
    required this.desc,
    required this.price,
    required this.icon,
  });
}

class DeliveryBookingScreen extends StatefulWidget {
  const DeliveryBookingScreen({super.key});

  @override
  State<DeliveryBookingScreen> createState() => _DeliveryBookingScreenState();
}

class _DeliveryBookingScreenState extends State<DeliveryBookingScreen> {
  int selectedVehicleIndex = 2;

  final List<VehicleOption> vehicles = const [
    VehicleOption(name: '2-Wheeler', desc: 'Up to 20kg parcels', price: '₹40', icon: Icons.two_wheeler),
    VehicleOption(name: '3-Wheeler', desc: 'Up to 500kg loads', price: '₹160', icon: Icons.electric_rickshaw),
    VehicleOption(name: 'Tata Ace', desc: 'Heavy goods & shifting', price: '₹250', icon: Icons.local_shipping),
    VehicleOption(name: '8ft Truck', desc: 'Bulky cargo & Full house', price: '₹450', icon: Icons.fire_truck_sharp),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedVehicle = vehicles[selectedVehicleIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Speedo Delivery', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        backgroundColor: const Color(0xFF0038A8),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF0038A8),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.radio_button_checked, color: Colors.green, size: 16),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Connaught Place, New Delhi', style: TextStyle(color: Colors.grey[850], fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Align(alignment: Alignment.centerLeft, child: Container(height: 16, width: 2, color: Colors.grey.shade300)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Sector 62, Noida (18.4 km)', style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Select Vehicle Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final item = vehicles[index];
                final isSelected = selectedVehicleIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedVehicleIndex = index),
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEBF1FF) : Colors.white,
                      border: Border.all(color: isSelected ? const Color(0xFF0038A8) : Colors.grey.shade300, width: isSelected ? 2 : 1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 30, color: isSelected ? const Color(0xFF0038A8) : Colors.black87),
                        const SizedBox(height: 6),
                        Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSelected ? const Color(0xFF0038A8) : Colors.black87)),
                        const SizedBox(height: 2),
                        Text(item.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total Fare', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(selectedVehicle.price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87)),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveDriverTrackingScreen(vehicleName: selectedVehicle.name, fare: selectedVehicle.price),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0038A8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Confirm & Book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveDriverTrackingScreen extends StatelessWidget {
  final String vehicleName;
  final String fare;

  const LiveDriverTrackingScreen({super.key, required this.vehicleName, required this.fare});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Driver On The Way', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0038A8),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: const Color(0xFFE2E8F0),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping, color: Color(0xFF0038A8), size: 40),
                  SizedBox(height: 8),
                  Text('Driver is 4 mins away', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFD591)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('START TRIP OTP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFD46B08))),
                          SizedBox(height: 2),
                          Text('Share with driver at pickup', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFA8C16), width: 1.5),
                        ),
                        child: const Text('4829', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFD4380D), letterSpacing: 2)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xFFEEF3FF),
                        child: Icon(Icons.person, size: 32, color: Color(0xFF0038A8)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ramesh Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('$vehicleName • DL 1L AA 4821', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 2),
                            const Text('⭐ 4.85 Rating', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.call, color: Colors.green, size: 28),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calling driver: +91 9876543210')));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel Booking', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
