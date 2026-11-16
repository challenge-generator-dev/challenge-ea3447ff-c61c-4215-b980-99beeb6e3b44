# Outputs del módulo DynamoDB
# Estos outputs exponen los atributos necesarios para que otros módulos
# puedan referenciar la tabla DynamoDB creada.

output "table_arn" {
  description = "ARN de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.arn
}

output "table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.name
}

output "table_id" {
  description = "ID de la tabla DynamoDB"
  value       = aws_dynamodb_table.orders_table.id
}

output "stream_arn" {
  description = "ARN del stream de la tabla DynamoDB (si está habilitado)"
  value       = var.enable_stream ? aws_dynamodb_table.orders_table.stream_arn : null
}

output "stream_label" {
  description = "Etiqueta del stream de la tabla DynamoDB (si está habilitado)"
  value       = var.enable_stream ? aws_dynamodb_table.orders_table.stream_label : null
}

output "global_secondary_index_names" {
  description = "Nombres de los índices secundarios globales"
  value       = [for idx in aws_dynamodb_table.orders_table.global_secondary_index : idx.name]
}