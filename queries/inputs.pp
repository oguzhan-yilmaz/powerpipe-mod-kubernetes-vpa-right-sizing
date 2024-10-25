query "vpa_target_kind_input" {
  sql = <<-EOQ
    select
     distinct target_ref->>'kind' as label,
     target_ref->>'kind' as value
    from
      kubernetes_verticalpodautoscaler
    order by
      target_ref->>'kind' DESC;
  EOQ
}


query "vpa_namespace_input" {
  sql = <<-EOQ
    select
     distinct name as label,
     name as value
    from
      kubernetes_namespace
    order by
      name;
  EOQ
}