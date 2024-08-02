import 'dart:typed_data';

import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/services/lm_amazon_s3_service.dart';
import 'package:likeminds_chat_flutter_core/src/utils/credentials/credentials.dart';

/// Flutter flavour/environment manager v0.0.1
const _prod = !bool.fromEnvironment('DEBUG');

class LMChatMediaService {
  late final String _bucketName;
  late final String _region;
  late final String _accessKey;
  late final String _secretKey;

  static LMChatMediaService? _instance;

  static LMChatMediaService get instance =>
      _instance ??= LMChatMediaService._();

  LMChatMediaService._() {
    _bucketName =
        _prod ? LMChatAWSCredsProd.bucketName : LMChatAWSCredsDev.bucketName;
    _region = _prod ? LMChatAWSCredsProd.region : LMChatAWSCredsDev.region;
    _accessKey =
        _prod ? LMChatAWSCredsProd.accessKey : LMChatAWSCredsDev.accessKey;
    _secretKey =
        _prod ? LMChatAWSCredsProd.secretKey : LMChatAWSCredsDev.secretKey;
  }

  static Future<LMResponse<String>> uploadFile(Uint8List bytes, String postUuid,
      {String? fileName}) async {
    return instance._uploadFile(bytes, postUuid, fileName: fileName);
  }

  Future<LMResponse<String>> _uploadFile(
    Uint8List bytes,
    String uuid, {
    String? fileName,
    String? chatroomId,
    String? conversationId,
  }) async {
    try {
      String url = "https://$_bucketName.s3.$_region.amazonaws.com/";
      String folderName =
          "files/collabcard/$chatroomId/conversation/$conversationId/";
      String generateFileName =
          fileName ?? "$uuid-${DateTime.now().millisecondsSinceEpoch}";
      LMResponse<String> response = await LMChatAWSClient.uploadFile(
        s3UploadUrl: url,
        s3SecretKey: _secretKey,
        s3Region: _region,
        s3AccessKey: _accessKey,
        s3BucketName: _bucketName,
        folderName: folderName,
        fileName: generateFileName,
        fileBytes: bytes,
      );

      return response;
    } on Exception catch (err) {
      return LMResponse(success: false, errorMessage: err.toString());
    }
  }
}
