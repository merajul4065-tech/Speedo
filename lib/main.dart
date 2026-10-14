import 'package:flutter/material.dart';

void main() {
  runApp(const PorterSpeedoApp());
}

class PorterSpeedoApp extends StatelessWidget {
  const PorterSpeedoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Porter',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
        ),
      ),
      home: const MainPorterShell(),
    );
  }
}

class MainPorterShell extends StatefulWidget {
  const MainPorterShell({super.key});

  @override
  State<MainPorterShell> createState() => _MainPorterShellState();
}

class _MainPorterShellState extends State<MainPorterShell> {
  bool isDriverMode = false;
  bool isCustomerLoggedIn = false;
  String loggedInPhone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: isDriverMode ? const Color(0xFF111827) : const Color(0xFF1D4ED8),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'PORTER',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1.2,
                  color: isDriverMode ? const Color(0xFF111827) : const Color(0xFF1D4ED8),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              isDriverMode ? 'Partner' : 'City Logistics',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ],
        ),
        actions: [
          if (!isDriverMode && isCustomerLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout, size: 20),
              tooltip: 'Logout',
              onPressed: () {
                setState(() {
                  isCustomerLoggedIn = false;
                  loggedInPhone = "";
                });
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ActionChip(
              side: BorderSide.none,
              backgroundColor: isDriverMode ? Colors.amber.shade400 : Colors.white,
              label: Text(
                isDriverMode ? 'Customer View' : 'Driver Partner',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: isDriverMode ? Colors.black87 : const Color(0xFF1D4ED8),
                ),
              ),
              onPressed: () => setState(() => isDriverMode = !isDriverMode),
            ),
          )
        ],
      ),
      body: isDriverMode
          ? const DriverDashboardView()
          : (isCustomerLoggedIn
              ? const PorterCustomerHomeView()
              : PorterCustomerAuthView(
                  onSuccess: (phone) {
                    setState(() {
                      isCustomerLoggedIn = true;
                      loggedInPhone = phone;
                    });
                  },
                )),
    );
  }
}

// ==========================================
// 1. PORTER AUTH VIEW (OTP LOGIN)
// ==========================================
class PorterCustomerAuthView extends StatefulWidget {
  final Function(String) onSuccess;
  const PorterCustomerAuthView({super.key, required this.onSuccess});

  @override
  State<PorterCustomerAuthView> createState() => _PorterCustomerAuthViewState();
}

