variable "backend_address_pool" {
  type = set(object({
    fqdns        = optional(set(string))
    ip_addresses = optional(set(string))
    name         = string
  }))
  description = <<-EOT
 - `fqdns` - (Optional) A list of FQDN's which should be part of the Backend Address Pool.
 - `ip_addresses` - (Optional) A list of IP Addresses which should be part of the Backend Address Pool.
 - `name` - (Required) The name of the Backend Address Pool.
EOT
  nullable    = false
}

variable "backend_http_settings" {
  type = set(object({
    affinity_cookie_name                = optional(string)
    cookie_based_affinity               = string
    host_name                           = optional(string)
    name                                = string
    path                                = optional(string)
    pick_host_name_from_backend_address = optional(bool)
    port                                = number
    probe_name                          = optional(string)
    protocol                            = string
    request_timeout                     = optional(number)
    trusted_root_certificate_names      = optional(list(string))
    authentication_certificate = optional(list(object({
      name = string
    })))
    connection_draining = optional(object({
      drain_timeout_sec = number
      enabled           = bool
    }))
  }))
  description = <<-EOT
 - `affinity_cookie_name` - (Optional) The name of the affinity cookie.
 - `cookie_based_affinity` - (Required) Is Cookie-Based Affinity enabled? Possible values are `Enabled` and `Disabled`.
 - `host_name` - (Optional) Host header to be sent to the backend servers. Cannot be set if `pick_host_name_from_backend_address` is set to `true`.
 - `name` - (Required) The name of the Backend HTTP Settings Collection.
 - `path` - (Optional) The Path which should be used as a prefix for all HTTP requests.
 - `pick_host_name_from_backend_address` - (Optional) Whether host header should be picked from the host name of the backend server. Defaults to `false`.
 - `port` - (Required) The port which should be used for this Backend HTTP Settings Collection.
 - `probe_name` - (Optional) The name of an associated HTTP Probe.
 - `protocol` - (Required) The Protocol which should be used. Possible values are `Http` and `Https`.
 - `request_timeout` - (Optional) The request timeout in seconds, which must be between 1 and 86400 seconds. Defaults to `30`.
 - `trusted_root_certificate_names` - (Optional) A list of `trusted_root_certificate` names.

 ---
 `authentication_certificate` block supports the following:
 - `name` - (Required) The Name of the Authentication Certificate to use.

 ---
 `connection_draining` block supports the following:
 - `drain_timeout_sec` - (Required) The number of seconds connection draining is active. Acceptable values are from `1` second to `3600` seconds.
 - `enabled` - (Required) If connection draining is enabled or not.
EOT
  nullable    = false
}

variable "frontend_ip_configuration" {
  type = list(object({
    name                            = string
    private_ip_address              = optional(string)
    private_ip_address_allocation   = optional(string)
    private_link_configuration_name = optional(string)
    public_ip_address_id            = optional(string)
    subnet_id                       = optional(string)
  }))
  description = <<-EOT
 - `name` - (Required) The name of the Frontend IP Configuration.
 - `private_ip_address` - (Optional) The Private IP Address to use for the Application Gateway.
 - `private_ip_address_allocation` - (Optional) The Allocation Method for the Private IP Address. Possible values are `Dynamic` and `Static`. Defaults to `Dynamic`.
 - `private_link_configuration_name` - (Optional) The name of the private link configuration to use for this frontend IP configuration.
 - `public_ip_address_id` - (Optional) The ID of a Public IP Address which the Application Gateway should use. The allocation method for the Public IP Address depends on the `sku` of this Application Gateway. Please refer to the [Azure documentation for public IP addresses](https://docs.microsoft.com/azure/virtual-network/public-ip-addresses#application-gateways) for details.
 - `subnet_id` - (Optional) The ID of the Subnet.
EOT
  nullable    = false
}

variable "frontend_port" {
  type = set(object({
    name = string
    port = number
  }))
  description = <<-EOT
 - `name` - (Required) The name of the Frontend Port.
 - `port` - (Required) The port used for this Frontend Port.
EOT
  nullable    = false
}

variable "gateway_ip_configuration" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
  description = <<-EOT
 - `name` - (Required) The Name of this Gateway IP Configuration.
 - `subnet_id` - (Required) The ID of the Subnet which the Application Gateway should be connected to.
EOT
  nullable    = false
}

