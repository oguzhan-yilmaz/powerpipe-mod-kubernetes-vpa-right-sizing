


query "vpa_cpu_only" {
  sql = <<-EOQ
    WITH deployment_data AS (
        SELECT 
            namespace,
            name AS deployment_name,
            container->>'name' AS container_name,
            COALESCE(container->'resources'->'limits'->>'cpu', NULL) AS limits_cpu,
            COALESCE(container->'resources'->'requests'->>'cpu', NULL) AS requests_cpu
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
            container_recommendation -> 'lowerBound' ->> 'cpu' AS lower_bound_cpu,
            container_recommendation -> 'target' ->> 'cpu' AS target_cpu,
            container_recommendation -> 'uncappedTarget' ->> 'cpu' AS uncapped_target_cpu,
            container_recommendation -> 'upperBound' ->> 'cpu' AS upper_bound_cpu
        FROM 
            kubernetes_verticalpodautoscaler,
            jsonb_array_elements(recommendation::jsonb -> 'containerRecommendations') AS container_recommendation
    )
    SELECT 
        -- r.*,
        d.namespace AS "Namespace",
        d.deployment_name AS "Deployment",
        d.container_name AS "Container",
        cpu_convert(d.requests_cpu)||'m' AS "Real CPU Request",
        cpu_convert(d.limits_cpu)||'m' AS "Real CPU Limit",
        cpu_convert(r.lower_bound_cpu)||'m' AS "Rec: Lower CPU",
        cpu_convert(r.target_cpu)||'m' AS "Rec: Target CPU",
        cpu_convert(r.upper_bound_cpu)||'m' AS "Rec: Upper CPU"

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
