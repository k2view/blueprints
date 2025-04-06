prefix_name          = "ClusterName"
resource_group_name  = "CLUSTER-NAME-rg"
location             = "West Europe"
domain               = "CLUSTER-NAME.SUBDOMAIN.DOMAIN.com"
cluster_name         = "CLUSTER-NAME"
max_size             = 3

# Agent
mailbox_id          = "aaa-bbb-ccc-ddd-eee"
mailbox_url         = "https://cloud.k2view.com/api/mailbox"

tags = { Env = "Dev", Project = "k2v_cloud", Owner = "owner_name" }
