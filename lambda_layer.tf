resource "aws_lambda_layer_version" "mqtt_layer" {
  filename                 = " " # provide path to the local directory where the zipped layer is stored
  layer_name               = "mqtt_layer"
  description              = "Python layer for mqtt."
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["python3.7"]
}
