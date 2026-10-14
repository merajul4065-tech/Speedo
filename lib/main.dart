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
      title: 'Porter Speedo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D4ED8),
          primary: const Color(0xFF1D4ED8),
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
              isDriverMode ? 'Partner App' : 'City Logistics',
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
// 1. CUSTOMER LOGIN
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
              decoration: const BoxDecoration(
                color: Color(0xFFE0E7FF),
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
            'Enter mobile number to select custom locations and book instant trucks',
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
                      const SnackBar(content: Text('OTP sent! Use demo code: 1234')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 10-digit number')),
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
// 2. CUSTOM LOCATION BOOKING (A TO Z)
// ==========================================
class PorterCustomerHomeView extends StatefulWidget {
  const PorterCustomerHomeView({super.key});

  @override
  State<PorterCustomerHomeView> createState() => _PorterCustomerHomeViewState();
}

class _PorterCustomerHomeViewState extends State<PorterCustomerHomeView> {
  final TextEditingController pickupCtrl = TextEditingController(text: 'Connaught Place, Central Delhi');
  final TextEditingController dropCtrl = TextEditingController(text: 'Sector 62, Electronic City, Noida');

  int selectedVehicle = 2;
  double distanceKm = 18.5;

  final List<Map<String, dynamic>> baseFleets = [
    {
      'title': '2-Wheeler',
      'cap': '20 kg',
      'dim': 'Courier, Envelopes & Small Boxes',
      'baseFare': 35,
      'perKm': 9.0,
      'icon': Icons.two_wheeler,
      'eta': '3 mins',
    },
    {
      'title': '3-Wheeler',
      'cap': '500 kg',
      'dim': '5.5ft x 3.5ft (Commercial Loads)',
      'baseFare': 120,
      'perKm': 14.0,
      'icon': Icons.electric_rickshaw,
      'eta': '6 mins',
    },
    {
      'title': 'Tata Ace',
      'cap': '750 kg',
      'dim': '7ft x 4ft x 5ft (Chhota Hathi)',
      'baseFare': 180,
      'perKm': 18.0,
      'icon': Icons.local_shipping,
      'eta': '4 mins',
    },
    {
      'title': 'Pickup 8ft',
      'cap': '1200 kg',
      'dim': '8ft x 4.5ft (House Shifting / Bulk)',
      'baseFare': 300,
      'perKm': 24.0,
      'icon': Icons.fire_truck_sharp,
      'eta': '10 mins',
    },
  ];

  int calculateFare(Map<String, dynamic> fleet) {
    double fare = (fleet['baseFare'] as int) + (distanceKm * (fleet['perKm'] as double));
    return fare.round();
  }

  void _openLocationEditDialog(bool isPickup) {
    final textCtrl = TextEditingController(text: isPickup ? pickupCtrl.text : dropCtrl.text);

    final List<String> popularPlaces = [
      'Connaught Place, New Delhi',
      'Chandni Chowk Market, Old Delhi',
      'Sector 62, Electronic City, Noida',
      'Cyber City, DLF Phase 2, Gurugram',
      'Lajpat Nagar Central Market, South Delhi',
      'Indirapuram, Ghaziabad',
      'Rohini Sector 10, North West Delhi',
      'Faridabad Industrial Area, Sector 24',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPickup ? 'Set Pickup Location (Point A)' : 'Set Drop Location (Point Z)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    isPickup ? Icons.radio_button_checked : Icons.location_on,
                    color: isPickup ? Colors.green : Colors.redAccent,
                  ),
                  hintText: 'Type custom address or area',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Quick Suggestions:', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemCount: popularPlaces.length,
                  itemBuilder: (context, idx) {
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history, size: 18, color: Colors.grey),
                      title: Text(popularPlaces[idx], style: const TextStyle(fontSize: 13)),
                      onTap: () {
                        setState(() {
                          if (isPickup) {
                            pickupCtrl.text = popularPlaces[idx];
                          } else {
                            dropCtrl.text = popularPlaces[idx];
                          }
                          distanceKm = 12.0 + (idx * 2.5);
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8)),
                  onPressed: () {
                    setState(() {
                      if (isPickup) {
                        pickupCtrl.text = textCtrl.text.trim();
                      } else {
                        dropCtrl.text = textCtrl.text.trim();
                      }
                      distanceKm = (15.0 + (textCtrl.text.length % 10)).toDouble();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Confirm Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeVehicle = baseFleets[selectedVehicle];
    final activeFare = calculateFare(activeVehicle);

    return Column(
      children: [
        // Dynamic Location Selector Card (A to Z)
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => _openLocationEditDialog(true),
                child: Row(
                  children: [
                    const Icon(Icons.radio_button_checked, size: 16, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PICKUP POINT (A)', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text(
                            pickupCtrl.text,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit, size: 16, color: Color(0xFF1D4ED8)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const SizedBox(width: 7),
                    Container(width: 2, height: 18, color: Colors.grey.shade300),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                      child: Text('Route: ${distanceKm.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () => _openLocationEditDialog(false),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.redAccent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DROP POINT (Z)', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text(
                            dropCtrl.text,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit, size: 16, color: Color(0xFF1D4ED8)),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Available Porter Fleet', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF374151))),
          ),
        ),

        // Fleet List with Dynamic Pricing
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            itemCount: baseFleets.length,
            itemBuilder: (context, index) {
              final v = baseFleets[index];
              final fare = calculateFare(v);
              final isPicked = selectedVehicle == index;

              return GestureDetector(
                onTap: () => setState(() => selectedVehicle = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isPicked ? const Color(0xFF1D4ED8) : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
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
                      const SizedBox(width: 12),
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
                            Text('Load: ${v['cap']} • ${v['dim']}', style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Text('₹$fare', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
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
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Estimated Fare', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text('₹$activeFare', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PorterTripTrackingView(
                          pickup: pickupCtrl.text,
                          drop: dropCtrl.text,
                          distance: distanceKm.toStringAsFixed(1),
                          vehicleTitle: activeVehicle['title'],
                          fare: '₹$activeFare',
                        ),
                      ),
                    );
                  },
                  child: const Text('Book & Track Live', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 3. INTERACTIVE LIVE TRACKING SCREEN
// ==========================================
class PorterTripTrackingView extends StatefulWidget {
  final String pickup;
  final String drop;
  final String distance;
  final String vehicleTitle;
  final String fare;

  const PorterTripTrackingView({
    super.key,
    required this.pickup,
    required this.drop,
    required this.distance,
    required this.vehicleTitle,
    required this.fare,
  });

  @override
  State<PorterTripTrackingView> createState() => _PorterTripTrackingViewState();
}

class _PorterTripTrackingViewState extends State<PorterTripTrackingView> {
  int tripProgressIndex = 1; // 0: Assigned, 1: Arriving at pickup, 2: Loading, 3: Moving to Drop

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Delivery Tracking'),
        backgroundColor: const Color(0xFF1D4ED8),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // OTP Highlight Card
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
                      Text('Share only with your driver at pickup', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                  Text('4829', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFB45309), letterSpacing: 2)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Simulated Map Container
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.15,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                        itemBuilder: (context, i) => const Icon(Icons.add, size: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_shipping, size: 48, color: Color(0xFF1D4ED8)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF1D4ED8), borderRadius: BorderRadius.circular(20)),
                          child: const Text('Mukesh is 4 mins away', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Driver Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1D4ED8),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text('Mukesh Yadav (${widget.vehicleTitle})', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('UP 16 BT 9921 • Rating 4.8 ★'),
                trailing: IconButton(
                  icon: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.call, color: Colors.white, size: 18)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling Driver: +91 98765 43210')),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Route Details Summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.radio_button_checked, size: 14, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(child: Text(widget.pickup, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const Divider(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Expanded(child: Text(widget.drop, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel Booking', style: TextStyle(color: Colors.redAccent)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. DRIVER PARTNER DASHBOARD
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
                child: Text('Turn Duty ON to get customer trips', style: TextStyle(color: Colors.white54)),
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
                    const Text('Looking for delivery orders nearby...', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8)),
                      onPressed: () => setState(() => isTripAssigned = true),
                      child: const Text('Simulate Incoming Customer Booking', style: TextStyle(color: Colors.white)),
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
                        Text('₹380 Cash', style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 20),
                    const Text('Pickup (A): Connaught Place, Central Delhi', style: TextStyle(color: Colors.white, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text('Drop (Z): Sector 62, Noida (18.5 km)', style: TextStyle(color: Colors.white70, fontSize: 13)),
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
                          child: Text('Trip Ongoing to Point Z...', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
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
                          child: const Text('Complete Trip & Collect Cash', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
