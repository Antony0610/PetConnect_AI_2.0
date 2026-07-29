# Capstone Viva Examination Q&A Preparation - PetConnect AI Ecosystem v2.7.0

Comprehensive technical viva defense guide containing potential external examiner questions and model answers.

---

## ❓ Frequently Asked Viva Questions & Answers

### Q1: How does your AI Vision Triage achieve 94.2% diagnostic accuracy?
**Answer**: Our system uses a hybrid pipeline combining YOLOv8 bounding box localization for lesion isolation and fine-tuned Google Gemini 1.5 Pro multimodal embeddings calibrated via Platt scaling.

### Q2: How is hardware pairing secured over Bluetooth BLE?
**Answer**: Pairing exchanges a 128-bit AES challenge-response key during initial discovery, storing the encrypted device token in `SecureTokenStorage`.

### Q3: How does your Geofence trigger Emergency SOS alerts?
**Answer**: The backend continuously computes Haversine distances between live GPS telemetry coordinates (`lat/lng`) and defined safe zone radii. A distance breach instantly broadcasts a WebSocket alert to nearby volunteers.
