

query "vpa_cpu_and_memory_detail" {

  sql = <<-EOQ
    SELECT 
        namespace,
        name,
        target_ref->>'name' AS target_name,
        target_ref->>'kind' AS target_kind,
        -- target_ref->>'apiVersion' AS target_api_version, 
        update_policy->>'updateMode' AS update_mode,
        container_recommendation ->> 'containerName' AS container_name,

        cpu_convert(container_recommendation -> 'lowerBound' ->> 'cpu')||'m' AS lower_bound_cpu,
        cpu_convert(container_recommendation -> 'target' ->> 'cpu')||'m' AS target_cpu,
        -- cpu_convert(container_recommendation -> 'uncappedTarget' ->> 'cpu')||'m' AS uncapped_target_cpu,
        cpu_convert(container_recommendation -> 'upperBound' ->> 'cpu')||'m' AS upper_bound_cpu,

        bytes_to_mebi(memory_bytes(container_recommendation -> 'lowerBound' ->> 'memory'))||'Mi' AS lower_bound_memory,
        bytes_to_mebi(memory_bytes(container_recommendation -> 'target' ->> 'memory'))||'Mi' AS target_memory,
        bytes_to_mebi(memory_bytes(container_recommendation -> 'uncappedTarget' ->> 'memory'))||'Mi' AS uncapped_target_memory,
        bytes_to_mebi(memory_bytes(container_recommendation -> 'upperBound' ->> 'memory'))||'Mi' AS upper_bound_memory
    FROM 
        kubernetes_verticalpodautoscaler,
        jsonb_array_elements(recommendation::jsonb -> 'containerRecommendations') AS container_recommendation
    WHERE 
      target_ref->>'kind' = $1
      AND namespace = $2
      AND update_policy->>'updateMode' = 'Off';
  EOQ

  param "target_kind" {}
  param "namespace" {}
}













query "vpa_cpu_and_memory" {
  sql = <<-EOQ
    SELECT 
        namespace,
        name,
        target_ref->>'name' AS target_name,
        target_ref->>'kind' AS target_kind,
        -- target_ref->>'apiVersion' AS target_api_version, 
        update_policy->>'updateMode' AS update_mode,
        container_recommendation ->> 'containerName' AS container_name,
        container_recommendation -> 'lowerBound' ->> 'cpu' AS lower_bound_cpu,
        container_recommendation -> 'lowerBound' ->> 'memory' AS lower_bound_memory,
        container_recommendation -> 'target' ->> 'cpu' AS target_cpu,
        container_recommendation -> 'target' ->> 'memory' AS target_memory,
        container_recommendation -> 'uncappedTarget' ->> 'cpu' AS uncapped_target_cpu,
        container_recommendation -> 'uncappedTarget' ->> 'memory' AS uncapped_target_memory,
        container_recommendation -> 'upperBound' ->> 'cpu' AS upper_bound_cpu,
        container_recommendation -> 'upperBound' ->> 'memory' AS upper_bound_memory
    FROM 
        kubernetes_verticalpodautoscaler,
        jsonb_array_elements(recommendation::jsonb -> 'containerRecommendations') AS container_recommendation
    WHERE 
      update_policy->>'updateMode' = 'Off';
  EOQ
}
