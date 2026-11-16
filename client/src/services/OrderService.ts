import axios from 'axios';
import { CreateOrderDto, Order, UpdateOrderDto } from '../types/order';

const API_BASE_URL = 'http://localhost:3000';

export class OrderService {
  static async createOrder(orderData: CreateOrderDto): Promise<Order> {
    const response = await axios.post(`${API_BASE_URL}/orders`, orderData);
    return response.data;
  }

  static async getOrder(orderId: string): Promise<Order> {
    const response = await axios.get(`${API_BASE_URL}/orders/${orderId}`);
    return response.data;
  }

  static async updateOrder(orderId: string, updateData: UpdateOrderDto): Promise<Order> {
    const response = await axios.put(`${API_BASE_URL}/orders/${orderId}`, updateData);
    return response.data;
  }

  static async deleteOrder(orderId: string): Promise<void> {
    await axios.delete(`${API_BASE_URL}/orders/${orderId}`);
  }
}