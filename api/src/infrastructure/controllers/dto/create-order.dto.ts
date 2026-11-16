import { IsArray, IsNotEmpty, IsNumber, IsPositive, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { OrderStatus } from '../../../domain/types/order-status.type';

class OrderItemDto {
  @IsString()
  @IsNotEmpty()
  productId: string;

  @IsNumber()
  @IsPositive()
  quantity: number;

  @IsNumber()
  @IsPositive()
  price: number;
}

export class CreateOrderDto {
  @IsString()
  @IsNotEmpty()
  customerId: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrderItemDto)
  items: OrderItemDto[];

  constructor(customerId: string, items: OrderItemDto[]) {
    this.customerId = customerId;
    this.items = items;
    this.validateInvariants();
  }

  private validateInvariants(): void {
    if (!this.customerId) {
      throw new Error('CustomerId is required');
    }
    if (!this.items || this.items.length === 0) {
      throw new Error('Order must have at least one item');
    }
    this.items.forEach(item => {
      if (item.quantity <= 0) {
        throw new Error('Quantity must be greater than 0');
      }
      if (item.price <= 0) {
        throw new Error('Price must be greater than 0');
      }
    });
  }
}