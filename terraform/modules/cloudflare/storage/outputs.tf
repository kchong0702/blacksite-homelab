output "bucket_names" {
  description = "Names of the buckets created."
  value       = keys(cloudflare_r2_bucket.this)
}
