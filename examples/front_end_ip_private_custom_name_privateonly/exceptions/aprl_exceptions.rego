package Azure_Proactive_Resiliency_Library_v2

import rego.v1

# APRL policy bug: policy checks min_capacity (snake_case) but azapi body uses minCapacity (camelCase)
exception contains rules if {
  rules := ["deny_application_gateway_ensure_autoscale_feature_has_been_enabled"]
}
