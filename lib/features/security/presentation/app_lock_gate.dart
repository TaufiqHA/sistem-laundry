import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/features/security/domain/lock_policy.dart';
import 'package:sistem_manajemen_laundry/features/security/presentation/security_providers.dart';

/// Membungkus aplikasi dan menampilkan layar PIN di atasnya bila terkunci.
/// Overlay dipakai agar state navigasi tidak hilang saat membuka kunci.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _pausedAt = DateTime.now();
      return;
    }
    if (state == AppLifecycleState.resumed) {
      final pausedAt = _pausedAt;
      _pausedAt = null;
      if (pausedAt == null) {
        return;
      }
      final hasPin = ref.read(hasPinProvider).value ?? false;
      if (hasPin && shouldLockAfterResume(pausedAt, DateTime.now())) {
        ref.read(lockControllerProvider.notifier).lock();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPin = ref.watch(hasPinProvider);
    final locked = ref.watch(lockControllerProvider);

    return hasPin.when(
      loading: () => const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => widget.child,
      data: (hasPin) {
        if (!hasPin || !locked) {
          return widget.child;
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            const Positioned.fill(child: PinLockScreen()),
          ],
        );
      },
    );
  }
}

class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({super.key});

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  final _controller = TextEditingController();
  String? _error;
  int _attempts = 0;
  DateTime? _blockedUntil;
  Timer? _timer;
  bool _checking = false;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  bool get _blocked {
    final until = _blockedUntil;
    return until != null && DateTime.now().isBefore(until);
  }

  Future<void> _onChanged(String value) async {
    if (value.length == 6 && !_checking && !_blocked) {
      await _verify(value);
    }
  }

  Future<void> _verify(String pin) async {
    setState(() => _checking = true);
    final valid = await ref.read(securityRepositoryProvider).verifyPin(pin);
    if (!mounted) {
      return;
    }

    if (valid) {
      _controller.clear();
      ref.read(lockControllerProvider.notifier).unlock();
      setState(() => _checking = false);
      return;
    }

    _attempts++;
    _controller.clear();
    if (_attempts >= 5) {
      _blockedUntil = DateTime.now().add(const Duration(seconds: 30));
      _error = 'Terlalu banyak percobaan. Tunggu 30 detik.';
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (!_blocked) {
          timer.cancel();
          setState(() {
            _blockedUntil = null;
            _attempts = 0;
            _error = null;
          });
        } else {
          setState(() {});
        }
      });
    } else {
      _error = 'PIN salah. Sisa ${5 - _attempts} percobaan.';
    }
    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondsLeft = _blockedUntil == null
        ? 0
        : _blockedUntil!.difference(DateTime.now()).inSeconds + 1;

    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 56,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aplikasi terkunci',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan PIN 6 angka untuk membuka.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    enabled: !_blocked,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      letterSpacing: 12,
                    ),
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '••••••',
                      errorText: _blocked
                          ? 'Terkunci, coba lagi dalam $secondsLeft detik'
                          : _error,
                    ),
                    onChanged: _onChanged,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _blocked || _checking
                        ? null
                        : () => _verify(_controller.text),
                    child: _checking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Buka'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