variable "http_listener" {
  type = set(object({
    firewall_policy_id             = optional(string)
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    host_name                      = optional(string)
    host_names                     = optional(set(string))
    name                           = string
    protocol                       = string
    require_sni                    = optional(bool)
    ssl_certificate_name           = optional(string)
    ssl_profile_name               = optional(string)
    custom_error_configuration = optional(list(object({
      custom_error_page_url = string
      status_code           = string
    })))
  }))
  description = <<-EOT
 - `firewall_policy_id` - (Optional) The ID of the Web Application Firewall Policy which should be used for this HTTP Listener.
 - `frontend_ip_configuration_name` - (Required) The Name of the Frontend IP Configuration used for this HTTP Listener.
 - `frontend_port_name` - (Required) The Name of the Frontend Port use for this HTTP Listener.
 - `host_name` - (Optional) The Hostname which should be used for this HTTP Listener. Setting this value changes Listener Type to 'Multi site'.
 - `host_names` - (Optional) A list of Hostname(s) should be used for this HTTP Listener. It allows special wildcard characters.
 - `name` - (Required) The Name of the HTTP Listener.
 - `protocol` - (Required) The Protocol to use for this HTTP Listener. Possible values are `Http` and `Https`.
 - `require_sni` - (Optional) Should Server Name Indication be Required? Defaults to `false`.
 - `ssl_certificate_name` - (Optional) The name of the associated SSL Certificate which should be used for this HTTP Listener.
 - `ssl_profile_name` - (Optional) The name of the associated SSL Profile which should be used for this HTTP Listener.

 ---
 `custom_error_configuration` block supports the following:
 - `custom_error_page_url` - (Required) Error page URL of the application gateway customer error.
 - `status_code` - (Required) Status code of the application gateway customer error. Possible values are `HttpStatus403` and `HttpStatus502`
EOT
  nullable    = false
}

variable "request_routing_rule" {
  type = set(object({
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    http_listener_name          = string
    name                        = string
    priority                    = optional(number)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    rule_type                   = string
    url_path_map_name           = optional(string)
  }))
  description = <<-EOT
 - `backend_address_pool_name` - (Optional) The Name of the Backend Address Pool which should be used for this Routing Rule. Cannot be set if `redirect_configuration_name` is set.
 - `backend_http_settings_name` - (Optional) The Name of the Backend HTTP Settings Collection which should be used for this Routing Rule. Cannot be set if `redirect_configuration_name` is set.
 - `http_listener_name` - (Required) The Name of the HTTP Listener which should be used for this Routing Rule.
 - `name` - (Required) The Name of this Request Routing Rule.
 - `priority` - (Optional) Rule evaluation order can be dictated by specifying an integer value from `1` to `20000` with `1` being the highest priority and `20000` being the lowest priority.
 - `redirect_configuration_name` - (Optional) The Name of the Redirect Configuration which should be used for this Routing Rule. Cannot be set if either `backend_address_pool_name` or `backend_http_settings_name` is set.
 - `rewrite_rule_set_name` - (Optional) The Name of the Rewrite Rule Set which should be used for this Routing Rule. Only valid for v2 SKUs.
 - `rule_type` - (Required) The Type of Routing that should be used for this Rule. Possible values are `Basic` and `PathBasedRouting`.
 - `url_path_map_name` - (Optional) The Name of the URL Path Map which should be associated with this Routing Rule.
EOT
  nullable    = false
}

