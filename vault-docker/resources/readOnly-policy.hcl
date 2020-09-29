# List and read key/value secrets
path "secret/*"
{
  capabilities = ["read", "list"]
}

# List existing secrets engines.
path "sys/mounts"
{
  capabilities = ["read", "list"]
}

# List UI metadata
path "+/metadata/*"
{
  capabilities = ["read", "list"]
}

# Read UI data
path "+/data/*"
{
  capabilities = ["read", "list"]
}
