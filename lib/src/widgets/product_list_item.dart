// import 'package:flutter/material.dart';
// import 'package:pocketlist/src/models/product_model.dart';
// import 'package:pocketlist/src/utils/utils.dart' as utils;
// import 'package:pocketlist/src/localization/localization_constant.dart';

// class ProductListItem extends StatelessWidget {
//   final ProductModel product;
//   final int index;
//   final Function(bool?) onCheckboxChanged;
//   final VoidCallback onDelete;
//   final VoidCallback onTap;

//   const ProductListItem({
//     Key? key,
//     required this.product,
//     required this.index,
//     required this.onCheckboxChanged,
//     required this.onDelete,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//     final bool isComplete = product.complete == 1;

//     return Dismissible(
//       key: Key(product.id.toString() +
//           DateTime.now().millisecondsSinceEpoch.toString()),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         decoration: BoxDecoration(
//           color: colorScheme.errorContainer,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         child: Icon(
//           Icons.delete_outline,
//           color: colorScheme.onErrorContainer,
//         ),
//       ),
//       onDismissed: (_) => onDelete(),
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         elevation: isComplete ? 0 : 1,
//         color: isComplete
//             ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
//             : colorScheme.surface,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: isComplete
//               ? BorderSide.none
//               : BorderSide(color: colorScheme.outlineVariant, width: 0.5),
//         ),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
//             child: Row(
//               children: [
//                 Checkbox(
//                   value: isComplete,
//                   onChanged: onCheckboxChanged,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: textTheme.titleMedium?.copyWith(
//                           fontWeight:
//                               isComplete ? FontWeight.normal : FontWeight.bold,
//                           decoration:
//                               isComplete ? TextDecoration.lineThrough : null,
//                           color: isComplete
//                               ? colorScheme.onSurfaceVariant
//                               : colorScheme.onSurface,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 2),
//                       Row(
//                         children: [
//                           Text(
//                             '${product.quantity} x ${utils.numberFormat(product.price)}',
//                             style: textTheme.bodySmall?.copyWith(
//                               color: colorScheme.onSurfaceVariant,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Text(
//                     utils.numberFormat(product.quantity * product.price),
//                     style: textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: isComplete
//                           ? colorScheme.onSurfaceVariant
//                           : colorScheme.primary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
