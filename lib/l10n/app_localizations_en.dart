// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'E-Commerce App';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get discover => 'Discover';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get trendingProducts => 'Trending Products';

  @override
  String get myCart => 'My Cart';

  @override
  String get myWishlist => 'My Wishlist';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Checkout';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get addedToCart => 'Added to cart!';

  @override
  String get noReviews => 'No reviews yet.';

  @override
  String get customerReviews => 'Customer Reviews';

  @override
  String get description => 'Description';

  @override
  String get brand => 'Brand';

  @override
  String get retry => 'Retry';

  @override
  String get oops => 'Oops! Something went wrong';

  @override
  String get emptyCartTitle => 'Your cart is empty';

  @override
  String get emptyCartMessage =>
      'Look like you haven\'t added anything to your cart yet.';

  @override
  String get checkProducts => 'Check Products';

  @override
  String get emptyWishlistTitle => 'Wishlist is empty';

  @override
  String get emptyWishlistMessage =>
      'Start adding items you love to find them here later.';

  @override
  String get browseProducts => 'Browse Products';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get all => 'All';

  @override
  String get beauty => 'Beauty';

  @override
  String get fragrances => 'Fragrances';

  @override
  String get furniture => 'Furniture';

  @override
  String get groceries => 'Groceries';

  @override
  String get totalPayment => 'Total Payment';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get success => 'Success!';

  @override
  String get orderPlacedSuccess => 'Your order has been placed successfully.';

  @override
  String get ok => 'OK';

  @override
  String get productDetails => 'Product Details';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Login to continue shopping';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signup => 'Sign Up';

  @override
  String get welcomeBackToast => 'Welcome back!';

  @override
  String get orderHistory => 'Order History';

  @override
  String get myAddresses => 'My Addresses';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get logout => 'Logout';

  @override
  String get createAccount => 'Create Account';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Invalid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDontMatch => 'Passwords do not match';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Invalid phone number';

  @override
  String fieldRequired(Object fieldName) {
    return '$fieldName is required';
  }

  @override
  String fieldTooShort(Object fieldName, Object minLength) {
    return '$fieldName must be at least $minLength characters';
  }

  @override
  String get noAddressesSaved => 'No addresses saved';

  @override
  String get addShippingAddressStarted =>
      'Add a new shipping address to get started.';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get pastOrdersAppearHere => 'Your past orders will appear here.';

  @override
  String get settings => 'Settings';

  @override
  String get security => 'Security';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get theme => 'Theme';

  @override
  String get changePassword => 'Change Password';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get activeDevices => 'Active Devices';

  @override
  String get liveChat => 'Live Chat';

  @override
  String get faqs => 'FAQs';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotificationsDesc => 'Manage your app alert preferences';

  @override
  String get emailNotificationsDesc =>
      'Get updates about your orders via email';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordInstructions =>
      'Enter your email and we will send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Password reset email sent!';
}
