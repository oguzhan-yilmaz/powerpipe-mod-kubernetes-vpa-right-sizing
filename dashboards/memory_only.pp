

dashboard "vpa_memory_only" {
  
  title = "VPA Only Memory"
  input "vpa_namespace" {
    title = "Select a Namespace:"
    query = query.vpa_namespace_input
    width = 4
  }
  
  input "vpa_target_kind" {
    title = "Select a Type:"
    query = query.vpa_target_kind_input
    width = 4
  }

  table {
    title = "VPA Memory Recommendations"
    width = 15
    query = query.vpa_memory_only
    args = {
      namespace = self.input.vpa_namespace.value,
      target_kind = self.input.vpa_target_kind.value
    }
  }
}