class _PorterCustomerAuthViewState extends State<PorterCustomerAuthView> {
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController otpCtrl = TextEditingController();
  bool otpTriggered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_shipping, size: 42, color: Color(0xFF1D4ED8)),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Move anything with Porter',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Hassle-free mini trucks and courier service on demand',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            enabled: !otpTriggered,
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('+91', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              hintText: 'Enter Mobile Number',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            ),
          ),
          if (otpTriggered) ...[
            const SizedBox(height: 14),
            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(letterSpacing: 6, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Demo OTP: 1234',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (!otpTriggered) {
                  if (phoneCtrl.text.trim().length == 10) {
                    setState(() => otpTriggered = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP sent successfully. Demo code: 1234')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
                    );
                  }
                } else {
                  if (otpCtrl.text.trim() == "1234") {
                    widget.onSuccess(phoneCtrl.text.trim());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Incorrect OTP! Please use 1234')),
                    );
                  }
                }
              },
              child: Text(
                otpTriggered ? 'Verify & Continue' : 'Get OTP',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 2. PORTER BOOKING VIEW (CARDS & FARES)
// ==========================================
class PorterCustomerHomeView extends StatefulWidget {
  const PorterCustomerHomeView({super.key});

  @override
  State<PorterCustomerHomeView> createState() => _PorterCustomerHomeViewState();
}

class _PorterCustomerHomeViewState extends State<PorterCustomerHomeView> {
  int selectedVehicle = 2;

  final List<Map<String, dynamic>> porterFleets = [
    {
      'title': '2-Wheeler',
      'cap': '20 kg',
      'dim': 'Courier & Box',
      'fare': '₹49',
      'icon': Icons.two_wheeler,
      'eta': '3 mins',
    },
    {
      'title': '3-Wheeler',
      'cap': '500 kg',
      'dim': '5.5ft x 3.5ft',
      'fare': '₹195',
      'icon': Icons.electric_rickshaw,
      'eta': '7 mins',
    },
    {
      'title': 'Tata Ace',
      'cap': '750 kg',
      'dim': '7ft x 4ft x 5ft',
      'fare': '₹289',
      'icon': Icons.local_shipping,
      'eta': '4 mins',
    },
    {
      'title': 'Pickup 8ft',
      'cap': '1200 kg',
      'dim': '8ft x 4.5ft x 5.5ft',
      'fare': '₹480',
      'icon': Icons.fire_truck_sharp,
      'eta': '11 mins',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeVehicle = porterFleets[selectedVehicle];

    return Column(
      children: [
        // Pickup & Drop Selector Card
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.green),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Connaught Place, New Delhi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(width: 2, height: 16, color: Colors.grey.shade300),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.redAccent),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Sector 62, Electronic City, Noida',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                    child: const Text('18.2 km', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                  )
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Fleet Category Heading
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select Vehicle',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF374151)),
            ),
          ),
        ),

        // Vehicle list (Porter style)
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: porterFleets.length,
            itemBuilder: (context, index) {
              final v = porterFleets[index];
              final isPicked = selectedVehicle == index;

              return GestureDetector(
                onTap: () => setState(() => selectedVehicle = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isPicked ? const Color(0xFF1D4ED8) : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(v['icon'] as IconData, size: 30, color: const Color(0xFF1D4ED8)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(v['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(v['eta'], style: const TextStyle(fontSize: 10, color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('Capacity: ${v['cap']} • ${v['dim']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text(v['fare'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom Booking Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.discount, size: 16, color: Colors.green),
                      SizedBox(width: 6),
                      Text('FIRSTTRIP Applied (₹50 OFF)', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Text('Payment: Cash', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Estimate', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(activeVehicle['fare'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PorterTripTrackingView(
                              vehicleTitle: activeVehicle['title'],
                              fare: activeVehicle['fare'],
                            ),
                          ),
                        );
                      },
                      child: const Text('Book ${'Truck'}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
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

// ==========================================
// 3. PORTER RIDE TRACKING & OTP VIEW
// ==========================================
class PorterTripTrackingView extends StatelessWidget {
  final String vehicleTitle;
  final String fare;

  const PorterTripTrackingView({super.key, required this.vehicleTitle, required this.fare});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver On The Way'),
        backgroundColor: const Color(0xFF1D4ED8),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('START TRIP OTP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                      Text('Share only with your Porter driver', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                  Text('4829', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFB45309), letterSpacing: 2)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1D4ED8),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text('Mukesh Yadav ($vehicleTitle)', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('UP 16 BT 9921 • 4 mins away'),
                trailing: const Icon(Icons.phone, color: Colors.green),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel Request', style: TextStyle(color: Colors.red)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. DRIVER PARTNER VIEW (TRIP ACCEPT & OTP)
// ==========================================
class DriverDashboardView extends StatefulWidget {
  const DriverDashboardView({super.key});

  @override
  State<DriverDashboardView> createState() => _DriverDashboardViewState();
}

class _DriverDashboardViewState extends State<DriverDashboardView> {
  bool isDutyOn = true;
  bool isTripAssigned = false;
  bool isOrderInProgress = false;
  final TextEditingController driverOtpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111827),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDutyOn ? Colors.green : Colors.red),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 5, backgroundColor: isDutyOn ? Colors.green : Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      isDutyOn ? 'DUTY ON (WAITING ORDERS)' : 'DUTY OFF',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                Switch(
                  value: isDutyOn,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => isDutyOn = val),
                )
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (!isDutyOn)
            const Expanded(
              child: Center(
                child: Text('Turn Duty ON to get trips', style: TextStyle(color: Colors.white54)),
              ),
            )
          else if (!isTripAssigned)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.explore, size: 60, color: Color(0xFF60A5FA)),
                    const SizedBox(height: 12),
                    const Text('Searching for orders near you...', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8)),
                      onPressed: () => setState(() => isTripAssigned = true),
                      child: const Text('Simulate Incoming Porter Trip', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1F2937), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TATA ACE DEMAND', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        Text('₹289 Net', style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 20),
                    const Text('Pickup: Connaught Place, New Delhi', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    const Text('Drop: Sector 62, Noida (18.2 km)', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const Spacer(),
                    if (!isOrderInProgress) ...[
                      const Text('Enter Customer 4-digit OTP:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: driverOtpCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, letterSpacing: 4, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'e.g. 4829',
                          hintStyle: const TextStyle(color: Colors.white30),
                          filled: true,
                          fillColor: const Color(0xFF111827),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {
                            if (driverOtpCtrl.text.trim() == "4829") {
                              setState(() => isOrderInProgress = true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid code! Enter 4829')),
                              );
                            }
                          },
                          child: const Text('Start Trip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                          child: Text('Trip Ongoing to Destination...', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8)),
                          onPressed: () {
                            setState(() {
                              isTripAssigned = false;
                              isOrderInProgress = false;
                              driverOtpCtrl.clear();
                            });
                          },
                          child: const Text('Complete Order & Collect Cash', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
