
dashboard "vpa_detail" {

  title = "VPA CPU and Memory Recommendations"

  input "vpa_namespace" {
    title = "Select a Namespace:"
    query = query.vpa_namespace_input
    width = 4
  }

  table {
    title = "Deployment"
    width = 12
    query = query.vpa_cpu_and_memory_deployment
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }

  table {
    title = "StatefulSet"
    width = 12
    query = query.vpa_cpu_and_memory_stateful_set
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }
  
  table {
    title = "DaemonSet"
    width = 12
    query = query.vpa_cpu_and_memory_daemonset
    args = {
      namespace = self.input.vpa_namespace.value
    }
  }
  
}

