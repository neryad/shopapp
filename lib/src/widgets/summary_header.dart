import 'package:flutter/material.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;

class SummaryHeader extends StatelessWidget {
  final double budget;
  final double total;
  final double difference;
  final VoidCallback onBudgetTap;

  const SummaryHeader({
    Key? key,
    required this.budget,
    required this.total,
    required this.difference,
    required this.onBudgetTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    bool isOverBudget = total > budget && budget > 0;
    Color diffColor = difference < 0 ? colorScheme.error : colorScheme.primary;

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InkWell(
              onTap: onBudgetTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.account_balance_wallet_outlined,
                          color: colorScheme.onPrimaryContainer, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Budget',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(
                      utils.numberFormat(budget),
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOverBudget
                            ? colorScheme.error
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSimpleSummary(
                  context,
                  label: 'Total',
                  value: utils.numberFormat(total),
                  color: colorScheme.onSurface,
                ),
                _buildSimpleSummary(
                  context,
                  label: 'Difference',
                  value: utils.numberFormat(difference),
                  color: diffColor,
                  isBold: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleSummary(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
