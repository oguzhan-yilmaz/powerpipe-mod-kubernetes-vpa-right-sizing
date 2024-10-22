query "vpa_memory_only" {


  sql = <<-EOQ
    WITH deployment_data AS (
        SELECT 
            namespace,
            name AS deployment_name,
            container->>'name' AS container_name,
            COALESCE(container->'resources'->'limits'->>'memory', NULL) AS limits_memory,
            COALESCE(container->'resources'->'requests'->>'memory', NULL) AS requests_memory
        FROM 
            kubernetes_deployment,
            jsonb_array_elements(template::jsonb->'spec'->'containers') AS container
    ),
    recommendation_data AS (
        SELECT 
            namespace,
            name,
            target_ref->>'name' AS target_name,
            target_ref->>'kind' AS target_kind,
            target_ref->>'apiVersion' AS target_api_version, 
            update_policy->>'updateMode' AS update_mode,
            container_recommendation ->> 'containerName' AS container_name,
            container_recommendation -> 'lowerBound' ->> 'memory' AS lower_bound_memory,
            container_recommendation -> 'target' ->> 'memory' AS target_memory,
            container_recommendation -> 'uncappedTarget' ->> 'memory' AS uncapped_target_memory,
            container_recommendation -> 'upperBound' ->> 'memory' AS upper_bound_memory
        FROM 
            kubernetes_verticalpodautoscaler,
            jsonb_array_elements(recommendation::jsonb -> 'containerRecommendations') AS container_recommendation
    )
    SELECT 
        d.namespace AS "Namespace",
        d.deployment_name AS "Deployment",
        d.container_name AS "Container",
        -- d.requests_memory AS "Real RAM Request",
        bytes_to_mebi(memory_bytes(d.requests_memory))||'Mi' AS "RAM Request",
        bytes_to_mebi(memory_bytes(d.limits_memory))||'Mi' AS "RAM Limit",
        bytes_to_mebi(memory_bytes(r.lower_bound_memory))||'Mi' AS "Rec: Lower RAM",
        bytes_to_mebi(memory_bytes(r.target_memory))||'Mi' AS "Rec: Target RAM",
        -- bytes_to_mebi(memory_bytes(r.uncapped_target_memory))||'Mi' AS rec_uncapped_target_mem,
        bytes_to_mebi(memory_bytes(r.upper_bound_memory))||'Mi' AS "Rec: Upper RAM"
    FROM 
        deployment_data d
    JOIN 
        recommendation_data r
    ON 
        r.target_kind = $1
        AND r.namespace =  $2
        AND d.namespace = r.namespace 
        AND d.container_name = r.container_name;
  EOQ

  param "namespace" {}
  param "target_kind" {}
}