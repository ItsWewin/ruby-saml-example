class Account < ActiveRecord::Base
  def self.get_saml_settings(url_base)
    # this is just for testing purposes.
    # should retrieve SAML-settings based on subdomain, IP-address, NameID or similar
    settings = OneLogin::RubySaml::Settings.new

    url_base ||= "http://localhost:3000"

    # Example settings data, replace this values!

    # When disabled, saml validation errors will raise an exception.
    settings.soft = false

    #SP section
    settings.issuer                         = url_base + "/saml/metadata"
    settings.assertion_consumer_service_url = url_base + "/saml/acs"
    settings.assertion_consumer_logout_service_url = url_base + "/saml/logout"

    onelogin_app_id = "<onelogin-app-id>"

    # IdP section
    settings.idp_entity_id                  = "https://gitee.com"
    settings.idp_sso_target_url             = "http://git.zhbit.com/saml_authen/login"
    settings.idp_slo_target_url             = "https://app.onelogin.com/trust/saml2/http-redirect/slo/#{onelogin_app_id}"
    settings.idp_cert = <<-CERT
-----BEGIN CERTIFICATE-----
MIIDJzCCAg+gAwIBAgIJAKBdkXFvGevHMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTkwNDE1MDY1MjE2WhcNMjkwNDEyMDY1MjE2WjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEA8y+YPlpieAitV8wP4ugz9zWdjcNWbcgB40lIxuVbAMfEsfqmJ+z6AuRm
2ARw+9GCHH7f3a1YTd4FYjmIgAmnALKYuQaDPjx9PXtO4hogqvZW3IA6VuVIGUCI
l97P3Q+fPLQ1/IfjrIOvKiLYnQcf/OOfZOLKTRANywnndPKnZGJ6AwkE1K7h9J2Y
RQ9YMtaRDq+WLyh+nqVOfwavhDG4igWb7h/Gh1WiNNoKTJcEkLVtjWod3y8BJxp6
ij9fP8KCjlHJ+ylfFz2qWdUeBTIseajpXXHAmlKUPSdPzX25bCAVtuyHdQxGmTh4
i465HKJik+ZOl6aY3GN/K98mlxnHRQIDAQABoxowGDAJBgNVHRMEAjAAMAsGA1Ud
DwQEAwIF4DANBgkqhkiG9w0BAQsFAAOCAQEAocORezEaijfX/uDZINJ/kswgO71z
Cbmtdr7VxU+l3FwPe2iPDIm29G7/CmNwmATgoco6KGPNHUpG7wT+cLgAOkGWNWAP
nIWRUuVxL9JHs7wMXMmSJn7JMbLJW8dQGVLxjScnglNPF2f6DQCCmxZQwBbDwuJS
+nvI8/cxJN+Gi2i9fty7zC5gX12EhdvRodU8VCqqmoOZ/bMxbQvK2uw8NFpt/HrR
Rt3qg6W0KKFW+/rJi8Fta5X4UVdrV0VfH6y1oPksrIQzziw/hb8hKHmMDWvDUpDk
XmSHFXmRh/RQI61OxG8ye5HMpjb/ATaSHbL3ZCXuOJHvrFyRbGVeS9Nl4A==
-----END CERTIFICATE-----
CERT

    settings.private_key = <<-PRI
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDzL5g+WmJ4CK1X
zA/i6DP3NZ2Nw1ZtyAHjSUjG5VsAx8Sx+qYn7PoC5GbYBHD70YIcft/drVhN3gVi
OYiACacAspi5BoM+PH09e07iGiCq9lbcgDpW5UgZQIiX3s/dD588tDX8h+Osg68q
ItidBx/8459k4spNEA3LCed08qdkYnoDCQTUruH0nZhFD1gy1pEOr5YvKH6epU5/
Bq+EMbiKBZvuH8aHVaI02gpMlwSQtW2Nah3fLwEnGnqKP18/woKOUcn7KV8XPapZ
1R4FMix5qOldccCaUpQ9J0/NfblsIBW27Id1DEaZOHiLjrkcomKT5k6XppjcY38r
3yaXGcdFAgMBAAECggEAYRfhmxOPOQmN2/33Ycr/5HWdoBobid1PE6YQzoiIGvmn
iL/gUxSEhV8XyKuNSJ1Pa30keGdbWEuKrrr1ytkPunGUFFuLTu/ruP5gclmoLVoJ
OCRiJouIi7x+TNSC/WndU+lHnLnMpvY0m4gqIBfWJ6vh2e/KgZYlS6l6pfCz8Jmx
gORV4hEVpaN0l+/tZJHaR1w4R3gaJugqmAgLGbTVMk+WD3iBQKo64u1+inXYF6Cq
ovnKe8Jak5ztnkcvruL3MrX/D3RjPjbAucqCfvbt8ZbTiSIaa0Ama6pY5UySf1b+
YUVAES3/dCxJOJgCCZYeFu2CBe7aaQjmBpOPQFd1yQKBgQD+udZmiMDWsdzidmca
emm7xEqSJW9gSWAO3IlIrQbZPkugO3GaN4J45CneheA5vOgQMlk85dFabBXHPr1Y
uBobKnHghdP9agPr3NYal4xc3k8cD9W4Bk5lQtj6Y5XB4eSu4FLiOHJudW85OxC2
WrQCSjWR9vxiHkalFOkk0jTmxwKBgQD0ZvsZHfnnlRTeASzRDtKOP8jBFNptBfD1
Cr0VHCmmdgECVy2CsLpBqk2TgNrPeFE6BUJAqbfpja+C86R76fU+f1rqKwqlm9SI
TQZAIadUDafnaAxu0vWC3WrCclNGxOZnXTAvC6mM+tWKo+VcByOzTVB0vhXty+oa
c7Hf/y2lkwKBgQCSlbsN0lC2vDASmnSGxj8mcLVBGQ3Y6SDALKVMD1ZLmg/HK64a
QytwCk0V4xC/6Tfaaj70ToSFdoGp4S7xaTCMxYY24Iy33lRXXQRQ1TlPEBeSXIJu
niJrH2bh4IEDy8zf3fOUf0tKyYWx942MgvHoB3CAiROAG1AoG7p3GAidbQKBgQCU
YsnlUAvgjOUkfPYm36b68sMCZ5TOSKMpQ6HVZUnsZQzrzN420PHk2G9NNRikilpW
rcax19lvlbSP/zlIep2Jmm0qa4OFVP1O2+UFnukm4TumBcg2qSKil6gv8pWZDAcP
jsaoaZ5BmDF6gVPJ8hO80x4cIyTRQdMayE+gvh+KvQKBgQDOfglz8NJbHVaP1dgz
5N3YXeXaC7jJ/ht45k3Ilb14oC/kkqpV7crUlk4gQBYDO4uE5tLOEBYH7CKQebY2
SxMqxpbFF/vkbxORDjn6t1Dhu3Lh4N9o7TsK/yR5yLWJVall68lv6VIz4XIklqU5
67YUYdSJ/kWuT7gxI8wxzrRbcw==
-----END PRIVATE KEY-----
PRI

    settings.idp_cert_fingerprint           = "gitee.com"
    # settings.idp_cert_fingerprint_algorithm = XMLSecurity::Document::RSA_SHA256

    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

    # Security section
    settings.security[:authn_requests_signed] = true
    settings.security[:embed_sign] = false
    settings.security[:logout_requests_signed] = false
    settings.security[:logout_responses_signed] = false
    settings.security[:metadata_signed] = false
    settings.security[:digest_method] = XMLSecurity::Document::RSA_SHA256
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA256

    signing1 = <<-CERT
  -----BEGIN CERTIFICATE-----
  MIIDJzCCAg+gAwIBAgIJAKBdkXFvGevHMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
  BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
  aWRnaXRzIFB0eSBMdGQwHhcNMTkwNDE1MDY1MjE2WhcNMjkwNDEyMDY1MjE2WjBF
  MQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50
  ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
  CgKCAQEA8y+YPlpieAitV8wP4ugz9zWdjcNWbcgB40lIxuVbAMfEsfqmJ+z6AuRm
  2ARw+9GCHH7f3a1YTd4FYjmIgAmnALKYuQaDPjx9PXtO4hogqvZW3IA6VuVIGUCI
  l97P3Q+fPLQ1/IfjrIOvKiLYnQcf/OOfZOLKTRANywnndPKnZGJ6AwkE1K7h9J2Y
  RQ9YMtaRDq+WLyh+nqVOfwavhDG4igWb7h/Gh1WiNNoKTJcEkLVtjWod3y8BJxp6
  ij9fP8KCjlHJ+ylfFz2qWdUeBTIseajpXXHAmlKUPSdPzX25bCAVtuyHdQxGmTh4
  i465HKJik+ZOl6aY3GN/K98mlxnHRQIDAQABoxowGDAJBgNVHRMEAjAAMAsGA1Ud
  DwQEAwIF4DANBgkqhkiG9w0BAQsFAAOCAQEAocORezEaijfX/uDZINJ/kswgO71z
  Cbmtdr7VxU+l3FwPe2iPDIm29G7/CmNwmATgoco6KGPNHUpG7wT+cLgAOkGWNWAP
  nIWRUuVxL9JHs7wMXMmSJn7JMbLJW8dQGVLxjScnglNPF2f6DQCCmxZQwBbDwuJS
  +nvI8/cxJN+Gi2i9fty7zC5gX12EhdvRodU8VCqqmoOZ/bMxbQvK2uw8NFpt/HrR
  Rt3qg6W0KKFW+/rJi8Fta5X4UVdrV0VfH6y1oPksrIQzziw/hb8hKHmMDWvDUpDk
  XmSHFXmRh/RQI61OxG8ye5HMpjb/ATaSHbL3ZCXuOJHvrFyRbGVeS9Nl4A==
  -----END CERTIFICATE-----
CERT

    settings.idp_cert_multi = {
      signing: [signing1]
    }
    settings
  end
end
