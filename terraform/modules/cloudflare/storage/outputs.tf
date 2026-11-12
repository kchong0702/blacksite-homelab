output "bucket_names" {
  value = keys(cloudflare_r2_bucket.this)
}
