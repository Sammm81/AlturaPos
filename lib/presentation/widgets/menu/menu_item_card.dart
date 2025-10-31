import 'package:flutter/material.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/formatters.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    required this.item,
    required this.onTap,
    this.canToggleAvailability = false,
    this.onToggleAvailability,
    super.key,
  });

  final MenuItem item;
  final VoidCallback onTap;
  final bool canToggleAvailability;
  final VoidCallback? onToggleAvailability;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnavailable = !item.isAvailable;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isUnavailable ? null : onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image section
                Expanded(
                  flex: 3,
                  child: _buildImage(context),
                ),

                // Content section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUnavailable
                                ? theme.colorScheme.onSurface.withOpacity(0.5)
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Description (if available)
                        if (item.description != null &&
                            item.description!.isNotEmpty)
                          Expanded(
                            child: Text(
                              item.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(isUnavailable ? 0.3 : 0.6),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        const Spacer(),

                        // Price and variants info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Text(
                              Formatters.currencyCompact(item.basePrice),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isUnavailable
                                    ? theme.colorScheme.onSurface
                                        .withOpacity(0.5)
                                    : theme.colorScheme.primary,
                              ),
                            ),

                            // Variants indicator
                            if (item.hasVariants)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.variants.length} variants',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                  ),
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

            // Unavailable overlay
            if (isUnavailable)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        AppStrings.unavailable.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Toggle availability button (for managers)
            if (canToggleAvailability && onToggleAvailability != null)
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    icon: Icon(
                      item.isAvailable
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                    ),
                    color: item.isAvailable
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    onPressed: onToggleAvailability,
                    tooltip: AppStrings.toggleAvailability,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);
    final isUnavailable = !item.isAvailable;

    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return Image.network(
        item.imageUrl!,
        fit: BoxFit.cover,
        color: isUnavailable ? Colors.grey : null,
        colorBlendMode: isUnavailable ? BlendMode.saturation : null,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(context);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    return _buildPlaceholder(context);
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final isUnavailable = !item.isAvailable;

    return Container(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      child: Icon(
        Icons.restaurant,
        size: 64,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(
          isUnavailable ? 0.3 : 0.5,
        ),
      ),
    );
  }
}
