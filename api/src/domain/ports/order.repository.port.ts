import { Order, OrderItem } from '../models/order.model';
import { OrderStatus } from '../types/order-status.type';

export interface OrderRepositoryPort {
  create(order: Order): Promise<Order>;
  findById(id: string): Promise<Order | null>;
  update(id: string, order: Partial<Order>): Promise<Order>;
  delete(id: string): Promise<void>;
  findByCustomerId(customerId: string): Promise<Order[]>;
  findByStatus(status: OrderStatus): Promise<Order[]>;
}

export interface OrderItemRepositoryPort {
  findByOrderId(orderId: string): Promise<OrderItem[]>;
  create(orderId: string, item: OrderItem): Promise<OrderItem>;
  deleteByOrderId(orderId: string): Promise<void>;
}