import 'package:flutter/material.dart';
import '../config/theme.dart';

class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ElectraTheme.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(ElectraTheme.radiusMd),
        border: Border.all(
          color: ElectraTheme.info.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: ElectraTheme.info,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This platform is informational only. Electra does not endorse any political party or candidate.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ElectraTheme.info,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
