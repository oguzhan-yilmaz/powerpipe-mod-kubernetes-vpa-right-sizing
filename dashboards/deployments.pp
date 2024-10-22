

dashboard "vpa_deployments" {
  title = "Deployments: Limits and Requests"
  table {
    title = "Deployments: Limits and Requests"
    width = 15
    query = query.deployments
  }
}
