module "huggingface_sagemaker" {
  source               = "philschmid/sagemaker-huggingface/aws"
  version              = "0.5.0"
  name_prefix          = "distilbert"
  pytorch_version      = "1.9.1"
  transformers_version = "4.12.3"
  instance_type        = "ml.m5.large"
  instance_count       = 1
  hf_model_id          = "yiyanghkust/finbert-tone"
  hf_task              = "text-classification"
}
