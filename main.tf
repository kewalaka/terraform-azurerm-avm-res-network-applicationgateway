resource "azurerm_application_gateway" "this" {
  location                          = var.location
  name                              = var.name
  resource_group_name               = var.resource_group_name
  enable_http2                      = var.enable_http2
  fips_enabled                      = var.fips_enabled
  firewall_policy_id                = var.firewall_policy_id
  force_firewall_policy_association = var.force_firewall_policy_association
  tags                              = var.tags
  zones                             = var.zones

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool == null ? [] : var.backend_address_pool
    content {
      name         = backend_address_pool.value.name
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }
  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings == null ? [] : var.backend_http_settings
    content {
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      name                                = backend_http_settings.value.name
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      host_name                           = backend_http_settings.value.host_name
      path                                = backend_http_settings.value.path
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      probe_name                          = backend_http_settings.value.probe_name
      request_timeout                     = backend_http_settings.value.request_timeout
      trusted_root_certificate_names      = backend_http_settings.value.trusted_root_certificate_names

      dynamic "authentication_certificate" {
        for_each = backend_http_settings.value.authentication_certificate == null ? [] : backend_http_settings.value.authentication_certificate
        content {
          name = authentication_certificate.value.name
        }
      }
      dynamic "connection_draining" {
        for_each = backend_http_settings.value.connection_draining == null ? [] : [backend_http_settings.value.connection_draining]
        content {
          drain_timeout_sec = connection_draining.value.drain_timeout_sec
          enabled           = connection_draining.value.enabled
        }
      }
    }
  }
  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration
    content {
      name                            = frontend_ip_configuration.value.name
      private_ip_address              = frontend_ip_configuration.value.private_ip_address
      private_ip_address_allocation   = frontend_ip_configuration.value.private_ip_address_allocation
      private_link_configuration_name = frontend_ip_configuration.value.private_link_configuration_name
      public_ip_address_id            = frontend_ip_configuration.value.public_ip_address_id
      subnet_id                       = frontend_ip_configuration.value.subnet_id
    }
  }
  dynamic "frontend_port" {
    for_each = var.frontend_port == null ? [] : var.frontend_port
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }
  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configuration
    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = gateway_ip_configuration.value.subnet_id
    }
  }
  dynamic "http_listener" {
    for_each = var.http_listener == null ? [] : var.http_listener
    content {
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      name                           = http_listener.value.name
      protocol                       = http_listener.value.protocol
      firewall_policy_id             = http_listener.value.firewall_policy_id
      host_name                      = http_listener.value.host_name
      host_names                     = http_listener.value.host_names
      require_sni                    = http_listener.value.require_sni
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
      ssl_profile_name               = http_listener.value.ssl_profile_name

      dynamic "custom_error_configuration" {
        for_each = http_listener.value.custom_error_configuration == null ? [] : http_listener.value.custom_error_configuration
        content {
          custom_error_page_url = custom_error_configuration.value.custom_error_page_url
          status_code           = custom_error_configuration.value.status_code
        }
      }
    }
  }
  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule == null ? [] : var.request_routing_rule
    content {
      http_listener_name          = request_routing_rule.value.http_listener_name
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      priority                    = request_routing_rule.value.priority
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
      url_path_map_name           = request_routing_rule.value.url_path_map_name
    }
  }
  dynamic "sku" {
    for_each = [var.sku]
    content {
      name     = sku.value.name
      tier     = sku.value.tier
      capacity = sku.value.capacity
    }
  }
  dynamic "authentication_certificate" {
    for_each = var.authentication_certificate == null ? [] : var.authentication_certificate
    content {
      data = authentication_certificate.value.data
      name = authentication_certificate.value.name
    }
  }
  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration == null ? [] : [var.autoscale_configuration]
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }
  dynamic "custom_error_configuration" {
    for_each = var.custom_error_configuration == null ? [] : var.custom_error_configuration
    content {
      custom_error_page_url = custom_error_configuration.value.custom_error_page_url
      status_code           = custom_error_configuration.value.status_code
    }
  }
  dynamic "global" {
    for_each = var.global == null ? [] : [var.global]
    content {
      request_buffering_enabled  = global.value.request_buffering_enabled
      response_buffering_enabled = global.value.response_buffering_enabled
    }
  }
  dynamic "identity" {
    for_each = local.managed_identities.user_assigned
    content {
      type         = identity.value.type
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
  dynamic "private_link_configuration" {
    for_each = var.private_link_configuration == null ? [] : var.private_link_configuration
    content {
      name = private_link_configuration.value.name

      dynamic "ip_configuration" {
        for_each = private_link_configuration.value.ip_configuration
        content {
          name                          = ip_configuration.value.name
          primary                       = ip_configuration.value.primary
          private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
          subnet_id                     = ip_configuration.value.subnet_id
          private_ip_address            = ip_configuration.value.private_ip_address
        }
      }
    }
  }
  dynamic "probe" {
    for_each = var.probe == null ? [] : var.probe
    content {
      interval                                  = probe.value.interval
      name                                      = probe.value.name
      path                                      = probe.value.path
      protocol                                  = probe.value.protocol
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      host                                      = probe.value.host
      minimum_servers                           = probe.value.minimum_servers
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      port                                      = probe.value.port

      dynamic "match" {
        for_each = probe.value.match == null ? [] : [probe.value.match]
        content {
          status_code = match.value.status_code
          body        = match.value.body
        }
      }
    }
  }
  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration == null ? [] : var.redirect_configuration
    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
      target_listener_name = redirect_configuration.value.target_listener_name
      target_url           = redirect_configuration.value.target_url
    }
  }
  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_set == null ? [] : var.rewrite_rule_set
    content {
      name = rewrite_rule_set.value.name

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rule == null ? [] : rewrite_rule_set.value.rewrite_rule
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "condition" {
            for_each = rewrite_rule.value.condition == null ? [] : rewrite_rule.value.condition
            content {
              pattern     = condition.value.pattern
              variable    = condition.value.variable
              ignore_case = condition.value.ignore_case
              negate      = condition.value.negate
            }
          }
          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value.request_header_configuration == null ? [] : rewrite_rule.value.request_header_configuration
            content {
              header_name  = request_header_configuration.value.header_name
              header_value = request_header_configuration.value.header_value
            }
          }
          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_header_configuration == null ? [] : rewrite_rule.value.response_header_configuration
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value
            }
          }
          dynamic "url" {
            for_each = rewrite_rule.value.url == null ? [] : [rewrite_rule.value.url]
            content {
              components   = url.value.components
              path         = url.value.path
              query_string = url.value.query_string
              reroute      = url.value.reroute
            }
          }
        }
      }
    }
  }
  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate == null ? [] : var.ssl_certificate
    content {
      name                = ssl_certificate.value.name
      data                = ssl_certificate.value.data
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
      password            = ssl_certificate.value.password
    }
  }
  dynamic "ssl_policy" {
    for_each = var.ssl_policy == null ? [] : [var.ssl_policy]
    content {
      cipher_suites        = ssl_policy.value.cipher_suites
      disabled_protocols   = ssl_policy.value.disabled_protocols
      min_protocol_version = ssl_policy.value.min_protocol_version
      policy_name          = ssl_policy.value.policy_name
      policy_type          = ssl_policy.value.policy_type
    }
  }
  dynamic "ssl_profile" {
    for_each = var.ssl_profile == null ? [] : var.ssl_profile
    content {
      name                                 = ssl_profile.value.name
      trusted_client_certificate_names     = ssl_profile.value.trusted_client_certificate_names
      verify_client_cert_issuer_dn         = ssl_profile.value.verify_client_cert_issuer_dn
      verify_client_certificate_revocation = ssl_profile.value.verify_client_certificate_revocation

      dynamic "ssl_policy" {
        for_each = ssl_profile.value.ssl_policy == null ? [] : [ssl_profile.value.ssl_policy]
        content {
          cipher_suites        = ssl_policy.value.cipher_suites
          disabled_protocols   = ssl_policy.value.disabled_protocols
          min_protocol_version = ssl_policy.value.min_protocol_version
          policy_name          = ssl_policy.value.policy_name
          policy_type          = ssl_policy.value.policy_type
        }
      }
    }
  }
  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
  dynamic "trusted_client_certificate" {
    for_each = var.trusted_client_certificate == null ? [] : var.trusted_client_certificate
    content {
      data = trusted_client_certificate.value.data
      name = trusted_client_certificate.value.name
    }
  }
  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificate == null ? [] : var.trusted_root_certificate
    content {
      name                = trusted_root_certificate.value.name
      data                = trusted_root_certificate.value.data
      key_vault_secret_id = trusted_root_certificate.value.key_vault_secret_id
    }
  }
  dynamic "url_path_map" {
    for_each = var.url_path_map == null ? [] : var.url_path_map
    content {
      name                                = url_path_map.value.name
      default_backend_address_pool_name   = url_path_map.value.default_backend_address_pool_name
      default_backend_http_settings_name  = url_path_map.value.default_backend_http_settings_name
      default_redirect_configuration_name = url_path_map.value.default_redirect_configuration_name
      default_rewrite_rule_set_name       = url_path_map.value.default_rewrite_rule_set_name

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rule
        content {
          name                        = path_rule.value.name
          paths                       = path_rule.value.paths
          backend_address_pool_name   = path_rule.value.backend_address_pool_name
          backend_http_settings_name  = path_rule.value.backend_http_settings_name
          firewall_policy_id          = path_rule.value.firewall_policy_id
          redirect_configuration_name = path_rule.value.redirect_configuration_name
          rewrite_rule_set_name       = path_rule.value.rewrite_rule_set_name
        }
      }
    }
  }
  dynamic "waf_configuration" {
    for_each = var.waf_configuration == null ? [] : [var.waf_configuration]
    content {
      enabled                  = waf_configuration.value.enabled
      firewall_mode            = waf_configuration.value.firewall_mode
      rule_set_version         = waf_configuration.value.rule_set_version
      file_upload_limit_mb     = waf_configuration.value.file_upload_limit_mb
      max_request_body_size_kb = waf_configuration.value.max_request_body_size_kb
      request_body_check       = waf_configuration.value.request_body_check
      rule_set_type            = waf_configuration.value.rule_set_type

      dynamic "disabled_rule_group" {
        for_each = waf_configuration.value.disabled_rule_group == null ? [] : waf_configuration.value.disabled_rule_group
        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }
      dynamic "exclusion" {
        for_each = waf_configuration.value.exclusion == null ? [] : waf_configuration.value.exclusion
        content {
          match_variable          = exclusion.value.match_variable
          selector                = exclusion.value.selector
          selector_match_operator = exclusion.value.selector_match_operator
        }
      }
    }
  }
}



# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_application_gateway.this.id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_application_gateway.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}
