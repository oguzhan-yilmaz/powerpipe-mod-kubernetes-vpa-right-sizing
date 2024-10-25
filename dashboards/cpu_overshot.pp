

dashboard "vpa_cpu_overshot" {
  
  title = "VPA CPU Overshot"

  table {
    title = "Deployments"
    width = 12
    query = query.vpa_cpu_overshot_deployment
  }

  table {
    title = "Stateful Sets"
    width = 12
    query = query.vpa_cpu_overshot_statefulset
  }

  table {
    title = "Daemon Sets"
    width = 12
    query = query.vpa_cpu_overshot_daemonset
  }


}
