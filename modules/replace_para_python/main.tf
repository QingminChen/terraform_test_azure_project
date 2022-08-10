terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

#In Used#
data "databricks_current_user" "dbks_current" {
   depends_on = [var.secrets_files_prepare_out_secrets_depends_on]

}


//#In use on linux
//resource "local_file" "generate_replace_shell_script_for_delta_tbl_config" {
//    content  = "#!/bin/bash\nsed -i 's/#{storage_account_container_name}#/${var.iaas_out_storage_account_container_name}/g' ${var.root_pass_notebook_src_path}/delta_table_configuration.py"
//    filename = "${var.root_pass_home_path}/generate_replace_scripts_delta_tbl_config_auto.sh"
//}
//
//#In use on linux
//resource "local_file" "generate_replace_shell_script_for_key_config" {
//    content  = "#!/bin/bash\nsed -i 's/#{storage_account_name}#/${var.iaas_out_storage_account_name}/g' ${var.root_pass_notebook_src_path}/key_configuration.py\nsed -i 's/#{storage_account_container_name}#/${var.iaas_out_storage_account_container_name}/g' ${var.root_pass_notebook_src_path}/key_configuration.py\nsed -i 's/#{client_current_tenant_id}#/${var.iaas_out_client_current_tenant_id}/g' ${var.root_pass_notebook_src_path}/key_configuration.py\nsed -i 's/#{app_client_id}#/${var.iaas_out_app_client_id}/g' ${var.root_pass_notebook_src_path}/key_configuration.py\nsed -i 's/#{key_vault_app_client_secret_name}#/${var.secets_files_prepare_out_key_vault_app_client_secret_name}/g' ${var.root_pass_notebook_src_path}/key_configuration.py"
//    filename = "${var.root_pass_home_path}/generate_replace_scripts_key_config_auto.sh"
//}

//#In use on linux
//resource "local_file" "generate_replace_shell_script_for_stream_app" {
//    content  = "#!/bin/bash\nsed -i '' 's/#{storage_account_name}#/${var.iaas_out_storage_account_name}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{storage_account_container_name}#/${var.iaas_out_storage_account_container_name}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{client_current_tenant_id}#/#{var.iaas_out_client_current_tenant_id}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{app_id}#/${var.iaas_out_client_current_tenant_id}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{key_vault_app_client_secret_name}#/${var.secets_files_prepare_out_key_vault_app_client_secret_name}/g' ${var.root_pass_notebook_src_path}/streamming_app.py"
//    filename = "${var.root_pass_home_path}/generate_replace_scripts_stream_app_auto.sh"
//}




#In use on Mac
resource "local_file" "generate_replace_shell_script_for_delta_tbl_config" {
    content  = "#!/bin/bash\nsed -i '' 's/#{storage_account_container_name}#/${var.iaas_out_storage_account_container_name}/g' ${var.root_pass_notebook_src_path}/delta_table_configuration.py"
    filename = "${var.root_pass_home_path}/generate_replace_scripts_delta_tbl_config_auto.sh"
}

#In use on Mac
resource "local_file" "generate_replace_shell_script_for_key_config" {
    content  = "#!/bin/bash\nsed -i '' 's/#{storage_account_name}#/${var.iaas_out_storage_account_name}/g' ${var.root_pass_notebook_src_path}/key_configuration.py\nsed -i '' 's/#{storage_account_container_name}#/${var.iaas_out_storage_account_container_name}/g' ${var.root_pass_notebook_src_path}/key_configuration.py\nsed -i '' 's/#{client_current_tenant_id}#/${var.iaas_out_client_current_tenant_id}/g' ${var.root_pass_notebook_src_path}/key_configuration.py\nsed -i '' 's/#{app_client_id}#/${var.iaas_out_app_client_id}/g' ${var.root_pass_notebook_src_path}/key_configuration.py\nsed -i '' 's/#{key_vault_app_client_secret_name}#/${var.secets_files_prepare_out_key_vault_app_client_secret_name}/g' ${var.root_pass_notebook_src_path}/key_configuration.py"
    filename = "${var.root_pass_home_path}/generate_replace_scripts_key_config_auto.sh"
}

