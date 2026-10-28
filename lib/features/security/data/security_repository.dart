import 'package:sistem_manajemen_laundry/features/security/domain/pin_hasher.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';

class SecurityRepository {
  SecurityRepository(this._settings);

  static const _hashKey = 'pin_hash';
  static const _saltKey = 'pin_salt';

  final SettingsRepository _settings;

  Future<bool> hasPin() async {
    final hash = await _settings.get(_hashKey);
    final salt = await _settings.get(_saltKey);
    return hash != null && salt != null;
  }

  Future<void> setPin(String pin) async {
    final validation = PinHasher.validate(pin);
    if (validation != null) {
      throw ArgumentError(validation);
    }
    final result = PinHasher.create(pin);
    await _settings.set(_hashKey, result.hash);
    await _settings.set(_saltKey, result.salt);
  }

  Future<bool> verifyPin(String pin) async {
    final hash = await _settings.get(_hashKey);
    final salt = await _settings.get(_saltKey);
    if (hash == null || salt == null) {
      return false;
    }
    return PinHasher.verify(pin, hash: hash, salt: salt);
  }

  Future<void> clearPin() async {
    await _settings.remove(_hashKey);
    await _settings.remove(_saltKey);
  }
}
