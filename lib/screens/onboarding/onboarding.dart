import 'package:flutter/material.dart';
import 'package:gastrorate/http/auth_helper.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/date_input_with_date_picker.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/input_field.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  final User user;
  final bool isWaitingFirstLogin;
  final Function(UpdateUserRequest) onComplete;
  final bool isLoading;

  const OnboardingScreen({
    super.key,
    required this.user,
    required this.isWaitingFirstLogin,
    required this.onComplete,
    required this.isLoading,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  double _pageOffset = 0;
  int _currentPage = 0;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  Sex _selectedSex = Sex.UNDEFINED;
  final DateTime _earliestDate = DateTime.now().subtract(const Duration(days: 36500));
  final DateTime _latestDate = DateTime.now();
  DateTime? _dateOfBirth;

  int get _totalPages => widget.isWaitingFirstLogin ? 5 : 4;

  static const List<Color> _bgColors = [
    Colors.black,
    Colors.white,
    Color(0xFFF7F7F7),
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      if (mounted) setState(() => _pageOffset = _pageController.page ?? 0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Color get _currentBgColor {
    final page = _pageOffset.clamp(0.0, (_totalPages - 1).toDouble());
    final cur = page.floor().clamp(0, _bgColors.length - 1);
    final nxt = (cur + 1).clamp(0, _bgColors.length - 1);
    return Color.lerp(_bgColors[cur], _bgColors[nxt], page - cur) ?? _bgColors[cur];
  }

  bool get _isDarkPage => _currentPage == 0;
  Color get _dotActiveColor => _isDarkPage ? Colors.white : Colors.black;
  Color get _dotInactiveColor => _isDarkPage ? Colors.white38 : Colors.black12;

  void _nextPage() => _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  void _skipToProfile() => _pageController.animateToPage(
        4,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

  Future<void> _finishOnboarding() async {
    await AuthHelper.markOnboardingSeen(widget.user.id!);
    if (mounted) GoRouter.of(context).go('/home');
  }

  void _handleComplete() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_dateOfBirth == null) return;
      widget.onComplete(UpdateUserRequest(
        username: _usernameController.text.trim(),
        sex: _selectedSex,
        dateOfBirth: _dateOfBirth,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProfilePage = widget.isWaitingFirstLogin && _currentPage == 4;
    final showSkip = !_isDarkPage && !isProfilePage && widget.isWaitingFirstLogin;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _currentBgColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: showSkip
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: TextButton(
                            onPressed: _skipToProfile,
                            child: CustomText(
                              'Skip',
                              style: const TextStyle(color: Colors.black54, fontSize: 14),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (p) => setState(() => _currentPage = p),
                  children: [
                    _buildWelcomeSlide(),
                    _buildIntroSlide(
                      lottieAsset: 'assets/onboarding_discover.json',
                      fallbackIcon: Icons.explore_outlined,
                      headline: 'Discover Nearby',
                      subtext: 'Find the best restaurants around you, filtered by your taste',
                    ),
                    _buildIntroSlide(
                      lottieAsset: 'assets/onboarding_rate.json',
                      fallbackIcon: Icons.star_border_rounded,
                      headline: 'Rate & Review',
                      subtext: 'Share your dining experiences and help others find hidden gems',
                    ),
                    _buildIntroSlide(
                      lottieAsset: 'assets/onboarding_friends.json',
                      fallbackIcon: Icons.people_outline_rounded,
                      headline: 'Share with Friends',
                      subtext: "Follow friends, see where they've been and plan visits together",
                    ),
                    if (widget.isWaitingFirstLogin) _buildProfileSlide(),
                  ],
                ),
              ),
              const VerticalSpacer(24),
              _buildDotIndicator(),
              const VerticalSpacer(24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: _buildCTAButton(),
              ),
              const VerticalSpacer(48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSlide() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationHeight = constraints.maxHeight * 0.42;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/onboarding_welcome.json',
                  height: illustrationHeight,
                  repeat: true,
                  errorBuilder: (context, e, stack) => SizedBox(
                    height: illustrationHeight,
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
                const VerticalSpacer(40),
                CustomText(
                  'Welcome to GastroRate',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const VerticalSpacer(16),
                CustomText(
                  'Your food journey starts here',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntroSlide({
    required String lottieAsset,
    required IconData fallbackIcon,
    required String headline,
    required String subtext,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationHeight = constraints.maxHeight * 0.40;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  lottieAsset,
                  height: illustrationHeight,
                  repeat: true,
                  errorBuilder: (context, e, stack) => SizedBox(
                    height: illustrationHeight,
                    child: Icon(
                      fallbackIcon,
                      size: 100,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const VerticalSpacer(32),
                CustomText(
                  headline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const VerticalSpacer(16),
                CustomText(
                  subtext,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSlide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (widget.user.profileImageUrl != null)
              CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(widget.user.profileImageUrl!),
              )
            else
              CircleAvatar(
                radius: 48,
                backgroundColor: MyColors.primaryColor,
                child: CustomText(
                  widget.user.getUserInitials(),
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
            const VerticalSpacer(12),
            CustomText(
              widget.user.getFullName(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const VerticalSpacer(4),
            CustomText(
              widget.user.email ?? '',
              style: const TextStyle(color: Color(0xFF777777), fontSize: 14),
            ),
            const VerticalSpacer(32),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                'Choose a username',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            const VerticalSpacer(8),
            InputField(
              controller: _usernameController,
              labelText: 'Username',
              hintText: 'Letters, numbers, underscores only',
              validatorFunction: _usernameValidator,
              onChanged: (val) => _usernameController.text = val ?? '',
            ),
            const VerticalSpacer(24),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                'Date of birth',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            const VerticalSpacer(8),
            DateInputWithDatePicker(
              title: 'Select date of birth',
              maximumDate: _latestDate,
              minimumDate: _earliestDate,
              date: _dateOfBirth,
              onDateChanged: (newDate) => setState(() => _dateOfBirth = newDate),
              validatorFunction: (_) => _dateOfBirth == null ? 'Please select a date' : null,
            ),
            const VerticalSpacer(24),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                'Sex',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            const VerticalSpacer(8),
            DropdownButtonFormField<Sex>(
              initialValue: _selectedSex,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: MyColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: MyColors.borderColor),
                ),
                contentPadding: const EdgeInsets.fromLTRB(26, 18, 26, 18),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (val) => setState(() => _selectedSex = val ?? Sex.UNDEFINED),
              items: Sex.values
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.toString().split('.').last),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPages, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == i ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == i ? _dotActiveColor : _dotInactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildCTAButton() {
    if (widget.isWaitingFirstLogin && _currentPage == 4) {
      return ButtonComponent(
        text: 'Complete',
        width: double.infinity,
        isLoading: widget.isLoading,
        onPressed: widget.isLoading ? null : _handleComplete,
      );
    }

    if (_currentPage == 0) {
      return ButtonComponent.outlinedButton(
        text: 'Get Started',
        width: double.infinity,
        buttonColor: Colors.white,
        onPressed: _nextPage,
      );
    }

    if (!widget.isWaitingFirstLogin && _currentPage == 3) {
      return ButtonComponent(
        text: 'Get Started',
        width: double.infinity,
        onPressed: _finishOnboarding,
      );
    }

    return ButtonComponent(
      text: 'Next',
      width: double.infinity,
      onPressed: _nextPage,
    );
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username cannot be empty';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Only letters, numbers and underscores allowed';
    }
    return null;
  }
}
