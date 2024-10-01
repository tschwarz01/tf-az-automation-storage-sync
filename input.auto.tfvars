resource_group_name = "rg-fdx-automation-jb123"
location            = "Central US"


# source_stg_account_resource_group = "rg-analytics-synapse01"
# source_stg_acct_name              = "stgdatadw"
source_stg_account_resource_group = "rg-cabida-centus-iac-inf"
source_stg_acct_name              = "sacabidainf"
dest_storage_acct_name            = "stgdstcopytst"
vm_worker_name                    = "vmwinautowrkjb"
auto_acct_name                    = "autoacctjb29"
vm_admin_username                 = ""
vm_admin_password                 = ""

priv_dns_zone_id_blob = "/subscriptions/8c881d12-a2a2-4d4a-a9d8-76d1b121d014/resourceGroups/centralus-fdx-canada-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
priv_dns_zone_id_dfs  = "/subscriptions/8c881d12-a2a2-4d4a-a9d8-76d1b121d014/resourceGroups/centralus-fdx-canada-network-rg/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.core.windows.net"

