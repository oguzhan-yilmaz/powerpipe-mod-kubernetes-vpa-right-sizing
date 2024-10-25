dashboard "vpa_memory_undershot" {
  
  title = "VPA Memory Undershot"
  
  table {
    title = "Deployment"
    width = 12
    query = query.vpa_memory_undershot_deployment
  }

  table {
    title = "Stateful Set"
    width = 12
    query = query.vpa_memory_undershot_stateful_set
  }


  table {
    title = "Daemon Set"
    width = 12
    query = query.vpa_memory_undershot_daemonset
  }
}
