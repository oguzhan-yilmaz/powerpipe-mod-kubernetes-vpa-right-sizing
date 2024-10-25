

dashboard "vpa_cpu_undershot" {
  
  title = "VPA CPU Undershot"

  table {
    title = "Deployments"
    width = 12
    query = query.vpa_cpu_undershot_deployment
  }

  table {
    title = "Stateful Sets"
    width = 12
    query = query.vpa_cpu_undershot_statefulset
  }

  table {
    title = "Daemon Sets"
    width = 12
    query = query.vpa_cpu_undershot_daemonset
  }


}
