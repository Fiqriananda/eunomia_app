import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? name;
  final double size;
  final double borderWidth;
  final Color? borderColor;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.name,
    this.size = 32,
    this.borderWidth = 1.5,
    this.borderColor,
  });

  String get _initials {
    if (name == null || name!.trim().isEmpty) return 'U';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  bool get _isSvg =>
      avatarUrl != null &&
      (avatarUrl!.toLowerCase().endsWith('.svg') ||
          avatarUrl!.toLowerCase().contains('/svg'));

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.primaryHover.withValues(alpha: 0.6);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: border, width: borderWidth),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B448C), Color(0xFF232854)],
        ),
      ),
      child: ClipOval(
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (avatarUrl == null || avatarUrl!.trim().isEmpty) {
      return _buildFallback();
    }

    if (_isSvg) {
      return SvgPicture.network(
        avatarUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => _buildFallback(),
      );
    }

    return Image.network(
      avatarUrl!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildFallback();
      },
    );
  }

  Widget _buildFallback() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6F7CF4), Color(0xFF5E6AD2)],
        ),
      ),
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
