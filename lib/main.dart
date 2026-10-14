import 'package:flutter/material.dart';

void main() {
  runApp(const SpeedoApp());
}

class SpeedoApp extends StatelessWidget {
  const SpeedoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speedo Express',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0038A8),
          primary: const Color(0xFF0038A8),
        ),
      ),
      home: const MainAppShell(),
    );
  }
}

// Shell with top switcher between Customer and Driver Mode
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  bool isDriverMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDriverMode ? const Color(0xFF1E293B) : const Color(0xFF0038A8),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isDriverMode ? 'SPEEDO PARTNER (DRIVER)' : 'SPEEDO CUSTOMER',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            Text(
              isDriverMode ? 'Duty & Ride Management' : 'Book Mini-Truck & Courier',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ActionChip(
              backgroundColor: isDriverMode ? Colors.amber.shade400 : Colors.white,
              label: Text(
                isDriverMode ? 'Switch: Customer' : 'Switch: Driver',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isDriverMode ? Colors.black87 : const Color(0xFF0038A8),
                ),
              ),
              onPressed: () {
                setState(() {
                  isDriverMode = !isDriverMode;
                });
              },
            ),
          )
        ],
      ),
      body: isDriverMode ? const DriverDashboardScreen() : const CustomerBookingScreen(),
    );
  }
}

// ==========================================
// 1. CUSTOMER MODE
// ==========================================
class CustomerBookingScreen extends StatefulWidget {
  const CustomerBookingScreen({super.key});

  @override
  State<CustomerBookingScreen> createState() => _CustomerBookingScreenState();
}

class _CustomerBookingScreenState extends State<CustomerBookingScreen> {
  int selectedVehicleIndex = 2;

  final List<Map<String, dynamic>> vehicles = const [
    {'name': '2-Wheeler', 'desc': 'Up to 20kg parcels', 'price': '₹40', 'icon': Icons.two_wheeler},
    {'name': '3-Wheeler', 'desc': 'Up to 500kg loads', 'price': '₹160', 'icon': Icons.electric_rickshaw},
    {'name': 'Tata Ace', 'desc': 'Heavy goods & shifting', 'price': '₹250', 'icon': Icons.local_shipping},
    {'name': '8ft Truck', 'desc': 'Bulky cargo & Full house', 'price': '₹450', 'icon': Icons.fire_truck_sharp},
  ];

  @override
  Widget build(BuildContext context) {
    final vehicle = vehicles[selectedVehicleIndex];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          color: const Color(0xFF0038A8),
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
                  children: const [
                    Icon(Icons.radio_button_checked, color: Colors.green, size: 16),
                    SizedBox(width: 12),
                    Expanded(child: Text('Connaught Place, New Delhi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7.0),
                  child: Align(alignment: Alignment.centerLeft, child: Container(height: 14, width: 2, color: Colors.grey.shade300)),
                ),
                Row(
                  children: const [
                    Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                    SizedBox(width: 10),
                    Expanded(child: Text('Sector 62, Noida (18.4 km)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(alignment: Alignment.centerLeft, child: Text('Select Vehicle Type', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 118,
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
                  width: 108,
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEBF1FF) : Colors.white,
                    border: Border.all(color: isSelected ? const Color(0xFF0038A8) : Colors.grey.shade300, width: isSelected ? 2 : 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item['icon'] as IconData, size: 28, color: isSelected ? const Color(0xFF0038A8) : Colors.black87),
                      const SizedBox(height: 4),
                      Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSelected ? const Color(0xFF0038A8) : Colors.black87)),
                      Text(item['price'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
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
                  Text(vehicle['price'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerTrackingScreen(vehicleName: vehicle['name'], fare: vehicle['price']),
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
    );
  }
}

class CustomerTrackingScreen extends StatelessWidget {
  final String vehicleName;
  final String fare;

  const CustomerTrackingScreen({super.key, required this.vehicleName, required this.fare});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking'), backgroundColor: const Color(0xFF0038A8), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFFF7E6), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFFD591))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('START TRIP OTP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFD46B08))),
                      Text('Share with driver upon arrival', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                  Text('4829', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFD4380D), letterSpacing: 2)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const CircleAvatar(backgroundColor: Color(0xFF0038A8), child: Icon(Icons.person, color: Colors.white)),
              title: const Text('Ramesh Kumar (Tata Ace)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('DL 1L AA 4821 • 4 mins away'),
              trailing: const Icon(Icons.call, color: Colors.green),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel Ride', style: TextStyle(color: Colors.redAccent)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. DRIVER / PARTNER MODE
// ==========================================
class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  bool isOnline = true;
  bool hasActiveOrder = false;
  bool isTripStarted = false;
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Online / Offline Status Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isOnline ? Colors.green.shade400 : Colors.red.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 6, backgroundColor: isOnline ? Colors.green : Colors.red),
                    const SizedBox(width: 10),
                    Text(
                      isOnline ? 'YOU ARE ONLINE (RECEIVING ORDERS)' : 'YOU ARE OFFLINE',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                Switch(
                  value: isOnline,
                  activeColor: Colors.green,
                  onChanged: (val) {
                    setState(() {
                      isOnline = val;
                      if (!isOnline) hasActiveOrder = false;
                    });
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Daily Earnings Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Column(
                  children: [
                    Text('Today Earnings', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('₹1,420', style: TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text('Trips Completed', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('6 Trips', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Order State Section
          if (!isOnline)
            const Expanded(
              child: Center(
                child: Text('Go Online to receive customer orders', style: TextStyle(color: Colors.white54)),
              ),
            )
          else if (!hasActiveOrder)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.radar, size: 70, color: Colors.blueAccent),
                    const SizedBox(height: 12),
                    const Text('Looking for nearby delivery orders...', style: TextStyle(color: Colors.white70, fontSize: 15)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0038A8)),
                      icon: const Icon(Icons.notifications_active, color: Colors.white),
                      label: const Text('Simulate Incoming Customer Order', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          hasActiveOrder = true;
                          isTripStarted = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Active Order Card with OTP Verification
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('NEW TRIP ALERT', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        Text('₹250 Cash', style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 20),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.radio_button_checked, color: Colors.green),
                      title: Text('Pickup: Connaught Place', style: TextStyle(color: Colors.white, fontSize: 14)),
                      subtitle: Text('Distance: 1.2 km away', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.location_on, color: Colors.redAccent),
                      title: Text('Drop: Sector 62, Noida', style: TextStyle(color: Colors.white, fontSize: 14)),
                      subtitle: Text('Payload: 5 boxes (120 kg)', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ),
                    const SizedBox(height: 16),

                    if (!isTripStarted) ...[
                      // OTP Input Section
                      const Text('Enter 4-Digit Customer OTP to Start Trip:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, letterSpacing: 4, fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'e.g. 4829',
                          hintStyle: const TextStyle(color: Colors.white30, letterSpacing: 2),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () {
                          if (otpController.text.trim() == "4829") {
                            setState(() => isTripStarted = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('OTP Verified! Trip Started.')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid OTP! Ask customer for code (Default: 4829)')),
                            );
                          }
                        },
                        child: const Text('Verify OTP & Start Trip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Icon(Icons.directions_car, color: Colors.greenAccent),
                            SizedBox(width: 8),
                            Text('Trip is in progress to Sector 62...', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0038A8), padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () {
                          setState(() {
                            hasActiveOrder = false;
                            isTripStarted = false;
                            otpController.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Trip Completed! ₹250 added to balance.')),
                          );
                        },
                        child: const Text('Complete Trip & Collect Cash', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
