dashboard "vpa_memory_overshot" {
  
  title = "VPA Memory Overshot"
  
  table {
    title = "Deployment"
    width = 12
    query = query.vpa_memory_overshot_deployment
  }

  table {
    title = "Stateful Set"
    width = 12
    query = query.vpa_memory_overshot_stateful_set
  }


  table {
    title = "Daemon Set"
    width = 12
    query = query.vpa_memory_overshot_daemonset
  }
}
