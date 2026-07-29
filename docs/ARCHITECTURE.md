# Master System Architecture Diagrams - PetConnect AI Ecosystem v2.7.0

Collection of publication-grade UML diagrams: System Architecture, ER Diagram, Component Diagram, Sequence Diagram, and AI Pipeline.

---

## 🏛️ 1. Complete System Architecture

```mermaid
graph TD
    Client[Flutter Mobile & Web Client] --> Gateway[API Gateway / TLS 1.3]
    Gateway --> DRF[Django REST Framework]
    
    subgraph "Data Storage Tier"
        DRF --> DB[(PostgreSQL Master DB)]
        DRF --> Cache[(Redis Cache & Session Broker)]
    end

    subgraph "AI Inference Pipeline"
        DRF --> Gemini[Google Gemini 1.5 Pro AI]
        DRF --> LocalONNX[Local ONNX Model Engine]
    end

    subgraph "Smart Collar IoT Subsystem"
        Client --> BLE[Bluetooth Low Energy]
        Collar[ESP32 Smart Collar] --> MQTT[MQTT Broker]
        MQTT --> DRF
    end
```
