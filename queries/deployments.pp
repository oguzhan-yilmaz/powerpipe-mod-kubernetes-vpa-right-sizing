
query "deployments" {
  sql = <<-EOQ
    SELECT 
        namespace,
        name AS deployment_name,
        container->>'name' AS container_name,
        COALESCE(container->'resources'->'requests'->>'cpu', NULL) AS requests_cpu,
        COALESCE(container->'resources'->'limits'->>'cpu', NULL) AS limits_cpu,
        COALESCE(container->'resources'->'requests'->>'memory', NULL) AS requests_memory,
        COALESCE(container->'resources'->'limits'->>'memory', NULL) AS limits_memory
    FROM 
        kubernetes_deployment,
        jsonb_array_elements(template::jsonb->'spec'->'containers') AS container
    WHERE 
        template IS NOT NULL;
  EOQ
}