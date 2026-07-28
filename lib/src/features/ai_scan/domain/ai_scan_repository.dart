import 'scan_result_entity.dart';

abstract class AiScanRepository {
  Future<ScanResultEntity> processImageScan(String imagePath, ScanMode mode);
}
