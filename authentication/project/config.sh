#! /bin/bash


vault write pki/root/generate/internal \
    common_name=centralizer.io \
    ttl=8760h


vault write pki/roles/centralizer-dot-io \
    allowed_domains=centralizer.io \
    allow_subdomains=true \
    key_type=any \
    max_ttl=72h



vault policy write pki - <<EOF
path "pki*"                        { capabilities = ["read", "list"] }
path "pki/sign/centralizer-dot-io"    { capabilities = ["create", "update"] }
path "pki/issue/centralizer-dot-io"   { capabilities = ["create"] }
EOF


vault write auth/kubernetes/role/issuer \
    bound_service_account_names="*" \
    bound_service_account_namespaces="*" \
    policies=pki \
    key_type=any \
    ttl=20m
