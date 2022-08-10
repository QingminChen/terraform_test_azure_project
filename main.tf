#In Used#
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.15.1"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}

//#In Used#
provider "databricks" {
}

#In Used#
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_key_vaults = false
    }
  }
}

#In Used#
provider "databricks" {
  alias = "dbks_connect"
  host                        = module.iaas_create.databricks_wsp_url
  azure_workspace_resource_id = module.iaas_create.databricks_wsp_id
  azure_client_id             = module.iaas_create.app_client_id
  azure_client_secret         = module.iaas_create.client_secret_value
  azure_tenant_id             = module.iaas_create.client_current_tenant_id
//  host = "https://adb-4294829096871642.2.azuredatabricks.net"
//  username = "testgcpusertwo@gmail.com"
//  password = "badboy5769843027"
//  auth_type = "basic"
}

locals {
  module_path        = abspath(path.root)
}

module "iaas_create" {
  source = "./modules/iaas_create"   //used
   rs_gp_tf_nm = var.outer_rs_gp_tf_nm
   location = var.outer_location
}

module "secrets_files_prepare" {
  source = "./modules/secrets_files_prepare"

  iaas_out_kv_id = module.iaas_create.kv_id

  iaas_out_client_current_tenant_id = module.iaas_create.client_current_tenant_id

  iaas_out_app_service_principal_object_id = module.iaas_create.app_service_principal_object_id

  iaas_out_app_id = module.iaas_create.app_id

  iaas_out_evthubnmspctf_connect_str = module.iaas_create.evthubnmspctf_connect_str

  iaas_out_storage_account_id = module.iaas_create.storage_account_id

  iaas_out_databricks_wsp_id = module.iaas_create.databricks_wsp_id

  iaas_out_databricks_wsp_url = module.iaas_create.databricks_wsp_url

  iaas_out_app_client_id = module.iaas_create.app_client_id

  iaas_out_client_secret_value = module.iaas_create.client_secret_value

  iaas_out_storage_account_name = module.iaas_create.storage_account_name

  iaas_out_dbks_wsp_depends_on = [module.iaas_create.databricks_wsp_depends_on]

  providers = {
    databricks = databricks.dbks_connect
  }
  depends_on = [module.iaas_create]
}


module "replace_para_python" {
  source = "./modules/replace_para_python"

  iaas_out_client_current_tenant_id = module.iaas_create.client_current_tenant_id
  iaas_out_storage_account_name = module.iaas_create.storage_account_name
  iaas_out_storage_account_container_name = module.iaas_create.storage_account_container_name
  secets_files_prepare_out_key_vault_app_client_secret_name = module.secrets_files_prepare.key_vault_app_client_secret_name
  iaas_out_app_client_id = module.iaas_create.app_client_id

  secrets_files_prepare_out_secrets_depends_on = [module.secrets_files_prepare.secrets_depends_on]
  root_pass_notebook_src_path = "${local.module_path}/src"
  root_pass_home_path = "${local.module_path}"

  iaas_out_event_hub_name = module.iaas_create.event_hub_name
  secets_files_prepare_out_kv_evhub_share_str_name = module.secrets_files_prepare.kv_evhub_share_str_name

  providers = {
    databricks = databricks.dbks_connect
  }
  depends_on = [module.secrets_files_prepare]
}



//module "replace_para_python" {
////  source = "./modules/replace_para_python"
////
////  iaas_out_client_current_tenant_id = "2890298d-6798-4ee8-8e84-320d2c1268cb"
////  iaas_out_storage_account_name = "teststorage2222tf"
////  iaas_out_storage_account_container_name = "datalake"
////  secets_files_prepare_out_key_vault_app_client_secret_name = "testkvsecret2tf"
////
////  secrets_files_prepare_out_secrets_depends_on = [module.secrets_files_prepare.secrets_depends_on]
//  root_pass_notebook_src_path = "${local.module_path}/src"
//  root_pass_home_path = "${local.module_path}"
//
////  providers = {
////    databricks = databricks.dbks_connect
////  }
////  depends_on = [module.secrets_files_prepare]
//}