import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/ui/theme/spacing.dart';

class AttachmentCard extends StatefulWidget {
  final String imageUrl;
  final bool isDeletable;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const AttachmentCard({
    super.key,
    required this.imageUrl,
    required this.isDeletable,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<AttachmentCard> createState() => _AttachmentCardState();
}

class _AttachmentCardState extends State<AttachmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.size80,
      height: AppSpacing.size80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        color: Colors.grey,
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              child: Image.file(
                File(widget.imageUrl),

                width: AppSpacing.size80,
                height: AppSpacing.size80,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Delete Button
          Visibility(
            visible: widget.isDeletable,
            child: Positioned(
              top: 4,
              right: 4,
              child: IconButton.filled(
                onPressed: widget.onDelete,
                icon: Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
