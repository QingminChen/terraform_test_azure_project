//
//output "client_secret_key_id" {
//  description = "client_secret_key_id"
//  value       = "${azuread_application_password.test_active_directory_client_tf.key_id}"
//}
//
//
//output "current_user_id" {
//  value = "${data.azuread_client_config.current.client_id}"
//  sensitive   = true
//}

//output "client_current_object_id" {
//  value = "${data.azuread_client_config.current.object_id}"
//}
//
//output "databricks_id" {
//  value = "${azurerm_databricks_workspace.test_dbk_wksp_tf.id}"
//}
//
//
//
//output "databricks_connection" {
//  value = "${azurerm_databricks_workspace.test_dbk_wksp_tf.workspace_url}"
//}
//
//output "databricks_token_value" {
//  value = "${databricks_token.pat.token_value}"
//  sensitive   = true
//}
//
//output "databricks_cluster_id" {
//  value = "${databricks_cluster.test_dbks_cluster_tf.id}"
//  sensitive   = true
//}



////
output "kv_id" {
  value = "${azurerm_key_vault.testkv22222tf.id}"
}

output "client_current_tenant_id" {
  value = "${data.azuread_client_config.current.tenant_id}"
}

output "app_service_principal_object_id" {
  value = "${azuread_service_principal.test_active_directory_tf.object_id}"
}

output "app_id" {
  value = "${azuread_application.test_active_directory_tf.id}"
}

output "evthubnmspctf_connect_str" {
  value = "${azurerm_eventhub_namespace.testevthubnmspctf.default_secondary_connection_string}"
  sensitive   = true
}

output "storage_account_id" {
  value = "${azurerm_storage_account.teststorage2222tf.id}"
}

output "databricks_wsp_id" {
  value = "${azurerm_databricks_workspace.test_dbk_wksp_tf.id}"
}

output "databricks_wsp_url" {
  value = "${azurerm_databricks_workspace.test_dbk_wksp_tf.workspace_url}"
}

output "app_client_id" {
  value = "${azuread_application.test_active_directory_tf.application_id}"
}

output "client_secret_value" {
  value       = "${azuread_application_password.test_active_directory_client_tf.value}"
  sensitive   = true
}

//output "databricks_cluster_id" {
//  value = "${databricks_cluster.test_dbks_cluster_tf.id}"
//  sensitive   = true
//}

output "databricks_wsp_depends_on" {
//  type         = any
  value        = {}
  depends_on   = [azurerm_databricks_workspace.test_dbk_wksp_tf]
}

output "storage_account_name" {
  value        = "${azurerm_storage_account.teststorage2222tf.name}"
}

output "storage_account_container_name" {
  value        = "${azurerm_storage_container.datalaketf.name}"
}

output "event_hub_name" {
  value        = "${azurerm_eventhub.testevthub1tf.name}"
}
