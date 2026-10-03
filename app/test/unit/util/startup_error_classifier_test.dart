import 'dart:io';

import 'package:localsend_app/util/startup_error_classifier.dart';
import 'package:test/test.dart';

void main() {
  group('classifyStartupError', () {
    group('SocketException objects (direct Dart socket errors)', () {
      test('Windows forbidden access (errno 10013)', () {
        final error = SocketException(
          'Creating ServerSocket failed (errno = 10013, address = 0.0.0.0, port = 53317)',
          osError: const OSError('Forbidden access', 10013),
        );
        final result = classifyStartupError(error);
        expect(result.kind, StartupErrorKind.windowsAccessDenied);
        expect(result.errno, 10013);
        expect(result.detail, error.toString());
      });

      test('Linux address in use (errno 98)', () {
        final error = SocketException(
          'Failed to create server socket',
          osError: const OSError('Address already in use', 98),
        );
        expect(classifyStartupError(error).kind, StartupErrorKind.addressInUse);
      });

      test('macOS address in use (errno 48)', () {
        final error = SocketException(
          'Failed to create server socket',
          osError: const OSError('Address already in use', 48),
        );
        expect(classifyStartupError(error).kind, StartupErrorKind.addressInUse);
      });

      test('Windows address in use (errno 10048)', () {
        final error = SocketException(
          'Failed to create server socket',
          osError: const OSError('Only one usage of each socket address', 10048),
        );
        expect(classifyStartupError(error).kind, StartupErrorKind.addressInUse);
      });

      test('unknown errno falls back to generic', () {
        final error = SocketException(
          'Failed to create server socket',
          osError: const OSError('Something else', 13),
        );
        final result = classifyStartupError(error);
        expect(result.kind, StartupErrorKind.generic);
        expect(result.errno, 13);
      });

      test('SocketException without os error falls back to text scan', () {
        const error = SocketException('Creating ServerSocket failed (errno = 10013, port = 53317)');
        expect(classifyStartupError(error).kind, StartupErrorKind.windowsAccessDenied);
      });
    });

    group('plain strings (errors crossing the isolate boundary)', () {
      test('Rust anyhow style "(os error 10013)" is recognized', () {
        const error = 'An attempt was made to access a socket in a way forbidden by its access permissions. (os error 10013)';
        final result = classifyStartupError(error);
        expect(result.kind, StartupErrorKind.windowsAccessDenied);
        expect(result.errno, 10013);
      });

      test('Rust anyhow style "(os error 98)" is recognized', () {
        const error = 'Address already in use (os error 98)';
        expect(classifyStartupError(error).kind, StartupErrorKind.addressInUse);
      });

      test('Dart style "errno = 48" is recognized', () {
        const error = 'SocketException: OS Error: Address already in use, errno = 48, address = 0.0.0.0, port = 53317';
        expect(classifyStartupError(error).kind, StartupErrorKind.addressInUse);
      });

      test('unknown text is generic with null errno', () {
        const error = 'error binding to 0.0.0.0:53317';
        final result = classifyStartupError(error);
        expect(result.kind, StartupErrorKind.generic);
        expect(result.errno, isNull);
        expect(result.detail, error);
      });

      test('empty string is generic', () {
        final result = classifyStartupError('');
        expect(result.kind, StartupErrorKind.generic);
        expect(result.errno, isNull);
      });
    });

    group('arbitrary objects', () {
      test('StateError text is scanned for errno', () {
        final result = classifyStartupError(StateError('bind failed: os error 10013'));
        expect(result.kind, StartupErrorKind.windowsAccessDenied);
      });

      test('objects without errno are generic', () {
        final result = classifyStartupError(Exception('boom'));
        expect(result.kind, StartupErrorKind.generic);
        expect(result.errno, isNull);
        expect(result.detail, contains('boom'));
      });
    });

    test('errno is not extracted from unrelated numbers', () {
      // "port = 53317" must not be mistaken for an errno.
      const error = 'SocketException: Failed to create server socket (OS Error: foo, errno = 10013, port = 53317)';
      expect(classifyStartupError(error).errno, 10013);
      const error2 = 'failed on port 53317';
      expect(classifyStartupError(error2).errno, isNull);
    });
  });
}