#In use on Mac
resource "local_file" "generate_replace_shell_script_for_stream_app" {
    content  = "#!/bin/bash\nsed -i '' 's/#{secets_files_prepare_out_kv_evhub_share_str_name}#/${var.secets_files_prepare_out_kv_evhub_share_str_name}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{iaas_out_event_hub_name}#/${var.iaas_out_event_hub_name}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{key_vault_app_client_secret_name}#/${var.secets_files_prepare_out_key_vault_app_client_secret_name}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{storage_account_name}#/${var.iaas_out_storage_account_name}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{app_client_id}#/${var.iaas_out_app_client_id}/g' ${var.root_pass_notebook_src_path}/streamming_app.py\nsed -i '' 's/#{client_current_tenant_id}#/${var.iaas_out_client_current_tenant_id}/g' ${var.root_pass_notebook_src_path}/streamming_app.py"
    filename = "${var.root_pass_home_path}/generate_replace_scripts_stream_app_auto.sh"
}


#In use
resource "null_resource" "replace_delta_tbl_config" {

  provisioner "local-exec" {

    working_dir = "${var.root_pass_home_path}"
//    interpreter = ["/bin/bash", "-c"]
    command = "${var.root_pass_home_path}/generate_replace_scripts_delta_tbl_config_auto.sh"
    when = create
  }
  depends_on = [local_file.generate_replace_shell_script_for_delta_tbl_config]
}

#In use
resource "null_resource" "replace_key_config" {

  provisioner "local-exec" {

    working_dir = "${var.root_pass_home_path}"
//    interpreter = ["/bin/bash", "-c"]
    command = "${var.root_pass_home_path}/generate_replace_scripts_key_config_auto.sh"
    when = create
  }
  depends_on = [local_file.generate_replace_shell_script_for_key_config]
}

#In use
resource "null_resource" "replace_stream_app" {

  provisioner "local-exec" {

    working_dir = "${var.root_pass_home_path}"
//    interpreter = ["/bin/bash", "-c"]
    command = "${var.root_pass_home_path}/generate_replace_scripts_stream_app_auto.sh"
    when = create
  }
  depends_on = [local_file.generate_replace_shell_script_for_stream_app]
}





#In Used#
resource "databricks_notebook" "delta_table_config" {
  provider = databricks
//  source = "/Users/chenqingmin/Codes/terraform_test_azure_project/src/delta_table_configuration.py"
  source = "${var.root_pass_notebook_src_path}/delta_table_configuration.py"
  path   = "${data.databricks_current_user.dbks_current.home}/src/delta_table_configuration.py"

  depends_on = [null_resource.replace_delta_tbl_config,null_resource.replace_key_config] // in use
}

#In Used#
resource "databricks_notebook" "key_config" {
  provider = databricks
//  source = "/Users/chenqingmin/Codes/terraform_test_azure_project/src/key_configuration.py"
  source = "${var.root_pass_notebook_src_path}/key_configuration.py"
  path   = "${data.databricks_current_user.dbks_current.home}/src/key_configuration.py"

  depends_on = [null_resource.replace_delta_tbl_config,null_resource.replace_key_config] // in use
}
#In Used#
resource "databricks_notebook" "streamming_app" {
  provider = databricks
//  source = "/Users/chenqingmin/Codes/terraform_test_azure_project/src/streamming_app.py"
  source = "${var.root_pass_notebook_src_path}/streamming_app.py"
  path   = "${data.databricks_current_user.dbks_current.home}/src/streamming_app.py"

  depends_on = [null_resource.replace_delta_tbl_config,null_resource.replace_key_config] // in use
}