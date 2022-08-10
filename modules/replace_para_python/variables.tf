//variable "iaas_out_kv_id" {
//  type = string
//}
//
variable "iaas_out_client_current_tenant_id" {
  type = string
}
//
//variable "iaas_out_app_service_principal_object_id" {
//  type = string
//}
//
//variable "iaas_out_app_id" {
//  type = string
//}
//
//variable "iaas_out_evthubnmspctf_connect_str" {
//  type = string
//}
//
//variable "iaas_out_storage_account_id" {
//  type = string
//}
//
//variable "iaas_out_databricks_wsp_id" {
//  type = string
//}
//
//variable "iaas_out_databricks_wsp_url" {
//  type = string
//}
//
variable "iaas_out_app_client_id" {
  type = string
}
//
//variable "iaas_out_client_secret_value" {
//  type = string
//}
//
//variable "iaas_out_dbks_wsp_depends_on" {
//  type    = any
//  default = []
//}

variable "iaas_out_storage_account_name" {
  type    = string
}

variable "iaas_out_storage_account_container_name" {
  type    = string
}

variable "secets_files_prepare_out_key_vault_app_client_secret_name" {
  type = string
}

variable "secrets_files_prepare_out_secrets_depends_on" {
  type    = any
  default = []
}

variable "root_pass_notebook_src_path" {
  type    = string
}

variable "root_pass_home_path" {
  type    = string
}

variable "iaas_out_event_hub_name" {
  type    = string
}

variable "secets_files_prepare_out_kv_evhub_share_str_name" {
  type    = string
}

