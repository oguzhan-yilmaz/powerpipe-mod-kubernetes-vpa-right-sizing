


query "non_vpa_deployments" {
  sql = <<-EOQ
    WITH deployment_data AS (
        SELECT 
            namespace,
            name,
            container->>'name' AS container_name 
        FROM 
            kubernetes_deployment,
            jsonb_array_elements(template::jsonb->'spec'->'containers') AS container
    ),
    recommendation_data AS (
        SELECT 
            namespace,
            name,
            container_recommendation ->> 'containerName' AS container_name
        FROM 
            kubernetes_verticalpodautoscaler,
            jsonb_array_elements(recommendation::jsonb -> 'containerRecommendations') AS container_recommendation
    )
    SELECT 
        d.namespace  AS "Namespace",
        d.name  AS "Deployment Name",
        d.container_name AS "Container Name"
    FROM 
        deployment_data d
    LEFT JOIN 
        recommendation_data r
    ON 
        d.namespace = r.namespace 
        AND d.container_name = r.container_name
    WHERE
        r.name IS NULL;
  EOQ
}



query "non_vpa_statefulsets" {
  sql = <<-EOQ
    WITH statefulset_data AS (
        SELECT 
            namespace,
            name,
            container->>'name' AS container_name 
        FROM 
            kubernetes_stateful_set,
            jsonb_array_elements(template::jsonb->'spec'->'containers') AS container
    ),
    recommendation_data AS (
        SELECT 
            namespace,
            name,
            container_recommendation ->> 'containerName' AS container_name
        FROM 
            kubernetes_verticalpodautoscaler,
            jsonb_array_elements(recommendation::jsonb -> 'containerRecommendations') AS container_recommendation
    )
    SELECT 
        d.namespace  AS "Namespace",
        d.name  AS "StatefulSet Name",
        d.container_name AS "Container Name"
    FROM 
        statefulset_data d
    LEFT JOIN 
        recommendation_data r
    ON 
        d.namespace = r.namespace 
        AND d.container_name = r.container_name
    WHERE
        r.name IS NULL;
  EOQ
}




query "non_vpa_daemonsets" {
  sql = <<-EOQ
    WITH daemonset_data AS (
        SELECT 
            namespace,
            name,
            container->>'name' AS container_name 
        FROM 
            kubernetes_daemonset,
            jsonb_array_elements(template::jsonb->'spec'->'containers') AS container
    ),
    recommendation_data AS (
        SELECT 
            namespace,
            name,
            container_recommendation ->> 'containerName' AS container_name
        FROM 
            kubernetes_verticalpodautoscaler,
            jsonb_array_elements(recommendation::jsonb -> 'containerRecommendations') AS container_recommendation
    )
    SELECT 
        d.namespace  AS "Namespace",
        d.name  AS "DaemonSet Name",
        d.container_name AS "Container Name"
    FROM 
        daemonset_data d
    LEFT JOIN 
        recommendation_data r
    ON 
        d.namespace = r.namespace 
        AND d.container_name = r.container_name
    WHERE
        r.name IS NULL;
  EOQ
}