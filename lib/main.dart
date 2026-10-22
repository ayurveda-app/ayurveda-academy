import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AyurvedaApp());
}

class AyurvedaApp extends StatelessWidget {
  const AyurvedaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'आयुर्वेद विश्व',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8C1D18),
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8C1D18),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Razorpay _razorpay;
  bool isGutResetUnlocked = false;
  final String studentPhone = "9876543210";

  @override
  void initState() {
    super.initState();
    _enableSecurity();
    _loadCourseStatus();
    _initRazorpay();
  }

  Future<void> _enableSecurity() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> _loadCourseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isGutResetUnlocked = prefs.getBool('gut_reset_unlocked') ?? false;
    });
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (e) {});
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gut_reset_unlocked', true);
    setState(() {
      isGutResetUnlocked = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('प्रवेश यशस्वी! वर्ग अनलॉक झाला आहे.'),
        backgroundColor: Color(0xFF1E7E34),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('पेमेंट अयशस्वी झाले: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _startPayment(int amount, String courseName) {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount * 100,
      'name': 'ज्योतिष वास्तु विश्व संशोधन केंद्र',
      'description': courseName,
      'prefill': {
        'contact': studentPhone,
        'email': 'student@ayurveda.com',
      },
      'theme': {'color': '#8C1D18'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'आयुर्वेद ॲकॅडमी | उमेश रमेश कुलकर्णी गुरुजी',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD4AF37)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.spa, color: Color(0xFF8C1D18), size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'चरक संहितेवर आधारित ज्ञानगंगा',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF8C1D18)),
                        ),
                        Text(
                          'स्वयंपाकघरातील औषधांनी स्वतःचे डॉक्टर स्वतः बना!',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'उपलब्ध अभ्यासक्रम',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'फ्लॅगशिप वर्ग',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E7E34)),
                          ),
                        ),
                        const Text('३ दिवस | लाईफटाईम', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gut Reset Blueprint™ (अग्नि-दीपन व ॲसिडिटी मुक्ती)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'औषधांशिवाय ॲसिडिटी, गॅसेस आणि अपचनातून कायमची मुक्ती मिळवण्याचे मूळ शास्त्र.',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const Divider(height: 24),
                    isGutResetUnlocked
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8C1D18),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                              label: const Text(
                                'वर्ग सुरू करा (अनलॉक झालेला)',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlaybackScreen(studentPhone: studentPhone),
                                  ),
                                );
                              },
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('नियमित: ₹२,९९९', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                                  Text('₹४९९', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E7E34))),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E7E34),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _startPayment(499, 'Gut Reset Blueprint'),
                                child: const Text(
                                  'प्रवेश घ्या (₹४९९)',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlaybackScreen extends StatefulWidget {
  final String studentPhone;
  const VideoPlaybackScreen({super.key, required this.studentPhone});

  @override
  State<VideoPlaybackScreen> createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  final String videoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFF8C1D18),
        handleColor: const Color(0xFFD4AF37),
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('दिवस १: जठराग्नीचे मूळ विज्ञान')),
      body: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
          ? Stack(
              children: [
                Chewie(controller: _chewieController!),
                Positioned(
                  top: 30,
                  right: 20,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.25,
                      child: Text(
                        widget.studentPhone,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: Color(0xFF8C1D18)),
            ),
    );
  }
}
