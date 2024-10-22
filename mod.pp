mod "kubernetes_vpa_right_sizing" {
  title         = "Kubernetes VPA Right Sizing"
  description   = ""
  color         = "#0089A6"
  documentation = file("./docs/index.md")
  // icon          = "/images/mods/turbot/kubernetes-insights.svg"
  categories = ["kubernetes", "cost-optimization", "dashboard"]
  // opengraph {
  //   title       = "Powerpipe Mod for Kubernetes Insights"
  //   description = "Create dashboards and reports for your Kubernetes resources using Powerpipe and Steampipe."
  //   image       = "/images/mods/turbot/kubernetes-insights-social-graphic.png"
  // }
  require {
    plugin "kubernetes" {
      min_version = "0.29.0"
    }
  }
}