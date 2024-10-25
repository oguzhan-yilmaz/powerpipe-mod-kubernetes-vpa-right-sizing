
query "deployments" {
  sql = <<-EOQ
    SELECT 
        namespace AS "Namespace",
        name AS "Deployment",
        container->>'name' AS "Container",
        cpu_convert(COALESCE(container->'resources'->'requests'->>'cpu', NULL))||'m' AS "CPU Request",
        cpu_convert(COALESCE(container->'resources'->'limits'->>'cpu', NULL))||'m' AS "CPU Limit",
        bytes_to_mebi(memory_bytes(COALESCE(container->'resources'->'requests'->>'memory', NULL)))||'Mi' AS "Mem Request",
        bytes_to_mebi(memory_bytes(COALESCE(container->'resources'->'limits'->>'memory', NULL)))||'Mi' AS "Mem Limit"
    FROM 
        kubernetes_deployment,
        jsonb_array_elements(template::jsonb->'spec'->'containers') AS container
    WHERE 
        template IS NOT NULL;
  EOQ
}