
dashboard "vpa_detail" {


  title = "VPA CPU & Memory"

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
    title = "VPA Detail"
    width = 12
    query = query.vpa_cpu_and_memory_detail
    args = {
      namespace = self.input.vpa_namespace.value,
      target_kind = self.input.vpa_target_kind.value
    }
  }
}

