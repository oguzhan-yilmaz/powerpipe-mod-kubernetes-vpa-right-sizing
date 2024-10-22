query "vpa_summary" {
  sql = <<-EOQ
    SELECT 
        namespace,
        name,
        container_recommendation ->> 'containerName' AS container_name,
        container_recommendation -> 'lowerBound' ->> 'cpu' AS lower_bound_cpu,
        container_recommendation -> 'target' ->> 'cpu' AS target_cpu,
        container_recommendation -> 'uncappedTarget' ->> 'cpu' AS uncapped_target_cpu,
        container_recommendation -> 'upperBound' ->> 'cpu' AS upper_bound_cpu,
        container_recommendation -> 'lowerBound' ->> 'memory' AS lower_bound_memory,
        container_recommendation -> 'target' ->> 'memory' AS target_memory,
        container_recommendation -> 'uncappedTarget' ->> 'memory' AS uncapped_target_memory,
        container_recommendation -> 'upperBound' ->> 'memory' AS upper_bound_memory
    FROM 
        kubernetes_verticalpodautoscaler,
        jsonb_array_elements(recommendation::jsonb -> 'containerRecommendations') AS container_recommendation;
  EOQ
}