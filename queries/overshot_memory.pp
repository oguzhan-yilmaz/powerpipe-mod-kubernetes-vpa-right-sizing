query "vpa_memory_overshot_deployment" {
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
        bytes_to_mebi(memory_bytes(d.requests_memory))||'Mi' AS "Mem Request",
        bytes_to_mebi(memory_bytes(d.limits_memory))||'Mi' AS "Mem Limit",
        bytes_to_mebi(memory_bytes(r.lower_bound_memory))||'Mi' AS "Rec: Lower Mem",
        bytes_to_mebi(memory_bytes(r.target_memory))||'Mi' AS "Rec: Target Mem",
        -- bytes_to_mebi(memory_bytes(r.uncapped_target_memory))||'Mi' AS rec_uncapped_target_mem,
        bytes_to_mebi(memory_bytes(r.upper_bound_memory))||'Mi' AS "Rec: Upper Mem"
    FROM 
        deployment_data d
    JOIN 
        recommendation_data r
    ON 
        r.target_kind = 'Deployment'
        AND d.namespace = r.namespace 
        AND d.container_name = r.container_name
    WHERE
        bytes_to_mebi(memory_bytes(d.requests_memory)) > bytes_to_mebi(memory_bytes(r.target_memory));
  EOQ

}


query "vpa_memory_overshot_stateful_set" {
  sql = <<-EOQ
    WITH stateful_set_data AS (
        SELECT 
            namespace,
            name AS stateful_set_name,
            container->>'name' AS container_name,
            COALESCE(container->'resources'->'limits'->>'memory', NULL) AS limits_memory,
            COALESCE(container->'resources'->'requests'->>'memory', NULL) AS requests_memory
        FROM 
            kubernetes_stateful_set,
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
        d.stateful_set_name AS "StatefulSet",
        d.container_name AS "Container",
        bytes_to_mebi(memory_bytes(d.requests_memory))||'Mi' AS "Mem Request",
        bytes_to_mebi(memory_bytes(d.limits_memory))||'Mi' AS "Mem Limit",
        bytes_to_mebi(memory_bytes(r.lower_bound_memory))||'Mi' AS "Rec: Lower Mem",
        bytes_to_mebi(memory_bytes(r.target_memory))||'Mi' AS "Rec: Target Mem",
        bytes_to_mebi(memory_bytes(r.upper_bound_memory))||'Mi' AS "Rec: Upper Mem"
    FROM 
        stateful_set_data d
    JOIN 
        recommendation_data r
    ON 
        r.target_kind = 'stateful_set'
        AND d.namespace = r.namespace 
        AND d.container_name = r.container_name
    WHERE
        bytes_to_mebi(memory_bytes(d.requests_memory)) > bytes_to_mebi(memory_bytes(r.target_memory));
  EOQ

}


query "vpa_memory_overshot_daemonset" {
  sql = <<-EOQ
    WITH daemonset_data AS (
        SELECT 
            namespace,
            name AS daemonset_name,
            container->>'name' AS container_name,
            COALESCE(container->'resources'->'limits'->>'memory', NULL) AS limits_memory,
            COALESCE(container->'resources'->'requests'->>'memory', NULL) AS requests_memory
        FROM 
            kubernetes_daemonset,
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
        d.daemonset_name AS "DaemonSet",
        d.container_name AS "Container",
        bytes_to_mebi(memory_bytes(d.requests_memory))||'Mi' AS "Mem Request",
        bytes_to_mebi(memory_bytes(d.limits_memory))||'Mi' AS "Mem Limit",
        bytes_to_mebi(memory_bytes(r.lower_bound_memory))||'Mi' AS "Rec: Lower Mem",
        bytes_to_mebi(memory_bytes(r.target_memory))||'Mi' AS "Rec: Target Mem",
        bytes_to_mebi(memory_bytes(r.upper_bound_memory))||'Mi' AS "Rec: Upper Mem"
    FROM 
        daemonset_data d
    JOIN 
        recommendation_data r
    ON 
        r.target_kind = 'DaemonSet'
        AND d.namespace = r.namespace 
        AND d.container_name = r.container_name
    WHERE
        bytes_to_mebi(memory_bytes(d.requests_memory)) > bytes_to_mebi(memory_bytes(r.target_memory));
  EOQ

}