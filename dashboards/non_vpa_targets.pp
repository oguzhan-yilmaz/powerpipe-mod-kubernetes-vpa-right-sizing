dashboard "non_vpa_targets" {
  
  title = "VPA -- Not Enabled"

  table {
    title = "NO VPA -- Deployments"
    width = 12
    query = query.non_vpa_deployments
  }


  table {
    title = "NO VPA -- Stateful Sets"
    width = 12
    query = query.non_vpa_statefulsets
  }

  table {
    title = "NO VPA -- Daemon Sets"
    width = 12
    query = query.non_vpa_daemonsets
  }

}
