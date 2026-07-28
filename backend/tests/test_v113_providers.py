from django.test import TestCase
from apps.common.providers.ai_providers import AiProviderFactory, GeminiProvider, OpenAiProvider, LocalOnnxProvider
from apps.common.providers.email_providers import EmailProviderFactory, SendGridEmailProvider, SmtpEmailProvider
from apps.common.providers.storage_providers import StorageProviderFactory, AwsS3StorageProvider, MinioStorageProvider
from apps.common.providers.health import ProviderHealthMonitor

class RealServiceProvidersV113Tests(TestCase):

    def test_ai_provider_factory_instantiation_and_analysis(self):
        gemini = AiProviderFactory.get_provider('gemini')
        self.assertIsInstance(gemini, GeminiProvider)
        res_gemini = gemini.analyze_vision('skin_disease', 'https://storage.petconnect.ai/skin.jpg')
        self.assertEqual(res_gemini['provider'], 'Google Gemini Pro Vision')

        openai_p = AiProviderFactory.get_provider('openai')
        self.assertIsInstance(openai_p, OpenAiProvider)
        res_openai = openai_p.analyze_vision('eye_disease', 'https://storage.petconnect.ai/eye.jpg')
        self.assertEqual(res_openai['provider'], 'OpenAI GPT-4o Vision')

        onnx_p = AiProviderFactory.get_provider('onnx')
        self.assertIsInstance(onnx_p, LocalOnnxProvider)
        res_onnx = onnx_p.analyze_vision('dental_disease', 'https://storage.petconnect.ai/teeth.jpg')
        self.assertEqual(res_onnx['provider'], 'Local ONNX Runtime (YOLOv8)')

    def test_email_provider_factory(self):
        smtp = EmailProviderFactory.get_provider('smtp')
        self.assertIsInstance(smtp, SmtpEmailProvider)
        self.assertTrue(smtp.send_email('user@petconnect.ai', 'Welcome', 'Welcome to PetConnect AI'))

        sg = EmailProviderFactory.get_provider('sendgrid')
        self.assertIsInstance(sg, SendGridEmailProvider)
        self.assertTrue(sg.send_email('user@petconnect.ai', 'Verification', 'Verify your email'))

    def test_storage_provider_signed_urls(self):
        s3 = StorageProviderFactory.get_provider('s3')
        self.assertIsInstance(s3, AwsS3StorageProvider)
        url = s3.generate_signed_url('pets/photo1.jpg')
        self.assertIn('s3.amazonaws.com', url)

        minio = StorageProviderFactory.get_provider('minio')
        self.assertIsInstance(minio, MinioStorageProvider)
        minio_url = minio.generate_signed_url('pets/photo2.jpg')
        self.assertIn('localhost:9000', minio_url)

    def test_provider_health_monitoring(self):
        statuses = ProviderHealthMonitor.get_all_provider_statuses()
        self.assertIn('ai_provider', statuses)
        self.assertEqual(statuses['ai_provider']['status'], 'OPERATIONAL')
        self.assertEqual(statuses['storage_provider']['status'], 'OPERATIONAL')
