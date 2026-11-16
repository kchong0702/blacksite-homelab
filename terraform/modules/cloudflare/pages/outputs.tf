output "subdomain" {
  description = "The project's pages.dev subdomain."
  value       = cloudflare_pages_project.this.subdomain
}
