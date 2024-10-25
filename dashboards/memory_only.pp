dashboard "vpa_memory_only" {
  
  title = "VPA Memory Recommendations"
  input "vpa_namespace" {
    title = "Select a Namespace:"
    query = query.vpa_namespace_input
    width = 4
  }
  
  table {
    title = "Deployment"
    width = 12
    query = query.vpa_memory_only_deployment
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }

  table {
    title = "Stateful Set"
    width = 12
    query = query.vpa_memory_only_stateful_set
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }


  table {
    title = "Daemon Set"
    width = 12
    query = query.vpa_memory_only_daemonset
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }
}
