import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/requests_model.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';

class RequestCard extends StatefulWidget {
  final RequestData request;
  final bool compact;
  final VoidCallback? onTap;

  const RequestCard({
    super.key,
    required this.request,
    this.compact = false,
    this.onTap,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _loadingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = false;
  String _currentAction = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Rebuild when the animation status changes so the loader block condition updates
    _animationController.addStatusListener((status) {
      if (mounted) setState(() {});
    });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.4)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'accepted':
      case 'completion':
        return const Color(0xFF33C481);
      case 'rejected':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'accepted':
      case 'completion':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getProjectTypeColor(String? projectType) {
    switch (projectType?.toLowerCase()) {
      case 'consulting':
        return Colors.blue;
      case 'recruitment':
        return const Color(0xFF33C481);
      case 'full time':
        return Colors.purple;
      case 'contract placement':
        return Colors.orange;
      case 'contract':
        return Colors.teal;
      case 'internal':
        return Colors.pink;
      default:
        return const Color(0xFF0B2944);
    }
  }

  void _handleButtonTap(String action) async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _currentAction = action;
    });

    // Start icon animation
    await _animationController.forward();

    // Start loading animation
    _loadingController.repeat();

    // Wait for loading animation
    await Future.delayed(const Duration(milliseconds: 1200));

    // Stop loading and show dialog
    _loadingController.stop();
    _animationController.reset();

    if (mounted) {
      _showActionDialog(context, action, Get.find<RequestsController>());
    }

    setState(() {
      _isAnimating = false;
      _currentAction = '';
    });
  }

  void _showActionDialog(
    BuildContext context,
    String action,
    RequestsController controller,
  ) {
    final noteController = TextEditingController();
    final isReject = action.toLowerCase() == 'reject';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              minWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isReject
                          ? [
                              const Color(0xFFF44336).withOpacity(0.2),
                              const Color(0xFFF44336).withOpacity(0.1),
                            ]
                          : [
                              const Color(0xFF33C481).withOpacity(0.2),
                              const Color(0xFF33C481).withOpacity(0.1),
                            ],
                    ),
                  ),
                  child: Icon(
                    isReject ? Icons.close_rounded : Icons.check_rounded,
                    size: 35,
                    color: isReject
                        ? const Color(0xFFF44336)
                        : const Color(0xFF33C481),
                  ),
                ),
                const SizedBox(height: 20),
                CommonText(
                  '${action.capitalize} Request',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0B2944),
                ),
                const SizedBox(height: 8),
                CommonText(
                  'Are you sure you want to ${action.toLowerCase()} this project request?',
                  fontSize: 14,
                  color: Colors.black54,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  lineHeight: 1.4,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE6E9EF)),
                    color: const Color(0xFFF8FAFC),
                  ),
                  child: TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'Add a note for your ${action.toLowerCase()} decision...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFFE6E9EF)),
                            ),
                          ),
                          child: const CommonText(
                            'Cancel',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            final note = noteController.text.trim();
                            controller.updateRequestStatus(
                              // projectId in path, expertId in payload
                              widget.request.projectId ?? 0,
                              widget.request.expertId ?? 0,
                              isReject ? 'rejected' : 'accepted',
                              note,
                            );
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isReject
                                ? const Color(0xFFF44336)
                                : const Color(0xFF33C481),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: CommonText(
                            action.capitalize!,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusBadge(String? status, bool isSmall) {
    final color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), size: isSmall ? 12 : 14, color: color),
          const SizedBox(width: 4),
          CommonText(
            status?.capitalize ?? 'Unknown',
            color: color,
            fontSize: isSmall ? 10 : 12,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Responsive sizing
    final cardPadding = isSmallScreen ? 12.0 : 16.0;
    final logoSize = isSmallScreen ? 36.0 : 40.0;
    final titleFontSize = isSmallScreen ? 14.0 : 16.0;
    final spacingSmall = isSmallScreen ? 6.0 : 8.0;
    final spacingMedium = isSmallScreen ? 8.0 : 12.0;
    final buttonHeight = widget.compact
        ? (isSmallScreen ? 36.0 : 40.0)
        : (isSmallScreen ? 40.0 : 44.0);

    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          Get.toNamed(
            AppRoutes.projectDetail,
            arguments: widget.request.projectId ?? 0,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: logoSize,
                    height: logoSize,
                    child: Image.asset(
                      ImageAssets.jobLogo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.business_rounded,
                        color: Colors.white,
                        size: isSmallScreen ? 18 : 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        widget.request.projectTitle?.isNotEmpty == true
                            ? widget.request.projectTitle!
                            : 'Project Request',
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0B2944),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.apartment_rounded,
                            size: isSmallScreen ? 12 : 14,
                            color: _getProjectTypeColor(
                              widget.request.projectType,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: CommonText(
                              widget.request.projectType ?? '-',
                              color: _getProjectTypeColor(
                                widget.request.projectType,
                              ),
                              fontSize: isSmallScreen ? 12 : 14,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge (top-right)
                _statusBadge(widget.request.status, isSmallScreen),
              ],
            ),
            SizedBox(height: widget.compact ? 6 : spacingSmall),
            const Divider(height: 16, color: Color(0xFFE6E9EF)), 


            if ((widget.request.message ?? '').isNotEmpty) ...[
              SizedBox(height: widget.compact ? 6 : 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE6E9EF)),
                ),
                child: CommonText(
                  widget.request.message!,
                  color: AppColors.textPrimaryColor,
                  fontSize: isSmallScreen ? 12 : 13,
                ),
              ),
            ],

            SizedBox(height: widget.compact ? 4 : 6),
            Row(
              children: [
                if (widget.request.budget != null)
                  CommonText(
                    'Budget: ₹${widget.request.budget}',
                    color: Colors.black87,
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w700,
                  )
                else
                  CommonText(
                    'Budget: TBD',
                    color: Colors.black87,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                const Spacer(),
                if (widget.request.createdAt != null)
                  CommonText(
                    'Posted: ${_formatDate(widget.request.createdAt!)}',
                    color: Colors.black54,
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
              ],
            ),
            SizedBox(height: widget.compact ? 2 : 4),

            // Action Buttons Section
            if (widget.request.status?.toLowerCase() == 'pending') ...[
              SizedBox(height: widget.compact ? spacingSmall : spacingMedium),
              Stack(
                children: [
                  // Normal layout
                  AnimatedOpacity(
                    opacity: _isAnimating ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isTight = constraints.maxWidth < 220;
                        if (isTight || isSmallScreen) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: buttonHeight,
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            _handleButtonTap('reject'),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0xFFF44336),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: CommonText(
                                          'Reject',
                                          fontSize: isSmallScreen ? 11 : 13,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFF44336),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: buttonHeight,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            _handleButtonTap('accept'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0B2944),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: CommonText(
                                          'Accept',
                                          fontSize: isSmallScreen ? 12 : 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: isSmallScreen ? 90 : 100,
                              height: widget.compact
                                  ? (isSmallScreen ? 32 : 35)
                                  : buttonHeight,
                              child: ElevatedButton(
                                onPressed: () => _handleButtonTap('reject'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.errorColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    CommonText(
                                      'Reject',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: isSmallScreen ? 90 : 110,
                              height: widget.compact
                                  ? (isSmallScreen ? 32 : 35)
                                  : buttonHeight,
                              child: ElevatedButton(
                                onPressed: () => _handleButtonTap('accept'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check, color: Colors.white),
                                    const SizedBox(width: 4),
                                    CommonText(
                                      'Accept',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Animated icon overlay
                  if (_isAnimating)
                    Positioned.fill(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _slideAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: FadeTransition(
                                  opacity: _opacityAnimation,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (_currentAction == 'reject'
                                              ? const Color(0xFFF44336)
                                              : const Color(0xFF33C481))
                                          .withOpacity(0.2),
                                    ),
                                    child: Icon(
                                      _currentAction == 'reject'
                                          ? Icons.close_rounded
                                          : Icons.check_rounded,
                                      size: 28,
                                      color: _currentAction == 'reject'
                                          ? const Color(0xFFF44336)
                                          : const Color(0xFF33C481),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Loading indicator (after the initial icon animation completes)
                  if (_isAnimating && _animationController.status == AnimationStatus.completed)
                    Positioned.fill(
                      child: Center(
                        child: RotationTransition(
                          turns: _loadingController,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: (_currentAction == 'reject'
                                        ? const Color(0xFFF44336)
                                        : const Color(0xFF33C481))
                                    .withOpacity(0.3),
                                width: 2.5,
                              ),
                            ),
                            child: Icon(
                              Icons.autorenew_rounded,
                              size: 20,
                              color: _currentAction == 'reject'
                                  ? const Color(0xFFF44336)
                                  : const Color(0xFF33C481),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ] else ...[
              // Remove duplicate bottom status badge for non-pending states
              SizedBox(height: widget.compact ? spacingSmall : spacingMedium),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
