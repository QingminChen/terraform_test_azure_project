//
//output "client_secret_key_id" {
//  description = "client_secret_key_id"
//  value       = "${azuread_application_password.test_active_directory_client_tf.key_id}"
//}
//
//output "client_secret_value" {
//  description = "client_secret_value"
//  value       = "${azuread_application_password.test_active_directory_client_tf.value}"
//  sensitive   = true
//}
//
//output "current_user_id" {
//  value = "${data.azuread_client_config.current.client_id}"
//  sensitive   = true
//}
//
//output "storage_account_id" {
//  value = "${azurerm_storage_account.teststorage2222tf.id}"
//}
//
//output "app_service_principal_object_id" {
//  value = "${azuread_service_principal.test_active_directory_tf.object_id}"
//}
//
//output "client_current_tenant_id" {
//  value = "${data.azuread_client_config.current.tenant_id}"
//}
//
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
  value = "${module.iaas_create.kv_id}"
}

output "client_current_tenant_id" {
  value = "${module.iaas_create.client_current_tenant_id}"
}

output "app_service_principal_object_id" {
  value = "${module.iaas_create.app_service_principal_object_id}"
}

output "app_id" {
  value = "${module.iaas_create.app_id}"
}

output "evthubnmspctf_connect_str" {
  value = "${module.iaas_create.evthubnmspctf_connect_str}"
  sensitive   = true
}

output "storage_account_id" {
  value = "${module.iaas_create.storage_account_id}"
}

output "databricks_wsp_id" {
  value = "${module.iaas_create.databricks_wsp_id}"
}

output "databricks_wsp_url" {
  value = "${module.iaas_create.databricks_wsp_url}"
}

output "app_client_id" {
  value = "${module.iaas_create.app_client_id}"
}

output "client_secret_value" {
  value       = "${module.iaas_create.client_secret_value}"
  sensitive   = true
}

output "dbks_pat_value" {
  value       = "${module.secrets_files_prepare.dbks_pat_value}"
  sensitive   = true
}

output "storage_account_container_name" {
  value       = "${module.iaas_create.storage_account_container_name}"
}

