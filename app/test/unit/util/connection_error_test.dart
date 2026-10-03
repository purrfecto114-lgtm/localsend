import 'package:localsend_app/util/connection_error.dart';
import 'package:localsend_isolates/rust/api/http.dart';
import 'package:test/test.dart';

void main() {
  group('classifyConnectionError', () {
    test('timeout family (#2121: RhttpTimeoutException raw text)', () {
      expect(
        classifyConnectionError('RhttpTimeoutException: Request timed out. URL: https://192.168.1.5:53317/api/localsend/v2/info'),
        ConnectionErrorKind.timeout,
      );
      expect(classifyConnectionError('Request timed out'), ConnectionErrorKind.timeout);
      expect(classifyConnectionError('operation timed out'), ConnectionErrorKind.timeout);
    });

    test('connection refused family', () {
      expect(classifyConnectionError('Connection refused (os error 111)'), ConnectionErrorKind.connectionRefused);
      expect(classifyConnectionError('error sending request for url (192.168.1.5:53317): connection refused'), ConnectionErrorKind.connectionRefused);
    });

    test('forbidden family', () {
      expect(classifyConnectionError('Forbidden'), ConnectionErrorKind.forbidden);
      expect(classifyConnectionError('[403] PIN required'), ConnectionErrorKind.forbidden);
    });

    test('HTTP status code errors', () {
      expect(classifyConnectionError(const RsHttpClientError_StatusCode(status: 403, message: 'PIN required')), ConnectionErrorKind.forbidden);
      expect(classifyConnectionError(const RsHttpClientError_StatusCode(status: 401, message: 'Unauthorized')), ConnectionErrorKind.forbidden);
      expect(classifyConnectionError(const RsHttpClientError_StatusCode(status: 404, message: 'Not Found')), ConnectionErrorKind.other);
    });

    test('reqwest transport errors', () {
      expect(
        classifyConnectionError(const RsHttpClientError_Reqwest('error sending request for url (http://192.168.1.5:53317/): Connection refused')),
        ConnectionErrorKind.connectionRefused,
      );
      expect(classifyConnectionError(const RsHttpClientError_Reqwest('operation timed out')), ConnectionErrorKind.timeout);
      expect(classifyConnectionError(const RsHttpClientError_Reqwest('dns error: failed to lookup address information')), ConnectionErrorKind.other);
    });

    test('anything else is generic', () {
      expect(classifyConnectionError(Exception('boom')), ConnectionErrorKind.other);
      expect(classifyConnectionError(''), ConnectionErrorKind.other);
      expect(classifyConnectionError(const RsHttpClientError_Other('some other failure')), ConnectionErrorKind.other);
    });
  });
}