variable "sku" {
  type = object({
    capacity = optional(number)
    name     = string
    tier     = string
  })
  description = <<-EOT
 - `capacity` - (Optional) The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between `1` and `32`, and `1` to `125` for a V2 SKU. This property is optional if `autoscale_configuration` is set.
 - `name` - (Required) The Name of the SKU to use for this Application Gateway. Possible values are `Standard_Small`, `Standard_Medium`, `Standard_Large`, `Standard_v2`, `WAF_Medium`, `WAF_Large`, and `WAF_v2`.
 - `tier` - (Required) The Tier of the SKU to use for this Application Gateway. Possible values are `Standard`, `Standard_v2`, `WAF` and `WAF_v2`.
EOT
  nullable    = false
}

variable "authentication_certificate" {
  type = list(object({
    data = string
    name = string
  }))
  default     = null
  description = <<-EOT
 - `data` - (Required) The contents of the Authentication Certificate which should be used.
 - `name` - (Required) The Name of the Authentication Certificate to use.
EOT
}

variable "autoscale_configuration" {
  type = object({
    max_capacity = optional(number)
    min_capacity = number
  })
  default     = null
  description = <<-EOT
 - `max_capacity` - (Optional) Maximum capacity for autoscaling. Accepted values are in the range `2` to `125`.
 - `min_capacity` - (Required) Minimum capacity for autoscaling. Accepted values are in the range `0` to `100`.
EOT
}

variable "custom_error_configuration" {
  type = list(object({
    custom_error_page_url = string
    status_code           = string
  }))
  default     = null
  description = <<-EOT
 - `custom_error_page_url` - (Required) Error page URL of the application gateway customer error.
 - `status_code` - (Required) Status code of the application gateway customer error. Possible values are `HttpStatus403` and `HttpStatus502`
EOT
}

variable "enable_http2" {
  type        = bool
  default     = null
  description = "(Optional) Is HTTP2 enabled on the application gateway resource? Defaults to `false`."
}

variable "fips_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Is FIPS enabled on the Application Gateway?"
}

variable "firewall_policy_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the Web Application Firewall Policy."
}

variable "force_firewall_policy_association" {
  type        = bool
  default     = null
  description = "(Optional) Is the Firewall Policy associated with the Application Gateway?"
}

variable "global" {
  type = object({
    request_buffering_enabled  = bool
    response_buffering_enabled = bool
  })
  default     = null
  description = <<-EOT
 - `request_buffering_enabled` - (Required) Whether Application Gateway's Request buffer is enabled.
 - `response_buffering_enabled` - (Required) Whether Application Gateway's Response buffer is enabled.
EOT
}

variable "private_link_configuration" {
  type = set(object({
    name = string
    ip_configuration = list(object({
      name                          = string
      primary                       = bool
      private_ip_address            = optional(string)
      private_ip_address_allocation = string
      subnet_id                     = string
    }))
  }))
  default     = null
  description = <<-EOT
 - `name` - (Required) The name of the private link configuration.

 ---
 `ip_configuration` block supports the following:
 - `name` - (Required) The name of the IP configuration.
 - `primary` - (Required) Is this the Primary IP Configuration?
 - `private_ip_address` - (Optional) The Static IP Address which should be used.
 - `private_ip_address_allocation` - (Required) The allocation method used for the Private IP Address. Possible values are `Dynamic` and `Static`.
 - `subnet_id` - (Required) The ID of the subnet the private link configuration should connect to.
EOT
}

