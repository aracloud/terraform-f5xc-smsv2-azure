# Fetch local hostname for tagging in Azure
data "external" "hostname" {
  program = [
    "bash",
    "-c",
    "echo '{\"hostname\":\"'$(hostname)'\"}'"
  ]
}

locals {
  hostname = data.external.hostname.result.hostname
}
