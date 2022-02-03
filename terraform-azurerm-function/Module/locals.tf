locals {
  storage_account_name    = "${replace("${lower(("${var.function_app_name}funcsta"))}", "/[^a-z0-9]/", "")}"
  app_service_plan_name   = "${var.function_app_name}-plan"
  function_app_name       = "${var.function_app_name}-func"
  autoscale_settings_name = "${var.function_app_name}-autoscale"
}
