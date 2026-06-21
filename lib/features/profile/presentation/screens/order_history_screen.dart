import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // Mock order data
    final List<Map<String, dynamic>> mockOrders = [
      {
        'id': 'ORD-2026-9823A',
        'date': isAr ? '18 يونيو 2026' : 'June 18, 2026',
        'total': '\$142.50',
        'status': 'In Transit',
        'itemsCount': 3,
      },
      {
        'id': 'ORD-2026-1102C',
        'date': isAr ? '17 يونيو 2026' : 'June 17, 2026',
        'total': '\$23.40',
        'status': 'Processing',
        'itemsCount': 2,
      },
      {
        'id': 'ORD-2026-5412B',
        'date': isAr ? '12 مايو 2026' : 'May 12, 2026',
        'total': '\$89.99',
        'status': 'Delivered',
        'itemsCount': 1,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderHistory, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockOrders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = mockOrders[index];
          return Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: InkWell(
              onTap: () => _showOrderDetails(context, order),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order['id'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order['status']).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getStatusLabel(order['status'], isAr),
                            style: TextStyle(
                              color: _getStatusColor(order['status']),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order['date'],
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAr 
                              ? '${order['itemsCount']} منتجات' 
                              : '${order['itemsCount']} Items',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        Text(
                          order['total'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[950] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'تفاصيل تتبع الطلب' : 'Order Tracking Details',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusLabel(order['status'], isAr),
                      style: TextStyle(
                        color: _getStatusColor(order['status']),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${isAr ? 'رقم الطلب:' : 'Order ID:'} ${order['id']}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTrackingStep(
                        title: isAr ? 'تم تقديم الطلب' : 'Order Placed',
                        subtitle: '${order['date']} - 09:12 AM',
                        isCompleted: true,
                        isActive: false,
                        isLast: false,
                        context: context,
                      ),
                      _buildTrackingStep(
                        title: isAr ? 'قيد التجهيز' : 'Processing Order',
                        subtitle: order['status'] == 'Processing'
                            ? (isAr ? 'نقوم بتجهيز منتجاتك الآن' : 'Preparing your items right now')
                            : '${order['date']} - 11:30 AM',
                        isCompleted: order['status'] != 'Processing',
                        isActive: order['status'] == 'Processing',
                        isLast: false,
                        context: context,
                      ),
                      _buildTrackingStep(
                        title: isAr ? 'تم شحن الطلب' : 'In Transit / Shipped',
                        subtitle: order['status'] == 'Delivered'
                            ? '${order['date']} - 02:45 PM'
                            : order['status'] == 'In Transit'
                                ? (isAr ? 'الشحنة مع مندوب التوصيل' : 'Out with delivery courier')
                                : (isAr ? 'بانتظار شحن المنتجات' : 'Waiting to be shipped'),
                        isCompleted: order['status'] == 'Delivered',
                        isActive: order['status'] == 'In Transit',
                        isLast: false,
                        context: context,
                      ),
                      _buildTrackingStep(
                        title: isAr ? 'تم التوصيل' : 'Delivered',
                        subtitle: order['status'] == 'Delivered'
                            ? '${order['date']} - 05:15 PM'
                            : (isAr ? 'التوصيل المقدر خلال يومين' : 'Estimated delivery in 2 days'),
                        isCompleted: order['status'] == 'Delivered',
                        isActive: false,
                        isLast: true,
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),
              
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'الإجمالي الكلي:' : 'Total Payment:',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${order['total']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrackingStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.green
                    : isActive
                        ? Colors.blue
                        : isDark ? Colors.grey[800] : Colors.grey[300],
                border: Border.all(
                  color: isCompleted
                      ? Colors.green
                      : isActive
                          ? Colors.blue.withValues(alpha: 0.3)
                          : Colors.transparent,
                  width: 4,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 45,
                color: isCompleted ? Colors.green : isDark ? Colors.grey[800] : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isCompleted || isActive 
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'In Transit':
        return Colors.blue;
      case 'Processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status, bool isAr) {
    switch (status) {
      case 'Delivered':
        return isAr ? 'تم التوصيل' : 'Delivered';
      case 'In Transit':
        return isAr ? 'قيد التوصيل' : 'In Transit';
      case 'Processing':
        return isAr ? 'قيد التجهيز' : 'Processing';
      default:
        return status;
    }
  }
}
