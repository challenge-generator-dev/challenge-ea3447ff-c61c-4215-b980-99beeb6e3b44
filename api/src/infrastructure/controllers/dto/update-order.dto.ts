import { IsEnum, IsNotEmpty } from 'class-validator';
import { OrderStatus } from '../../../domain/types/order-status.type';

export class UpdateOrderDto {
  @IsEnum(OrderStatus)
  @IsNotEmpty()
  status: OrderStatus;

  constructor(status: OrderStatus) {
    this.status = status;
    this.validateInvariants();
  }

  private validateInvariants(): void {
    if (!this.status) {
      throw new Error('Status is required');
    }
    const validStatuses = Object.values(OrderStatus);
    if (!validStatuses.includes(this.status)) {
      throw new Error('Invalid order status');
    }
  }
}