variable "probe" {
  type = set(object({
    host                                      = optional(string)
    interval                                  = number
    minimum_servers                           = optional(number)
    name                                      = string
    path                                      = string
    pick_host_name_from_backend_http_settings = optional(bool)
    port                                      = optional(number)
    protocol                                  = string
    timeout                                   = number
    unhealthy_threshold                       = number
    match = optional(object({
      body        = optional(string)
      status_code = list(string)
    }))
  }))
  default     = null
  description = <<-EOT
 - `host` - (Optional) The Hostname used for this Probe. If the Application Gateway is configured for a single site, by default the Host name should be specified as `127.0.0.1`, unless otherwise configured in custom probe. Cannot be set if `pick_host_name_from_backend_http_settings` is set to `true`.
 - `interval` - (Required) The Interval between two consecutive probes in seconds. Possible values range from 1 second to a maximum of 86,400 seconds.
 - `minimum_servers` - (Optional) The minimum number of servers that are always marked as healthy. Defaults to `0`.
 - `name` - (Required) The Name of the Probe.
 - `path` - (Required) The Path used for this Probe.
 - `pick_host_name_from_backend_http_settings` - (Optional) Whether the host header should be picked from the backend HTTP settings. Defaults to `false`.
 - `port` - (Optional) Custom port which will be used for probing the backend servers. The valid value ranges from 1 to 65535. In case not set, port from HTTP settings will be used. This property is valid for Standard_v2 and WAF_v2 only.
 - `protocol` - (Required) The Protocol used for this Probe. Possible values are `Http` and `Https`.
 - `timeout` - (Required) The Timeout used for this Probe, which indicates when a probe becomes unhealthy. Possible values range from 1 second to a maximum of 86,400 seconds.
 - `unhealthy_threshold` - (Required) The Unhealthy Threshold for this Probe, which indicates the amount of retries which should be attempted before a node is deemed unhealthy. Possible values are from 1 to 20.

 ---
 `match` block supports the following:
 - `body` - (Optional) A snippet from the Response Body which must be present in the Response.
 - `status_code` - (Required) A list of allowed status codes for this Health Probe.
EOT
}

variable "redirect_configuration" {
  type = set(object({
    include_path         = optional(bool)
    include_query_string = optional(bool)
    name                 = string
    redirect_type        = string
    target_listener_name = optional(string)
    target_url           = optional(string)
  }))
  default     = null
  description = <<-EOT
 - `include_path` - (Optional) Whether to include the path in the redirected URL. Defaults to `false`
 - `include_query_string` - (Optional) Whether to include the query string in the redirected URL. Default to `false`
 - `name` - (Required) Unique name of the redirect configuration block
 - `redirect_type` - (Required) The type of redirect. Possible values are `Permanent`, `Temporary`, `Found` and `SeeOther`
 - `target_listener_name` - (Optional) The name of the listener to redirect to. Cannot be set if `target_url` is set.
 - `target_url` - (Optional) The URL to redirect the request to. Cannot be set if `target_listener_name` is set.
EOT
}

