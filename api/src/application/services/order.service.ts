import { Injectable, Inject } from '@nestjs/common';
import { Order } from '../../domain/models/order.model';
import { OrderRepositoryPort } from '../../domain/ports/order.repository.port';
import { OrderStatus } from '../../domain/types/order-status.type';
import { CreateOrderDto } from '../../infrastructure/controllers/dto/create-order.dto';
import { UpdateOrderDto } from '../../infrastructure/controllers/dto/update-order.dto';

@Injectable()
export class OrderService {
  constructor(@Inject('OrderRepositoryPort') private readonly orderRepository: OrderRepositoryPort) {}

  async createOrder(createOrderDto: CreateOrderDto): Promise<Order> {
    // TODO(reto): Implementar la lógica para crear una orden
    // - Validar que los items no estén vacíos
    // - Calcular el precio total de la orden
    // - Crear la orden con estado PENDING
    // - Persistir la orden usando el repositorio
    throw new Error('Method not implemented');
  }

  async getOrder(id: string): Promise<Order> {
    // TODO(reto): Implementar la lógica para obtener una orden por ID
    // - Usar el repositorio para buscar la orden
    // - Lanzar excepción si no existe
    throw new Error('Method not implemented');
  }

  async updateOrder(id: string, updateOrderDto: UpdateOrderDto): Promise<Order> {
    // TODO(reto): Implementar la lógica para actualizar una orden
    // - Validar que el nuevo estado sea válido
    // - Actualizar la orden usando el repositorio
    throw new Error('Method not implemented');
  }

  async deleteOrder(id: string): Promise<void> {
    // TODO(reto): Implementar la lógica para eliminar una orden
    // - Usar el repositorio para eliminar la orden
    throw new Error('Method not implemented');
  }
}