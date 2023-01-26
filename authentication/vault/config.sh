#! /bin/bash


vault write pki/root/generate/internal \
    iomon_name=centralizer.io \
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





~/learning/authentication on ☁️  (us-east-1) 
❯ kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh
/ $ vault write pki/root/generate/internal \
>     iomon_name=centralizer.io \
>     ttl=8760h
WARNING! The following warnings were returned from Vault:

  * This issuer certificate was generated without a Subject; this makes
  it likely that issuing leaf certs with this certificate will cause TLS
  validation libraries to reject this certificate.

  * Endpoint ignored these unrecognized parameters: [iomon_name]

Key              Value
---              -----
certificate      -----BEGIN CERTIFICATE-----
MIIDazCCAlOgAwIBAgIUdRaoWitsdCb9rV9vp06fWik/lhwwDQYJKoZIhvcNAQEL
BQAwADAeFw0yMzAxMTExOTM5MDRaFw0yNDAxMTExOTM5MzRaMAAwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQrUW+NSQ5kOa88bj9AkyTVeF+IpIv5pPM
dQOq20MYvPf97lteSQH8d1HThLk/6yJtyNU0gigqkG4GadmV4JiNfpXI6q0gldLz
1mlCCeqpMfGmLLQQC6E5i7gkzFbo2o/FbSf4FZ+VU2Uw5ZeUhnEWLJ1kkqkIQyJ5
HZv2AnaexoT5dxOBFL3+z26hx8OrNbceIDgQxIhNejW4MkORonAVP8r2V2BiwoMM
FRgxYTqL0Ee9Kbf7ONoe5jwh+cyBLItRvd3TRPq8uEmaW7AoGdpWxNmUL2oDQ1j0
pKgUOV1FzL3bQsQaKOzUSAiy35KlwL5iU9QKUYlE+i/Ak7PdPU0vAgMBAAGjgdww
gdkwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFIM3
C+jPSKiXBQ5z5ATwgbdHR0LxMB8GA1UdIwQYMBaAFIM3C+jPSKiXBQ5z5ATwgbdH
R0LxMD8GCCsGAQUFBwEBBDMwMTAvBggrBgEFBQcwAoYjaHR0cDovL3ZhdWx0LmRl
ZmF1bHQ6ODIwMC92MS9wa2kvY2EwNQYDVR0fBC4wLDAqoCigJoYkaHR0cDovL3Zh
dWx0LmRlZmF1bHQ6ODIwMC92MS9wa2kvY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQCI
y49hOuX9yhG/iWQAeQChObiKcv6a496009dypNC0BRoEEAnONvQXU6ZKufBP/lh8
x5qB+zpyfwKMEoqXMi5x6XMsBKYXI0A6H68DGmUxZFHRxngW5bEXLf+4GjQhAwsB
7OJLP4racecXeSg46RJG2X+aPd58+34LNI9gleR5p+CQozLg5YvG6KIpqqSp/g9b
DK/YKpGBg2xZm18lFGQGtYPFdVQv5+bZJYpEdbMnhn76vQl4dlLAQmApBOL2HqtY
juOv1GpulinqTRDRzbQGE371xReUd1O5nsp7TR7HbcOOeVPSdRsSfYQayVKAiGx7
XrAGBhvRIZftvIwiAZHX
-----END CERTIFICATE-----
expiration       1705001974
issuer_id        0878015e-94d7-fa30-8ae4-a2ac5d4a5f17
issuer_name      n/a
issuing_ca       -----BEGIN CERTIFICATE-----
MIIDazCCAlOgAwIBAgIUdRaoWitsdCb9rV9vp06fWik/lhwwDQYJKoZIhvcNAQEL
BQAwADAeFw0yMzAxMTExOTM5MDRaFw0yNDAxMTExOTM5MzRaMAAwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQrUW+NSQ5kOa88bj9AkyTVeF+IpIv5pPM
dQOq20MYvPf97lteSQH8d1HThLk/6yJtyNU0gigqkG4GadmV4JiNfpXI6q0gldLz
1mlCCeqpMfGmLLQQC6E5i7gkzFbo2o/FbSf4FZ+VU2Uw5ZeUhnEWLJ1kkqkIQyJ5
HZv2AnaexoT5dxOBFL3+z26hx8OrNbceIDgQxIhNejW4MkORonAVP8r2V2BiwoMM
FRgxYTqL0Ee9Kbf7ONoe5jwh+cyBLItRvd3TRPq8uEmaW7AoGdpWxNmUL2oDQ1j0
pKgUOV1FzL3bQsQaKOzUSAiy35KlwL5iU9QKUYlE+i/Ak7PdPU0vAgMBAAGjgdww
gdkwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFIM3
C+jPSKiXBQ5z5ATwgbdHR0LxMB8GA1UdIwQYMBaAFIM3C+jPSKiXBQ5z5ATwgbdH
R0LxMD8GCCsGAQUFBwEBBDMwMTAvBggrBgEFBQcwAoYjaHR0cDovL3ZhdWx0LmRl
ZmF1bHQ6ODIwMC92MS9wa2kvY2EwNQYDVR0fBC4wLDAqoCigJoYkaHR0cDovL3Zh
dWx0LmRlZmF1bHQ6ODIwMC92MS9wa2kvY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQCI
y49hOuX9yhG/iWQAeQChObiKcv6a496009dypNC0BRoEEAnONvQXU6ZKufBP/lh8
x5qB+zpyfwKMEoqXMi5x6XMsBKYXI0A6H68DGmUxZFHRxngW5bEXLf+4GjQhAwsB
7OJLP4racecXeSg46RJG2X+aPd58+34LNI9gleR5p+CQozLg5YvG6KIpqqSp/g9b
DK/YKpGBg2xZm18lFGQGtYPFdVQv5+bZJYpEdbMnhn76vQl4dlLAQmApBOL2HqtY
juOv1GpulinqTRDRzbQGE371xReUd1O5nsp7TR7HbcOOeVPSdRsSfYQayVKAiGx7
XrAGBhvRIZftvIwiAZHX
-----END CERTIFICATE-----
key_id           ffe59ac6-612b-ef98-fcaf-0459939b835e
key_name         n/a
serial_number    75:16:a8:5a:2b:6c:74:26:fd:ad:5f:6f:a7:4e:9f:5a:29:3f:96:1c
/ $ 