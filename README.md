<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-template

This is an example of an Azure Application Gateway in the style of Azure Verified Modules.  For official modules please visit <https://aka.ms/AVM>.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.71)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_backend_address_pool"></a> [backend\_address\_pool](#input\_backend\_address\_pool)

Description: - `fqdns` - (Optional) A list of FQDN's which should be part of the Backend Address Pool.
- `ip_addresses` - (Optional) A list of IP Addresses which should be part of the Backend Address Pool.
- `name` - (Required) The name of the Backend Address Pool.

Type:

```hcl
set(object({
    fqdns        = optional(set(string))
    ip_addresses = optional(set(string))
    name         = string
  }))
```

### <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings)

Description: - `affinity_cookie_name` - (Optional) The name of the affinity cookie.
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

Type:

```hcl
set(object({
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
```

### <a name="input_frontend_ip_configuration"></a> [frontend\_ip\_configuration](#input\_frontend\_ip\_configuration)

Description: - `name` - (Required) The name of the Frontend IP Configuration.
- `private_ip_address` - (Optional) The Private IP Address to use for the Application Gateway.
- `private_ip_address_allocation` - (Optional) The Allocation Method for the Private IP Address. Possible values are `Dynamic` and `Static`. Defaults to `Dynamic`.
- `private_link_configuration_name` - (Optional) The name of the private link configuration to use for this frontend IP configuration.
- `public_ip_address_id` - (Optional) The ID of a Public IP Address which the Application Gateway should use. The allocation method for the Public IP Address depends on the `sku` of this Application Gateway. Please refer to the [Azure documentation for public IP addresses](https://docs.microsoft.com/azure/virtual-network/public-ip-addresses#application-gateways) for details.
- `subnet_id` - (Optional) The ID of the Subnet.

Type:

```hcl
list(object({
    name                            = string
    private_ip_address              = optional(string)
    private_ip_address_allocation   = optional(string)
    private_link_configuration_name = optional(string)
    public_ip_address_id            = optional(string)
    subnet_id                       = optional(string)
  }))
```

### <a name="input_frontend_port"></a> [frontend\_port](#input\_frontend\_port)

Description: - `name` - (Required) The name of the Frontend Port.
- `port` - (Required) The port used for this Frontend Port.

Type:

```hcl
set(object({
    name = string
    port = number
  }))
```

### <a name="input_gateway_ip_configuration"></a> [gateway\_ip\_configuration](#input\_gateway\_ip\_configuration)

Description: - `name` - (Required) The Name of this Gateway IP Configuration.
- `subnet_id` - (Required) The ID of the Subnet which the Application Gateway should be connected to.

Type:

```hcl
list(object({
    name      = string
    subnet_id = string
  }))
```

### <a name="input_http_listener"></a> [http\_listener](#input\_http\_listener)

Description: - `firewall_policy_id` - (Optional) The ID of the Web Application Firewall Policy which should be used for this HTTP Listener.
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

Type:

```hcl
set(object({
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
```

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this resource.

Type: `string`

### <a name="input_request_routing_rule"></a> [request\_routing\_rule](#input\_request\_routing\_rule)

Description: - `backend_address_pool_name` - (Optional) The Name of the Backend Address Pool which should be used for this Routing Rule. Cannot be set if `redirect_configuration_name` is set.
- `backend_http_settings_name` - (Optional) The Name of the Backend HTTP Settings Collection which should be used for this Routing Rule. Cannot be set if `redirect_configuration_name` is set.
- `http_listener_name` - (Required) The Name of the HTTP Listener which should be used for this Routing Rule.
- `name` - (Required) The Name of this Request Routing Rule.
- `priority` - (Optional) Rule evaluation order can be dictated by specifying an integer value from `1` to `20000` with `1` being the highest priority and `20000` being the lowest priority.
- `redirect_configuration_name` - (Optional) The Name of the Redirect Configuration which should be used for this Routing Rule. Cannot be set if either `backend_address_pool_name` or `backend_http_settings_name` is set.
- `rewrite_rule_set_name` - (Optional) The Name of the Rewrite Rule Set which should be used for this Routing Rule. Only valid for v2 SKUs.
- `rule_type` - (Required) The Type of Routing that should be used for this Rule. Possible values are `Basic` and `PathBasedRouting`.
- `url_path_map_name` - (Optional) The Name of the URL Path Map which should be associated with this Routing Rule.

Type:

```hcl
set(object({
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
```

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_sku"></a> [sku](#input\_sku)

Description: - `capacity` - (Optional) The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between `1` and `32`, and `1` to `125` for a V2 SKU. This property is optional if `autoscale_configuration` is set.
- `name` - (Required) The Name of the SKU to use for this Application Gateway. Possible values are `Standard_Small`, `Standard_Medium`, `Standard_Large`, `Standard_v2`, `WAF_Medium`, `WAF_Large`, and `WAF_v2`.
- `tier` - (Required) The Tier of the SKU to use for this Application Gateway. Possible values are `Standard`, `Standard_v2`, `WAF` and `WAF_v2`.

Type:

```hcl
object({
    capacity = optional(number)
    name     = string
    tier     = string
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_authentication_certificate"></a> [authentication\_certificate](#input\_authentication\_certificate)

Description: - `data` - (Required) The contents of the Authentication Certificate which should be used.
- `name` - (Required) The Name of the Authentication Certificate to use.

Type:

```hcl
list(object({
    data = string
    name = string
  }))
```

Default: `null`

### <a name="input_autoscale_configuration"></a> [autoscale\_configuration](#input\_autoscale\_configuration)

Description: - `max_capacity` - (Optional) Maximum capacity for autoscaling. Accepted values are in the range `2` to `125`.
- `min_capacity` - (Required) Minimum capacity for autoscaling. Accepted values are in the range `0` to `100`.

Type:

```hcl
object({
    max_capacity = optional(number)
    min_capacity = number
  })
```

Default: `null`

### <a name="input_custom_error_configuration"></a> [custom\_error\_configuration](#input\_custom\_error\_configuration)

Description: - `custom_error_page_url` - (Required) Error page URL of the application gateway customer error.
- `status_code` - (Required) Status code of the application gateway customer error. Possible values are `HttpStatus403` and `HttpStatus502`

Type:

```hcl
list(object({
    custom_error_page_url = string
    status_code           = string
  }))
```

Default: `null`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.

Type:

```hcl
object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
```

Default: `null`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2)

Description: (Optional) Is HTTP2 enabled on the application gateway resource? Defaults to `false`.

Type: `bool`

Default: `null`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_fips_enabled"></a> [fips\_enabled](#input\_fips\_enabled)

Description: (Optional) Is FIPS enabled on the Application Gateway?

Type: `bool`

Default: `null`

### <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id)

Description: (Optional) The ID of the Web Application Firewall Policy.

Type: `string`

Default: `null`

### <a name="input_force_firewall_policy_association"></a> [force\_firewall\_policy\_association](#input\_force\_firewall\_policy\_association)

Description: (Optional) Is the Firewall Policy associated with the Application Gateway?

Type: `bool`

Default: `null`

### <a name="input_global"></a> [global](#input\_global)

Description: - `request_buffering_enabled` - (Required) Whether Application Gateway's Request buffer is enabled.
- `response_buffering_enabled` - (Required) Whether Application Gateway's Response buffer is enabled.

Type:

```hcl
object({
    request_buffering_enabled  = bool
    response_buffering_enabled = bool
  })
```

Default: `null`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description: Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.

Type:

```hcl
object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `{}`

### <a name="input_private_link_configuration"></a> [private\_link\_configuration](#input\_private\_link\_configuration)

Description: - `name` - (Required) The name of the private link configuration.

---
`ip_configuration` block supports the following:
- `name` - (Required) The name of the IP configuration.
- `primary` - (Required) Is this the Primary IP Configuration?
- `private_ip_address` - (Optional) The Static IP Address which should be used.
- `private_ip_address_allocation` - (Required) The allocation method used for the Private IP Address. Possible values are `Dynamic` and `Static`.
- `subnet_id` - (Required) The ID of the subnet the private link configuration should connect to.

Type:

```hcl
set(object({
    name = string
    ip_configuration = list(object({
      name                          = string
      primary                       = bool
      private_ip_address            = optional(string)
      private_ip_address_allocation = string
      subnet_id                     = string
    }))
  }))
```

Default: `null`

### <a name="input_probe"></a> [probe](#input\_probe)

Description: - `host` - (Optional) The Hostname used for this Probe. If the Application Gateway is configured for a single site, by default the Host name should be specified as `127.0.0.1`, unless otherwise configured in custom probe. Cannot be set if `pick_host_name_from_backend_http_settings` is set to `true`.
- `interval` - (Required) The Interval between two consecutive probes in seconds. Possible values range from 1 second to a maximum of 86,400 seconds.
- `minimum_servers` - (Optional) The minimum number of servers that are always marked as healthy. Defaults to `0`.
- `name` - (Required) The Name of the Probe.
- `path` - (Required) The Path used for this Probe.
- `pick_host_name_from_backend_http_settings` - (Optional) Whether the host header should be picked from the backend HTTP settings. Defaults to `false`.
- `port` - (Optional) Custom port which will be used for probing the backend servers. The valid value ranges from 1 to 65535. In case not set, port from HTTP settings will be used. This property is valid for Standard\_v2 and WAF\_v2 only.
- `protocol` - (Required) The Protocol used for this Probe. Possible values are `Http` and `Https`.
- `timeout` - (Required) The Timeout used for this Probe, which indicates when a probe becomes unhealthy. Possible values range from 1 second to a maximum of 86,400 seconds.
- `unhealthy_threshold` - (Required) The Unhealthy Threshold for this Probe, which indicates the amount of retries which should be attempted before a node is deemed unhealthy. Possible values are from 1 to 20.

---
`match` block supports the following:
- `body` - (Optional) A snippet from the Response Body which must be present in the Response.
- `status_code` - (Required) A list of allowed status codes for this Health Probe.

Type:

```hcl
set(object({
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
```

Default: `null`

### <a name="input_redirect_configuration"></a> [redirect\_configuration](#input\_redirect\_configuration)

Description: - `include_path` - (Optional) Whether to include the path in the redirected URL. Defaults to `false`
- `include_query_string` - (Optional) Whether to include the query string in the redirected URL. Default to `false`
- `name` - (Required) Unique name of the redirect configuration block
- `redirect_type` - (Required) The type of redirect. Possible values are `Permanent`, `Temporary`, `Found` and `SeeOther`
- `target_listener_name` - (Optional) The name of the listener to redirect to. Cannot be set if `target_url` is set.
- `target_url` - (Optional) The URL to redirect the request to. Cannot be set if `target_listener_name` is set.

Type:

```hcl
set(object({
    include_path         = optional(bool)
    include_query_string = optional(bool)
    name                 = string
    redirect_type        = string
    target_listener_name = optional(string)
    target_url           = optional(string)
  }))
```

Default: `null`

### <a name="input_rewrite_rule_set"></a> [rewrite\_rule\_set](#input\_rewrite\_rule\_set)

Description: - `name` - (Required) Unique name of the rewrite rule set block

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

Type:

```hcl
list(object({
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
```

Default: `null`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_ssl_certificate"></a> [ssl\_certificate](#input\_ssl\_certificate)

Description: - `data` - (Optional) The base64-encoded PFX certificate data. Required if `key_vault_secret_id` is not set.
- `key_vault_secret_id` - (Optional) The Secret ID of (base-64 encoded unencrypted pfx) the `Secret` or `Certificate` object stored in Azure KeyVault. You need to enable soft delete for Key Vault to use this feature. Required if `data` is not set.
- `name` - (Required) The Name of the SSL certificate that is unique within this Application Gateway
- `password` - (Optional) Password for the pfx file specified in data. Required if `data` is set.

Type:

```hcl
set(object({
    data                = optional(string)
    key_vault_secret_id = optional(string)
    name                = string
    password            = optional(string)
  }))
```

Default: `null`

### <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy)

Description: - `cipher_suites` - (Optional) A List of accepted cipher suites. Possible values are: `TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_128_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_128_CBC_SHA256`, `TLS_DHE_DSS_WITH_AES_256_CBC_SHA`, `TLS_DHE_DSS_WITH_AES_256_CBC_SHA256`, `TLS_DHE_RSA_WITH_AES_128_CBC_SHA`, `TLS_DHE_RSA_WITH_AES_128_GCM_SHA256`, `TLS_DHE_RSA_WITH_AES_256_CBC_SHA`, `TLS_DHE_RSA_WITH_AES_256_GCM_SHA384`, `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA`, `TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256`, `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`, `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA`, `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384`, `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`, `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA`, `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256`, `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`, `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA`, `TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384`, `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`, `TLS_RSA_WITH_3DES_EDE_CBC_SHA`, `TLS_RSA_WITH_AES_128_CBC_SHA`, `TLS_RSA_WITH_AES_128_CBC_SHA256`, `TLS_RSA_WITH_AES_128_GCM_SHA256`, `TLS_RSA_WITH_AES_256_CBC_SHA`, `TLS_RSA_WITH_AES_256_CBC_SHA256` and `TLS_RSA_WITH_AES_256_GCM_SHA384`.
- `disabled_protocols` - (Optional) A list of SSL Protocols which should be disabled on this Application Gateway. Possible values are `TLSv1_0`, `TLSv1_1`, `TLSv1_2` and `TLSv1_3`.
- `min_protocol_version` - (Optional) The minimal TLS version. Possible values are `TLSv1_0`, `TLSv1_1`, `TLSv1_2` and `TLSv1_3`.
- `policy_name` - (Optional) The Name of the Policy e.g. AppGwSslPolicy20170401S. Required if `policy_type` is set to `Predefined`. Possible values can change over time and are published here <https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview>. Not compatible with `disabled_protocols`.
- `policy_type` - (Optional) The Type of the Policy. Possible values are `Predefined`, `Custom` and `CustomV2`.

Type:

```hcl
object({
    cipher_suites        = optional(list(string))
    disabled_protocols   = optional(list(string))
    min_protocol_version = optional(string)
    policy_name          = optional(string)
    policy_type          = optional(string)
  })
```

Default: `null`

### <a name="input_ssl_profile"></a> [ssl\_profile](#input\_ssl\_profile)

Description: - `name` - (Required) The name of the SSL Profile that is unique within this Application Gateway.
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

Type:

```hcl
list(object({
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
```

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

### <a name="input_timeouts"></a> [timeouts](#input\_timeouts)

Description: - `create` - (Defaults to 90 minutes) Used when creating the Application Gateway.
- `delete` - (Defaults to 90 minutes) Used when deleting the Application Gateway.
- `read` - (Defaults to 5 minutes) Used when retrieving the Application Gateway.
- `update` - (Defaults to 90 minutes) Used when updating the Application Gateway.

Type:

```hcl
object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
```

Default: `null`

### <a name="input_trusted_client_certificate"></a> [trusted\_client\_certificate](#input\_trusted\_client\_certificate)

Description: - `data` - (Required) The base-64 encoded certificate.
- `name` - (Required) The name of the Trusted Client Certificate that is unique within this Application Gateway.

Type:

```hcl
list(object({
    data = string
    name = string
  }))
```

Default: `null`

### <a name="input_trusted_root_certificate"></a> [trusted\_root\_certificate](#input\_trusted\_root\_certificate)

Description: - `data` - (Optional) The contents of the Trusted Root Certificate which should be used. Required if `key_vault_secret_id` is not set.
- `key_vault_secret_id` - (Optional) The Secret ID of (base-64 encoded unencrypted pfx) `Secret` or `Certificate` object stored in Azure KeyVault. You need to enable soft delete for the Key Vault to use this feature. Required if `data` is not set.
- `name` - (Required) The Name of the Trusted Root Certificate to use.

Type:

```hcl
list(object({
    data                = optional(string)
    key_vault_secret_id = optional(string)
    name                = string
  }))
```

Default: `null`

### <a name="input_url_path_map"></a> [url\_path\_map](#input\_url\_path\_map)

Description: - `default_backend_address_pool_name` - (Optional) The Name of the Default Backend Address Pool which should be used for this URL Path Map. Cannot be set if `default_redirect_configuration_name` is set.
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

Type:

```hcl
list(object({
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
```

Default: `null`

### <a name="input_waf_configuration"></a> [waf\_configuration](#input\_waf\_configuration)

Description: - `enabled` - (Required) Is the Web Application Firewall enabled?
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

Type:

```hcl
object({
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
```

Default: `null`

### <a name="input_zones"></a> [zones](#input\_zones)

Description: (Optional) Specifies a list of Availability Zones in which this Application Gateway should be located. Changing this forces a new Application Gateway to be created.

Type: `set(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: This is the full output for the resource.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->