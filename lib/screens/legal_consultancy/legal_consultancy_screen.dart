import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../providers/preferences_provider.dart';
import '../ai_legal_consultancy/ai_legal_consultancy_screen.dart';

class LegalConsultancyScreen extends ConsumerWidget {
  const LegalConsultancyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final currentLanguage = ref.watch(languageProvider);
    final bgColor = isDarkMode ? CivicShieldTheme.darkBg : Colors.white;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: const Text('Legal Consultancy'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(49),
            child: Column(
              children: [
                Container(height: 1, color: CivicShieldTheme.borderGlow),
                const TabBar(
                  indicatorColor: CivicShieldTheme.accentCyan,
                  labelColor: CivicShieldTheme.accentCyan,
                  unselectedLabelColor: CivicShieldTheme.textMuted,
                  tabs: [
                    Tab(text: 'Lawyers'),
                    Tab(text: 'Services'),
                    Tab(text: 'FAQ'),
                    Tab(text: 'AI Advisor'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildLawyersTab(context, isDarkMode, currentLanguage),
            _buildServicesTab(context, isDarkMode),
            _buildFAQTab(context, isDarkMode),
            const AILegalConsultancyScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildLawyersTab(BuildContext context, bool isDarkMode, String currentLanguage) {
    final lawyers = [
      _LawyerInfo(
        name: 'Adv. Rajesh Kumar',
        specialization: 'Traffic & Motor Vehicle Laws',
        experience: '12 years',
        rating: 4.8,
        reviews: 156,
        languages: ['English', 'Hindi'],
        hourlyRate: '₹500',
      ),
      _LawyerInfo(
        name: 'Adv. Priya Sharma',
        specialization: 'Consumer Rights & Grievances',
        experience: '8 years',
        rating: 4.9,
        reviews: 203,
        languages: ['English', 'Hindi', 'Marathi'],
        hourlyRate: '₹600',
      ),
      _LawyerInfo(
        name: 'Adv. Vikram Singh',
        specialization: 'Administrative & Civil Rights',
        experience: '15 years',
        rating: 4.7,
        reviews: 298,
        languages: ['English', 'Hindi', 'Punjabi'],
        hourlyRate: '₹700',
      ),
      _LawyerInfo(
        name: 'Adv. Kaustubh Patel',
        specialization: 'Traffic Court Representation',
        experience: '10 years',
        rating: 4.8,
        reviews: 142,
        languages: ['English', 'Gujarati', 'Hindi'],
        hourlyRate: '₹550',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: lawyers.length,
      itemBuilder: (context, index) => _LawyerCard(lawyer: lawyers[index], isDarkMode: isDarkMode),
    );
  }

  Widget _buildServicesTab(BuildContext context, bool isDarkMode) {
    final services = [
      _ServiceInfo(
        title: 'Traffic Violation Defense',
        description: 'Expert legal counsel for traffic violations, fines, and license suspension cases.',
        icon: Icons.traffic_rounded,
        color: const Color(0xFF1E88E5),
        bgColor: const Color(0xFFE3F2FD),
      ),
      _ServiceInfo(
        title: 'Administrative Appeal',
        description: 'Professional help in filing appeals against traffic fines and regulatory penalties.',
        icon: Icons.gavel_rounded,
        color: const Color(0xFF43A047),
        bgColor: const Color(0xFFF1F8E9),
      ),
      _ServiceInfo(
        title: 'Rights Consultation',
        description: 'Learn about your legal rights when dealing with authorities and enforcement officers.',
        icon: Icons.shield_rounded,
        color: const Color(0xFF9C27B0),
        bgColor: const Color(0xFFF3E5F5),
      ),
      _ServiceInfo(
        title: 'Document Verification',
        description: 'Verify authenticity of official documents like challans and fines with legal expertise.',
        icon: Icons.verified_user_rounded,
        color: const Color(0xFFFB8C00),
        bgColor: const Color(0xFFFFF3E0),
      ),
      _ServiceInfo(
        title: 'Emergency Legal Aid',
        description: '24/7 availability for urgent legal issues and immediate consultations.',
        icon: Icons.emergency_rounded,
        color: const Color(0xFFE53935),
        bgColor: const Color(0xFFFFEBEE),
      ),
      _ServiceInfo(
        title: 'Court Representation',
        description: 'Professional representation in traffic courts and administrative hearings.',
        icon: Icons.balance_rounded,
        color: const Color(0xFF00897B),
        bgColor: const Color(0xFFE0F2F1),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: services.length,
      itemBuilder: (context, index) => _ServiceCard(service: services[index], isDarkMode: isDarkMode),
    );
  }

  Widget _buildFAQTab(BuildContext context, bool isDarkMode) {
    final faqs = [
      _FAQItem(
        question: 'How much does a legal consultation cost?',
        answer: 'Consultation fees vary from ₹300-₹800 per session depending on the lawyer\'s experience and specialization. We offer the first 15 minutes free consultation for new clients.',
      ),
      _FAQItem(
        question: 'Can I challenge a traffic fine in court?',
        answer: 'Yes, absolutely. If you believe the fine is unjust or the officer violated procedure, you have the right to appeal in traffic court within 30 days. A qualified lawyer can guide you through the process.',
      ),
      _FAQItem(
        question: 'What should I do if I receive a fake challan?',
        answer: 'Document everything, collect evidence of the fake challan, file a complaint with the police, and consult a lawyer. Never pay fake fines as it legitimizes the fraudulent attempt.',
      ),
      _FAQItem(
        question: 'How long does an appeal process take?',
        answer: 'Traffic court appeals typically take 2-6 months depending on the court\'s schedule and case complexity. Our lawyers will keep you updated on progress.',
      ),
      _FAQItem(
        question: 'Can I get compensation for harassment by authorities?',
        answer: 'Yes, if there\'s evidence of unlawful detention or harassment, you can file a compensation claim. Consult our lawyers who specialize in civil rights cases.',
      ),
      _FAQItem(
        question: 'What documents should I collect for my case?',
        answer: 'Collect: the original challan, vehicle registration, license, insurance document, photos/videos of the incident location, witness statements, and any communication with the officer.',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: faqs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDarkMode ? CivicShieldTheme.darkSurfaceCard : const Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF43A047).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CivicShieldTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Find answers to common legal questions about traffic violations, appeals, and your rights.',
                  style: TextStyle(
                    fontSize: 12,
                    color: CivicShieldTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        return _FAQCard(faq: faqs[index - 1], isDarkMode: isDarkMode);
      },
    );
  }
}

class _LawyerInfo {
  final String name;
  final String specialization;
  final String experience;
  final double rating;
  final int reviews;
  final List<String> languages;
  final String hourlyRate;

  _LawyerInfo({
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.languages,
    required this.hourlyRate,
  });
}

class _LawyerCard extends StatelessWidget {
  final _LawyerInfo lawyer;
  final bool isDarkMode;

  const _LawyerCard({required this.lawyer, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? CivicShieldTheme.darkSurfaceCard : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? CivicShieldTheme.darkBorderGlow : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    lawyer.name[0],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lawyer.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CivicShieldTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lawyer.specialization,
                      style: const TextStyle(
                        fontSize: 11,
                        color: CivicShieldTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFBC02D), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${lawyer.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: CivicShieldTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${lawyer.reviews} reviews',
                    style: const TextStyle(
                      fontSize: 10,
                      color: CivicShieldTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${lawyer.experience} experience',
                  style: const TextStyle(
                    fontSize: 11,
                    color: CivicShieldTheme.textSecondary,
                  ),
                ),
              ),
              Text(
                lawyer.hourlyRate + '/hr',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E88E5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: lawyer.languages.map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  lang,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _bookConsultation(context, lawyer.name),
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('Book Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 45,
                child: ElevatedButton.icon(
                  onPressed: () => _callLawyer(context, lawyer.name),
                  icon: const Icon(Icons.phone, size: 16),
                  label: const Text(''),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF43A047),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _bookConsultation(BuildContext context, String lawyerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? CivicShieldTheme.darkSurfaceCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Book with $lawyerName', style: const TextStyle(color: CivicShieldTheme.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select a date and time for your consultation:', style: TextStyle(color: CivicShieldTheme.textSecondary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Slots:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: CivicShieldTheme.textPrimary)),
                  SizedBox(height: 8),
                  Text('📅 Tomorrow, 10:00 AM - 10:30 AM', style: TextStyle(fontSize: 11, color: CivicShieldTheme.textSecondary)),
                  Text('📅 Tomorrow, 2:00 PM - 2:30 PM', style: TextStyle(fontSize: 11, color: CivicShieldTheme.textSecondary)),
                  Text('📅 Day after, 11:00 AM - 11:30 AM', style: TextStyle(fontSize: 11, color: CivicShieldTheme.textSecondary)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: CivicShieldTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Consultation booked with $lawyerName!'),
                  backgroundColor: const Color(0xFF43A047),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5)),
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  void _callLawyer(BuildContext context, String lawyerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $lawyerName...'),
        backgroundColor: const Color(0xFF43A047),
      ),
    );
  }
}

class _ServiceInfo {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;

  _ServiceInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

class _ServiceCard extends StatelessWidget {
  final _ServiceInfo service;
  final bool isDarkMode;

  const _ServiceCard({required this.service, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? CivicShieldTheme.darkSurfaceCard : service.bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: service.color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: service.color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: service.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(service.icon, color: service.color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: CivicShieldTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: CivicShieldTheme.textSecondary,
                    height: 1.4,
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

class _FAQItem {
  final String question;
  final String answer;

  _FAQItem({required this.question, required this.answer});
}

class _FAQCard extends StatefulWidget {
  final _FAQItem faq;
  final bool isDarkMode;

  const _FAQCard({required this.faq, required this.isDarkMode});

  @override
  State<_FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<_FAQCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? CivicShieldTheme.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode ? CivicShieldTheme.darkBorderGlow : const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        onExpansionChanged: (value) => setState(() => _isExpanded = value),
        title: Text(
          widget.faq.question,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: CivicShieldTheme.textPrimary,
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: CivicShieldTheme.accentCyan,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              widget.faq.answer,
              style: const TextStyle(
                fontSize: 12,
                color: CivicShieldTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
