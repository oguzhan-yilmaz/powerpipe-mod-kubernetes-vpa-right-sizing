

dashboard "vpa_cpu_only" {
  
  title = "VPA CPU Recommendations"
  
  input "vpa_namespace" {
    title = "Select a Namespace:"
    query = query.vpa_namespace_input
    width = 4
  }

  table {
    title = "Deployments"
    width = 12
    query = query.vpa_cpu_only_deployment
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }

  table {
    title = "Stateful Sets"
    width = 12
    query = query.vpa_cpu_only_statefulset
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }

  table {
    title = "Daemon Sets"
    width = 12
    query = query.vpa_cpu_only_daemonset
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }


}