variable "rewrite_rule_set" {
  type = list(object({
    name = string
    rewrite_rule = optional(list(object({
      name          = string
      rule_sequence = number
      condition = optional(list(object({
        ignore_case = optional(bool)
        negate      = optional(bool)
        pattern     = string
        variable    = string
      })))
      request_header_configuration = optional(list(object({
        header_name  = string
        header_value = string
      })))
      response_header_configuration = optional(list(object({
        header_name  = string
        header_value = string
      })))
      url = optional(object({
        components   = optional(string)
        path         = optional(string)
        query_string = optional(string)
        reroute      = optional(bool)
      }))
    })))
  }))
  default     = null
  description = <<-EOT
 - `name` - (Required) Unique name of the rewrite rule set block

 ---
 `rewrite_rule` block supports the following:
 - `name` - (Required) Unique name of the rewrite rule block
 - `rule_sequence` - (Required) Rule sequence of the rewrite rule that determines the order of execution in a set.

 ---
 `condition` block supports the following:
 - `ignore_case` - (Optional) Perform a case in-sensitive comparison. Defaults to `false`
 - `negate` - (Optional) Negate the result of the condition evaluation. Defaults to `false`
 - `pattern` - (Required) The pattern, either fixed string or regular expression, that evaluates the truthfulness of the condition.
 - `variable` - (Required) The [variable](https://docs.microsoft.com/azure/application-gateway/rewrite-http-headers#server-variables) of the condition.

 ---
 `request_header_configuration` block supports the following:
 - `header_name` - (Required) Header name of the header configuration.
 - `header_value` - (Required) Header value of the header configuration. To delete a request header set this property to an empty string.

 ---
 `response_header_configuration` block supports the following:
 - `header_name` - (Required) Header name of the header configuration.
 - `header_value` - (Required) Header value of the header configuration. To delete a response header set this property to an empty string.

 ---
 `url` block supports the following:
 - `components` - (Optional) The components used to rewrite the URL. Possible values are `path_only` and `query_string_only` to limit the rewrite to the URL Path or URL Query String only.
 - `path` - (Optional) The URL path to rewrite.
 - `query_string` - (Optional) The query string to rewrite.
 - `reroute` - (Optional) Whether the URL path map should be reevaluated after this rewrite has been applied. [More info on rewrite configuration](https://docs.microsoft.com/azure/application-gateway/rewrite-http-headers-url#rewrite-configuration)
EOT
}

variable "ssl_certificate" {
  type = set(object({
    data                = optional(string)
    key_vault_secret_id = optional(string)
    name                = string
    password            = optional(string)
  }))
  default     = null
  description = <<-EOT
 - `data` - (Optional) The base64-encoded PFX certificate data. Required if `key_vault_secret_id` is not set.
 - `key_vault_secret_id` - (Optional) The Secret ID of (base-64 encoded unencrypted pfx) the `Secret` or `Certificate` object stored in Azure KeyVault. You need to enable soft delete for Key Vault to use this feature. Required if `data` is not set.
 - `name` - (Required) The Name of the SSL certificate that is unique within this Application Gateway
 - `password` - (Optional) Password for the pfx file specified in data. Required if `data` is set.
EOT
}

variable "ssl_policy" {
  type = object({
    cipher_suites        = optional(list(string))
    disabled_protocols   = optional(list(string))
    min_protocol_version = optional(string)
    policy_name          = optional(string)
    policy_type          = optional(string)
  })
  default     = null
  description = <<-EOT
 - `cipher_suites` - (Optional) A List of accepted cipher suites. Possible values are: `TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_128_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_128_CBC_SHA256`, `TLS_DHE_DSS_WITH_AES_256_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_256_CBC_SHA256`, `TLS_DHE_RSA_WITH_AES_128_CBC_SHA`, `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256`, `TLS_DHE_RSA_WITH_AES_256_CBC_SHA`, `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384`, `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA`, `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256`, `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`, `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA`, `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384`, `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`, `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA`, `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256`, `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`, `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA`, `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384`, `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`, `TLS_RSA_WITH_3DES_EDE_CBC_SHA`, `TLS_RSA_WITH_AES_128_CBC_SHA`, `TLS_RSA_WITH_AES_128_CBC_SHA256`, `TLS_RSA_WITH_AES_128_GCM_SHA256`, `TLS_RSA_WITH_AES_256_CBC_SHA`, `TLS_RSA_WITH_AES_256_CBC_SHA256` and `TLS_RSA_WITH_AES_256_GCM_SHA384`.
 - `disabled_protocols` - (Optional) A list of SSL Protocols which should be disabled on this Application Gateway. Possible values are `TLSv1_0`, `TLSv1_1`, `TLSv1_2` and `TLSv1_3`.
 - `min_protocol_version` - (Optional) The minimal TLS version. Possible values are `TLSv1_0`, `TLSv1_1`, `TLSv1_2` and `TLSv1_3`.
 - `policy_name` - (Optional) The Name of the Policy e.g. AppGwSslPolicy20170401S. Required if `policy_type` is set to `Predefined`. Possible values can change over time and are published here <https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview>. Not compatible with `disabled_protocols`.
 - `policy_type` - (Optional) The Type of the Policy. Possible values are `Predefined`, `Custom` and `CustomV2`.
EOT
}

variable "ssl_profile" {
  type = list(object({
    name                                 = string
    trusted_client_certificate_names     = optional(list(string))
    verify_client_cert_issuer_dn         = optional(bool)
    verify_client_certificate_revocation = optional(string)
    ssl_policy = optional(object({
      cipher_suites        = optional(list(string))
      disabled_protocols   = optional(list(string))
      min_protocol_version = optional(string)
      policy_name          = optional(string)
      policy_type          = optional(string)
    }))
  }))
  default     = null
  description = <<-EOT
 - `name` - (Required) The name of the SSL Profile that is unique within this Application Gateway.
 - `trusted_client_certificate_names` - (Optional) The name of the Trusted Client Certificate that will be used to authenticate requests from clients.
 - `verify_client_cert_issuer_dn` - (Optional) Should client certificate issuer DN be verified? Defaults to `false`.
 - `verify_client_certificate_revocation` - (Optional) Specify the method to check client certificate revocation status. Possible value is `OCSP`.

 ---
 `ssl_policy` block supports the following:
 - `cipher_suites` - (Optional) A List of accepted cipher suites. Possible values are: `TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_128_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_128_CBC_SHA256`, `TLS_DHE_DSS_WITH_AES_256_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_256_CBC_SHA256`, `TLS_DHE_RSA_WITH_AES_128_CBC_SHA`, `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256`, `TLS_DHE_RSA_WITH_AES_256_CBC_SHA`, `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384`, `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA`, `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256`, `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`, `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA`, `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384`, `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`, `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA`, `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256`, `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`, `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA`, `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384`, `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`, `TLS_RSA_WITH_3DES_EDE_CBC_SHA`, `TLS_RSA_WITH_AES_128_CBC_SHA`, `TLS_RSA_WITH_AES_128_CBC_SHA256`, `TLS_RSA_WITH_AES_128_GCM_SHA256`, `TLS_RSA_WITH_AES_256_CBC_SHA`, `TLS_RSA_WITH_AES_256_CBC_SHA256` and `TLS_RSA_WITH_AES_256_GCM_SHA384`.
 - `disabled_protocols` - (Optional) A list of SSL Protocols which should be disabled on this Application Gateway. Possible values are `TLSv1_0`, `TLSv1_1`, `TLSv1_2` and `TLSv1_3`.
 - `min_protocol_version` - (Optional) The minimal TLS version. Possible values are `TLSv1_0`, `TLSv1_1`, `TLSv1_2` and `TLSv1_3`.
 - `policy_name` - (Optional) The Name of the Policy e.g. AppGwSslPolicy20170401S. Required if `policy_type` is set to `Predefined`. Possible values can change over time and are published here <https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview>. Not compatible with `disabled_protocols`.
 - `policy_type` - (Optional) The Type of the Policy. Possible values are `Predefined`, `Custom` and `CustomV2`.
EOT
}

variable "timeouts" {
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default     = null
  description = <<-EOT
 - `create` - (Defaults to 90 minutes) Used when creating the Application Gateway.
 - `delete` - (Defaults to 90 minutes) Used when deleting the Application Gateway.
 - `read` - (Defaults to 5 minutes) Used when retrieving the Application Gateway.
 - `update` - (Defaults to 90 minutes) Used when updating the Application Gateway.
EOT
}

variable "trusted_client_certificate" {
  type = list(object({
    data = string
    name = string
  }))
  default     = null
  description = <<-EOT
 - `data` - (Required) The base-64 encoded certificate.
 - `name` - (Required) The name of the Trusted Client Certificate that is unique within this Application Gateway.
EOT
}

variable "trusted_root_certificate" {
  type = list(object({
    data                = optional(string)
    key_vault_secret_id = optional(string)
    name                = string
  }))
  default     = null
  description = <<-EOT
 - `data` - (Optional) The contents of the Trusted Root Certificate which should be used. Required if `key_vault_secret_id` is not set.
 - `key_vault_secret_id` - (Optional) The Secret ID of (base-64 encoded unencrypted pfx) `Secret` or `Certificate` object stored in Azure KeyVault. You need to enable soft delete for the Key Vault to use this feature. Required if `data` is not set.
 - `name` - (Required) The Name of the Trusted Root Certificate to use.
EOT
}

variable "url_path_map" {
  type = list(object({
    default_backend_address_pool_name   = optional(string)
    default_backend_http_settings_name  = optional(string)
    default_redirect_configuration_name = optional(string)
    default_rewrite_rule_set_name       = optional(string)
    name                                = string
    path_rule = list(object({
      backend_address_pool_name   = optional(string)
      backend_http_settings_name  = optional(string)
      firewall_policy_id          = optional(string)
      name                        = string
      paths                       = list(string)
      redirect_configuration_name = optional(string)
      rewrite_rule_set_name       = optional(string)
    }))
  }))
  default     = null
  description = <<-EOT
 - `default_backend_address_pool_name` - (Optional) The Name of the Default Backend Address Pool which should be used for this URL Path Map. Cannot be set if `default_redirect_configuration_name` is set.
 - `default_backend_http_settings_name` - (Optional) The Name of the Default Backend HTTP Settings Collection which should be used for this URL Path Map. Cannot be set if `default_redirect_configuration_name` is set.
 - `default_redirect_configuration_name` - (Optional) The Name of the Default Redirect Configuration which should be used for this URL Path Map. Cannot be set if either `default_backend_address_pool_name` or `default_backend_http_settings_name` is set.
 - `default_rewrite_rule_set_name` - (Optional) The Name of the Default Rewrite Rule Set which should be used for this URL Path Map. Only valid for v2 SKUs.
 - `name` - (Required) The Name of the URL Path Map.

 ---
 `path_rule` block supports the following:
 - `backend_address_pool_name` - (Optional) The Name of the Backend Address Pool to use for this Path Rule. Cannot be set if `redirect_configuration_name` is set.
 - `backend_http_settings_name` - (Optional) The Name of the Backend HTTP Settings Collection to use for this Path Rule. Cannot be set if `redirect_configuration_name` is set.
 - `firewall_policy_id` - (Optional) The ID of the Web Application Firewall Policy which should be used as an HTTP Listener.
 - `name` - (Required) The Name of the Path Rule.
 - `paths` - (Required) A list of Paths used in this Path Rule.
 - `redirect_configuration_name` - (Optional) The Name of a Redirect Configuration to use for this Path Rule. Cannot be set if `backend_address_pool_name` or `backend_http_settings_name` is set.
 - `rewrite_rule_set_name` - (Optional) The Name of the Rewrite Rule Set which should be used for this URL Path Map. Only valid for v2 SKUs.
EOT
}

variable "waf_configuration" {
  type = object({
    enabled                  = bool
    file_upload_limit_mb     = optional(number)
    firewall_mode            = string
    max_request_body_size_kb = optional(number)
    request_body_check       = optional(bool)
    rule_set_type            = optional(string)
    rule_set_version         = string
    disabled_rule_group = optional(list(object({
      rule_group_name = string
      rules           = optional(list(number))
    })))
    exclusion = optional(list(object({
      match_variable          = string
      selector                = optional(string)
      selector_match_operator = optional(string)
    })))
  })
  default     = null
  description = <<-EOT
 - `enabled` - (Required) Is the Web Application Firewall enabled?
 - `file_upload_limit_mb` - (Optional) The File Upload Limit in MB. Accepted values are in the range `1`MB to `750`MB for the `WAF_v2` SKU, and `1`MB to `500`MB for all other SKUs. Defaults to `100`MB.
 - `firewall_mode` - (Required) The Web Application Firewall Mode. Possible values are `Detection` and `Prevention`.
 - `max_request_body_size_kb` - (Optional) The Maximum Request Body Size in KB. Accepted values are in the range `1`KB to `128`KB. Defaults to `128`KB.
 - `request_body_check` - (Optional) Is Request Body Inspection enabled? Defaults to `true`.
 - `rule_set_type` - (Optional) The Type of the Rule Set used for this Web Application Firewall. Possible values are `OWASP`, `Microsoft_BotManagerRuleSet` and `Microsoft_DefaultRuleSet`. Defaults to `OWASP`.
 - `rule_set_version` - (Required) The Version of the Rule Set used for this Web Application Firewall. Possible values are `0.1`, `1.0`, `2.1`, `2.2.9`, `3.0`, `3.1` and `3.2`.

 ---
 `disabled_rule_group` block supports the following:
 - `rule_group_name` - (Required) The rule group where specific rules should be disabled. Possible values are `BadBots`, `crs_20_protocol_violations`, `crs_21_protocol_anomalies`, `crs_23_request_limits`, `crs_30_http_policy`, `crs_35_bad_robots`, `crs_40_generic_attacks`, `crs_41_sql_injection_attacks`, `crs_41_xss_attacks`, `crs_42_tight_security`, `crs_45_trojans`, `crs_49_inbound_blocking`, `General`, `GoodBots`, `KnownBadBots`, `Known-CVEs`, `REQUEST-911-METHOD-ENFORCEMENT`, `REQUEST-913-SCANNER-DETECTION`, `REQUEST-920-PROTOCOL-ENFORCEMENT`, `REQUEST-921-PROTOCOL-ATTACK`, `REQUEST-930-APPLICATION-ATTACK-LFI`, `REQUEST-931-APPLICATION-ATTACK-RFI`, `REQUEST-932-APPLICATION-ATTACK-RCE`, `REQUEST-933-APPLICATION-ATTACK-PHP`, `REQUEST-941-APPLICATION-ATTACK-XSS`, `REQUEST-942-APPLICATION-ATTACK-SQLI`, `REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION`, `REQUEST-944-APPLICATION-ATTACK-JAVA`, `UnknownBots`, `METHOD-ENFORCEMENT`, `PROTOCOL-ENFORCEMENT`, `PROTOCOL-ATTACK`, `LFI`, `RFI`, `RCE`, `PHP`, `NODEJS`, `XSS`, `SQLI`, `FIX`, `JAVA`, `MS-ThreatIntel-WebShells`, `MS-ThreatIntel-AppSec`, `MS-ThreatIntel-SQLI` and `MS-ThreatIntel-CVEs`.
 - `rules` - (Optional) A list of rules which should be disabled in that group. Disables all rules in the specified group if `rules` is not specified.

 ---
 `exclusion` block supports the following:
 - `match_variable` - (Required) Match variable of the exclusion rule to exclude header, cookie or GET arguments. Possible values are `RequestArgKeys`, `RequestArgNames`, `RequestArgValues`, `RequestCookieKeys`, `RequestCookieNames`, `RequestCookieValues`, `RequestHeaderKeys`, `RequestHeaderNames` and `RequestHeaderValues`
 - `selector` - (Optional) String value which will be used for the filter operation. If empty will exclude all traffic on this `match_variable`
 - `selector_match_operator` - (Optional) Operator which will be used to search in the variable content. Possible values are `Contains`, `EndsWith`, `Equals`, `EqualsAny` and `StartsWith`. If empty will exclude all traffic on this `match_variable`
EOT
}

variable "zones" {
  type        = set(string)
  default     = null
  description = "(Optional) Specifies a list of Availability Zones in which this Application Gateway should be located. Changing this forces a new Application Gateway to be created."
}
