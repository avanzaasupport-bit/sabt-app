import 'package:flutter/material.dart';

void main() {
  runApp(const SabtChequeApp());
}

class SabtChequeApp extends StatelessWidget {
  const SabtChequeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سامانه ثبت چک صیادی',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
        ),
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: ChequeInquiryScreen(),
      ),
    );
  }
}

class ChequeInquiryScreen extends StatefulWidget {
  const ChequeInquiryScreen({super.key});

  @override
  State<ChequeInquiryScreen> createState() => _ChequeInquiryScreenState();
}

class _ChequeInquiryScreenState extends State<ChequeInquiryScreen> {
  final TextEditingController _idController = TextEditingController();
  final String _targetChequeId = '5181040052894848';

  bool _isSearched = false;
  bool _found = false;
  bool _isConfirmed = false;

  String _normalizeNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String res = input.trim();
    for (int i = 0; i < 10; i++) {
      res = res.replaceAll(farsi[i], english[i]).replaceAll(arabic[i], english[i]);
    }
    return res;
  }

  void _searchCheque() {
    FocusScope.of(context).unfocus();
    final inputId = _normalizeNumbers(_idController.text);

    setState(() {
      _isSearched = true;
      _isConfirmed = false;
      _found = (inputId == _targetChequeId);
    });
  }

  void _confirmCheque() {
    setState(() {
      _isConfirmed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'چک در کارتابل شما ثبت شد',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _rejectCheque() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('رد چک'),
        content: const Text('آیا از عدم تایید و رد این چک اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('چک توسط شما رد شد.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text('بله، رد شود', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('کارتابل چک صیادی'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'استعلام و تایید چک صیاد',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'شناسه ۱۶ رقمی چک صیادی را وارد کنید:',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      maxLength: 16,
                      style: const TextStyle(fontSize: 18, letterSpacing: 2.0, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '---- ---- ---- ----',
                        counterText: '',
                        prefixIcon: const Icon(Icons.qr_code_scanner),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _searchCheque,
                        icon: const Icon(Icons.search),
                        label: const Text('استعلام اطلاعات چک', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isSearched) ...[
              if (!_found)
                Card(
                  color: const Color(0xFFFEF2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFFDC2626)),
                        SizedBox(height: 10),
                        Text(
                          'در کارتابل موجود نمیباشد',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF991B1B)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'چکی با این شناسه ۱۶ رقمی جهت تایید یافت نشد.',
                          style: TextStyle(fontSize: 12, color: Color(0xFFB91C1C)),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'برگه چک صیادی بنفش',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _isConfirmed ? Colors.green[100] : Colors.amber[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _isConfirmed ? 'ثبت شده' : 'در انتظار تایید',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _isConfirmed ? Colors.green[900] : Colors.brown[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildDetailRow('انتقال دهنده:', 'شرکت هورخش دیاکو پارس', isBold: true),
                                  const Divider(height: 20),
                                  _buildDetailRow('گیرنده:', 'خ ژاله.حجتی فر'),
                                  const Divider(height: 20),
                                  _buildDetailRow('شماره ملی:', '۴۱۳۱۹۵۱۴۱۱'),
                                  const Divider(height: 20),
                                  _buildDetailRow('تاریخ سررسید:', '۱۴۰۵/۰۸/۳۰'),
                                  const Divider(height: 20),
                                  _buildDetailRow(
                                    'مبلغ چک:',
                                    '۴۸,۸۰۰,۰۰۰,۰۰۰ ریال',
                                    valueColor: const Color(0xFF047857),
                                    isBold: true,
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '(معادل ۴ میلیارد و ۸۸۰ میلیون تومان)',
                                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _rejectCheque,
                            icon: const Icon(Icons.close_rounded),
                            label: const Text('رد چک', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            onPressed: _isConfirmed ? null : _confirmCheque,
                            icon: const Icon(Icons.check_rounded),
                            label: Text(
                              _isConfirmed ? 'ثبت شد' : 'تایید چک',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
