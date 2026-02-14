import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_model.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  late TextEditingController _firstController;
  late TextEditingController _lastController;
  final _userStore = UserStore();

  @override
  void initState() {
    super.initState();
    _firstController = TextEditingController(text: _userStore.user.firstName);
    _lastController = TextEditingController(text: _userStore.user.lastName);
  }

  @override
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseEditScreen(
      title: "EDIT NAME",
      tamilTitle: "பெயர் மாற்றம்",
      onSave: () {
        _userStore.updateUser(
          _userStore.user.copyWith(
            firstName: _firstController.text,
            lastName: _lastController.text,
          ),
        );
        Navigator.pop(context);
      },
      children: [
        _buildTextField("First Name", _firstController),
        const SizedBox(height: 20),
        _buildTextField("Last Name", _lastController),
      ],
    );
  }
}

class EditPhoneScreen extends StatefulWidget {
  const EditPhoneScreen({super.key});

  @override
  State<EditPhoneScreen> createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {
  late TextEditingController _controller;
  final _userStore = UserStore();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _userStore.user.phone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseEditScreen(
      title: "EDIT PHONE",
      tamilTitle: "தொலைபேசி எண்",
      onSave: () {
        _userStore.updateUser(
          _userStore.user.copyWith(phone: _controller.text),
        );
        Navigator.pop(context);
      },
      children: [
        _buildTextField(
          "Phone Number",
          _controller,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}

class EditBillingScreen extends StatefulWidget {
  const EditBillingScreen({super.key});

  @override
  State<EditBillingScreen> createState() => _EditBillingScreenState();
}

class _EditBillingScreenState extends State<EditBillingScreen> {
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _pinController;
  late TextEditingController _stateController;
  final _userStore = UserStore();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(
      text: _userStore.user.billingAddress,
    );
    _cityController = TextEditingController(text: _userStore.user.billingCity);
    _pinController = TextEditingController(text: _userStore.user.billingPin);
    _stateController = TextEditingController(
      text: _userStore.user.billingState,
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _pinController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseEditScreen(
      title: "EDIT BILLING",
      tamilTitle: "பில்லிங் விவரங்கள்",
      onSave: () {
        _userStore.updateUser(
          _userStore.user.copyWith(
            billingAddress: _addressController.text,
            billingCity: _cityController.text,
            billingPin: _pinController.text,
            billingState: _stateController.text,
          ),
        );
        Navigator.pop(context);
      },
      children: [
        _buildTextField("Address", _addressController),
        const SizedBox(height: 16),
        _buildTextField("City", _cityController),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                "PIN Code",
                _pinController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField("State", _stateController)),
          ],
        ),
      ],
    );
  }
}

// Internal reusable components
class _BaseEditScreen extends StatelessWidget {
  final String title;
  final String tamilTitle;
  final VoidCallback onSave;
  final List<Widget> children;

  const _BaseEditScreen({
    required this.title,
    required this.tamilTitle,
    required this.onSave,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
            _buildBottomAction(onSave),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleButton(
            Icons.chevron_left_rounded,
            () => Navigator.pop(context),
          ),
          Column(
            children: [
              Text(
                tamilTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandDark,
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.brandSlate,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppTheme.brandSlateDark, size: 20),
      ),
    );
  }

  Widget _buildBottomAction(VoidCallback onSave) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GestureDetector(
        onTap: onSave,
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.forestGreen,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.forestGreen.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "SAVE CHANGES",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField(
  String label,
  TextEditingController controller, {
  TextInputType? keyboardType,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.black26,
          letterSpacing: 1.0,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}
