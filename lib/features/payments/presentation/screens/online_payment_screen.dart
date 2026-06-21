import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_state.dart';

class OnlinePaymentScreen extends StatefulWidget {
  const OnlinePaymentScreen({super.key});

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolder = '';
  int _selectedPaymentMethod = 0; // 0 = Credit Card, 1 = Wallet, 2 = COD

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final cartState = context.read<CartBloc>().state;
    double totalPrice = 0.0;
    if (cartState is CartLoaded) {
      totalPrice = cartState.totalPrice;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'الدفع وإتمام الطلب' : 'Checkout & Payment'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMethodSelector(),
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedPaymentMethod == 0
                  ? _buildCreditCardSection(context)
                  : _selectedPaymentMethod == 1
                      ? _buildDigitalWalletContent(totalPrice)
                      : _buildCODContent(totalPrice),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodSelector() {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final items = [
      {'icon': Icons.credit_card, 'label': isAr ? 'بطاقة ائتمان' : 'Card'},
      {'icon': Icons.account_balance_wallet_outlined, 'label': isAr ? 'محفظة رقمية' : 'Wallet'},
      {'icon': Icons.local_shipping_outlined, 'label': isAr ? 'عند الاستلام' : 'C.O.D'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = _selectedPaymentMethod == index;
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () => setState(() => _selectedPaymentMethod = index),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCreditCardSection(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      key: const ValueKey('credit_card_section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCreditCard(context),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: isAr ? 'اسم صاحب البطاقة' : 'Card Holder Name',
                hint: isAr ? 'الاسم الكامل' : 'Full Name',
                onChanged: (v) => setState(() => _cardHolder = v),
                validator: (v) => v!.isEmpty ? (isAr ? 'أدخل اسمك' : 'Enter your name') : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: isAr ? 'رقم البطاقة' : 'Card Number',
                hint: '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
                onChanged: (v) => setState(() => _cardNumber = v),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                validator: (v) =>
                    v!.length < 19 ? (isAr ? 'رقم البطاقة غير صالح' : 'Invalid card number') : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: isAr ? 'تاريخ الانتهاء' : 'Expiry Date',
                      hint: 'MM/YY',
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() => _expiryDate = v),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateFormatter(),
                      ],
                      validator: (v) =>
                          v!.length < 5 ? (isAr ? 'تاريخ غير صالح' : 'Invalid date') : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      label: 'CVV',
                      hint: '000',
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (v) =>
                          v!.length < 3 ? (isAr ? 'رمز غير صالح' : 'Invalid CVV') : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isAr ? 'تأكيد الدفع' : 'Confirm Payment',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDigitalWalletContent(double totalPrice) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      key: const ValueKey('digital_wallet_section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAr ? 'الدفع السريع عبر المحفظة' : 'Express Digital Checkout',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          isAr 
              ? 'اختر محفظتك المفضلة لإتمام عملية الدفع بلمسة واحدة.' 
              : 'Select your preferred digital wallet to complete checkout securely.',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 32),
        
        InkWell(
          onTap: () => _completeCheckout(isAr ? 'Apple Pay' : 'Apple Pay'),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.apple,
                  color: isDark ? Colors.black : Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isAr ? 'شراء باستخدام Apple Pay' : 'Pay with Apple Pay',
                  style: TextStyle(
                    color: isDark ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _completeCheckout(isAr ? 'Google Pay' : 'Google Pay'),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'G',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isAr ? 'شراء باستخدام Google Pay' : 'Pay with Google Pay',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 48),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAr ? 'المبلغ الإجمالي:' : 'Total Amount:',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCODContent(double totalPrice) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      key: const ValueKey('cod_section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAr ? 'الدفع عند الاستلام (COD)' : 'Cash on Delivery (C.O.D)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          isAr
              ? 'سيتعين عليك دفع المبلغ نقداً لمندوب التوصيل فور استلام الشحنة.'
              : 'You will pay the courier in cash upon receiving your package.',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 24),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!, width: 1.5),
            borderRadius: BorderRadius.circular(16),
            color: isDark ? Colors.grey[950] : Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'عنوان التوصيل' : 'Delivery Address',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAr
                          ? '123 شارع التحرير، شقة 5، القاهرة، مصر'
                          : '123 Tahrir Street, Apt 5, Cairo, Egypt',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[100]!),
          ),
          child: Column(
            children: [
              _buildSummaryRow(isAr ? 'قيمة المنتجات' : 'Products Subtotal', '\$${totalPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildSummaryRow(isAr ? 'مصاريف التوصيل' : 'Delivery Fee', isAr ? 'مجاني' : 'FREE'),
              const SizedBox(height: 8),
              _buildSummaryRow(isAr ? 'الضرائب المقدرة' : 'Estimated Tax', '\$${(totalPrice * 0.05).toStringAsFixed(2)}'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'المجموع الكلي' : 'Grand Total',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '\$${(totalPrice * 1.05).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _completeCheckout(isAr ? 'الدفع عند الاستلام' : 'Cash on Delivery'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isAr ? 'تأكيد الطلب عند الاستلام' : 'Confirm Cash on Delivery',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _buildCreditCard(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[900]!.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.credit_card, color: Colors.white, size: 32),
              Text(
                _getCardType(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            _cardNumber.isEmpty ? '**** **** **** ****' : _cardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD HOLDER',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    _cardHolder.isEmpty
                        ? 'FULL NAME'
                        : _cardHolder.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    _expiryDate.isEmpty ? 'MM/YY' : _expiryDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      _completeCheckout(isAr ? 'بطاقة الائتمان' : 'Credit Card');
    }
  }

  void _completeCheckout(String paymentMethod) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.pop(); // Remove loader

      // Clear cart items on successful checkout
      context.read<CartBloc>().add(const ClearCartRequested());

      final successMsg = isAr
          ? 'تم تأكيد طلبك بنجاح باستخدام $paymentMethod!'
          : 'Order placed successfully using $paymentMethod!';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMsg),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/'); // Go back to home shop screen
    });
  }

  String _getCardType() {
    if (_cardNumber.startsWith('4')) return 'VISA';
    if (_cardNumber.startsWith('5')) return 'MASTERCARD';
    return '';
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) formatted += ' ';
      formatted += text[i];
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2) formatted += '/';
      formatted += text[i];
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
