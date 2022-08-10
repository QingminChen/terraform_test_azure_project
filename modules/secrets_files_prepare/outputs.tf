output "dbks_pat_value" {
  value = "${databricks_token.pat.token_value}"
  sensitive = true
}

output "key_vault_app_client_secret_name" {
  value = "${azurerm_key_vault_secret.testkvsecret2tf.name}"
}

output "kv_evhub_share_str_name" {
  value    = "${azurerm_key_vault_secret.EVHBShareKeytf.name}"
}

output "secrets_depends_on" {
//  type         = any
  value        = {}
  depends_on   = [azurerm_key_vault_secret.testkvsecret2tf]
}


